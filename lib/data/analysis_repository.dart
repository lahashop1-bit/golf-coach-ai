import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:analysis_core/analysis_core.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:pose/pose.dart';
import 'package:uuid/uuid.dart';

import '../domain/enums.dart';
import 'db/database.dart';
import 'video_store.dart';

/// Native pose estimation, behind an interface so tests can fake it.
abstract class PoseEngine {
  Future<PoseRunResult> run(String jobId, String videoPath, String outputPath,
      void Function(double) onProgress);
  Future<void> cancel(String jobId);
}

class MediaPipePoseEngine implements PoseEngine {
  MediaPipePoseEngine([Pose? pose]) : _pose = pose ?? Pose();
  final Pose _pose;

  @override
  Future<PoseRunResult> run(String jobId, String videoPath, String outputPath,
          void Function(double) onProgress) =>
      _pose.analyzeVideo(
          jobId: jobId, videoPath: videoPath, outputPath: outputPath, onProgress: onProgress);

  @override
  Future<void> cancel(String jobId) => _pose.cancel(jobId);
}

/// Decoded view of a stored analysis.
class AnalysisResult {
  AnalysisResult(this.row)
      : phases = row.phasesJson == null
            ? const []
            : [
                for (final j in jsonDecode(row.phasesJson!) as List)
                  PhaseMark.fromJson((j as Map).cast<String, Object?>()),
              ],
        tempo = row.tempoJson == null
            ? null
            : Tempo.fromJson((jsonDecode(row.tempoJson!) as Map).cast<String, Object?>());

  final SwingAnalysis row;
  final List<PhaseMark> phases;
  final Tempo? tempo;

  List<String> get limitations =>
      row.limitationKeys.isEmpty ? const [] : row.limitationKeys.split(',');

  PhaseMark? phase(SwingPhase p) {
    for (final m in phases) {
      if (m.phase == p) return m;
    }
    return null;
  }
}

/// Runs and stores on-device analysis (AI_ANALYSIS_SPEC §9, §14).
class AnalysisRepository {
  AnalysisRepository(this._db, this._videos, this._engine);

  final AppDatabase _db;
  final VideoStore _videos;
  final PoseEngine _engine;

  static const schemaVersion = '1.0';
  static const modelVersion = 'mediapipe_pose_landmarker_full+phases_v1';

  /// Latest analysis of a swing (completed, failed or running).
  Stream<SwingAnalysis?> watchLatest(String swingId) => (_db.select(_db.swingAnalyses)
        ..where((a) => a.swingId.equals(swingId))
        ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
        ..limit(1))
      .watchSingleOrNull();

  Future<KeypointSequence?> loadKeypoints(SwingAnalysis a) async {
    final rel = a.keypointsFilePath;
    if (rel == null) return null;
    final f = File(_videos.absolute(rel));
    if (!await f.exists()) return null;
    return KeypointSequence.decode(await f.readAsBytes());
  }

  Future<void> cancel(String swingId) => _engine.cancel(swingId);

  Future<SwingAnalysis> run(String swingId, {void Function(double)? onProgress}) async {
    final swing = await (_db.select(_db.swings)..where((s) => s.id.equals(swingId))).getSingle();
    final session = await (_db.select(_db.swingSessions)
          ..where((s) => s.id.equals(swing.sessionId)))
        .getSingle();
    final mirrored = session.handednessSnapshot == Handedness.left;
    final id = const Uuid().v4();
    final rel = 'swings/${swing.id}_$id.gckp';
    final row = await _db.into(_db.swingAnalyses).insertReturning(SwingAnalysesCompanion.insert(
          id: id,
          swingId: swing.id,
          modelVersion: modelVersion,
          schemaVersion: schemaVersion,
          status: AnalysisStatus.processing,
          mirrored: Value(mirrored),
          keypointsFilePath: Value(rel),
          createdAt: DateTime.now().toUtc(),
        ));

    try {
      final pose = await _engine.run(swing.id, _videos.absolute(swing.localFilePath),
          _videos.absolute(rel), onProgress ?? (_) {});
      final bytes = await File(_videos.absolute(rel)).readAsBytes();
      final timing = await Isolate.run(() {
        var seq = KeypointSequence.decode(bytes);
        if (mirrored) seq = seq.mirrored();
        return const PhaseDetector().detect(seq);
      });
      final limits = [
        'analysis.limit.single_2d_view',
        if (timing == null) 'analysis.limit.no_swing_detected',
        if (pose.fps < 50) 'analysis.limit.low_fps',
      ];
      await _finish(row, SwingAnalysesCompanion(
        status: Value(timing == null ? AnalysisStatus.insufficientQuality : AnalysisStatus.completed),
        phasesJson: Value(timing == null
            ? null
            : jsonEncode([for (final m in timing.phases) m.toJson()])),
        tempoJson: Value(timing?.tempo == null ? null : jsonEncode(timing!.tempo!.toJson())),
        limitationKeys: Value(limits.join(',')),
      ));
    } on PlatformException catch (e) {
      if (e.code == 'cancelled') {
        await _deleteRows([row]);
        rethrow;
      }
      await _fail(row, e.code == 'unsupported' ? 'unsupported' : 'pose_failed');
    } on FormatException {
      await _fail(row, 'keypoints_invalid');
    }
    return (_db.select(_db.swingAnalyses)..where((a) => a.id.equals(id))).getSingle();
  }

  /// Marks [row] done and current; older analyses of the swing are removed
  /// with their keypoints files.
  Future<void> _finish(SwingAnalysis row, SwingAnalysesCompanion data) async {
    final older = await (_db.select(_db.swingAnalyses)
          ..where((a) => a.swingId.equals(row.swingId) & a.id.equals(row.id).not()))
        .get();
    await _db.transaction(() async {
      await (_db.update(_db.swingAnalyses)..where((a) => a.id.equals(row.id))).write(
          data.copyWith(isCurrent: const Value(true), completedAt: Value(DateTime.now().toUtc())));
    });
    await _deleteRows(older);
  }

  Future<void> _fail(SwingAnalysis row, String code) async {
    await (_db.update(_db.swingAnalyses)..where((a) => a.id.equals(row.id))).write(
        SwingAnalysesCompanion(
            status: const Value(AnalysisStatus.failed),
            errorCode: Value(code),
            completedAt: Value(DateTime.now().toUtc())));
    await _videos.deleteFiles([row.keypointsFilePath]);
  }

  Future<void> _deleteRows(List<SwingAnalysis> rows) async {
    if (rows.isEmpty) return;
    await (_db.delete(_db.swingAnalyses)..where((a) => a.id.isIn(rows.map((r) => r.id)))).go();
    await _videos.deleteFiles(rows.map((r) => r.keypointsFilePath));
  }
}
