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
import 'guide_repository.dart';
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
  AnalysisResult(this.row, [this.observations = const []])
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

  /// All rule results, including hidden ones (filter with [visible]).
  final List<IssueObservation> observations;

  /// Observations the user may see (confidence medium or high).
  Iterable<IssueObservation> get visible => observations.where((o) => !o.hiddenFromUser);

  IssueObservation? observation(IssueId id) {
    for (final o in observations) {
      if (o.issueId == id.wire) return o;
    }
    return null;
  }

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
  AnalysisRepository(this._db, this._videos, this._engine, this._guides);

  final AppDatabase _db;
  final VideoStore _videos;
  final PoseEngine _engine;
  final GuideRepository _guides;

  static const schemaVersion = '1.0';
  static const modelVersion = 'mediapipe_pose_landmarker_full+phases_v2+issues_a_v0';

  /// Latest analysis of a swing (completed, failed or running).
  Stream<SwingAnalysis?> watchLatest(String swingId) => (_db.select(_db.swingAnalyses)
        ..where((a) => a.swingId.equals(swingId))
        ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
        ..limit(1))
      .watchSingleOrNull();

  /// [watchLatest] with its observations.
  Stream<AnalysisResult?> watchResult(String swingId) =>
      watchLatest(swingId).asyncMap((row) async => row == null
          ? null
          : AnalysisResult(
              row,
              await (_db.select(_db.issueObservations)
                    ..where((o) => o.analysisId.equals(row.id)))
                  .get()));

  Stream<FeedbackValue?> watchFeedback(String observationId) =>
      (_db.select(_db.analysisFeedbacks)
            ..where((f) => f.observationId.equals(observationId))
            ..orderBy([(f) => OrderingTerm.desc(f.createdAt)])
            ..limit(1))
          .watchSingleOrNull()
          .map((f) => f?.value);

  /// One answer per observation: a new answer replaces the old one.
  Future<void> setFeedback(String observationId, FeedbackValue value) async {
    final profile = await _db.select(_db.userProfiles).getSingleOrNull();
    await _db.transaction(() async {
      await (_db.delete(_db.analysisFeedbacks)
            ..where((f) => f.observationId.equals(observationId)))
          .go();
      await _db.into(_db.analysisFeedbacks).insert(AnalysisFeedbacksCompanion.insert(
            id: const Uuid().v4(),
            userId: profile?.id ?? '',
            observationId: observationId,
            value: value,
            createdAt: DateTime.now().toUtc(),
          ));
    });
  }

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
    final angle = session.cameraAngle;
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
      final (timing, issues) = await Isolate.run(() {
        var seq = KeypointSequence.decode(bytes);
        if (mirrored) seq = seq.mirrored();
        final timing = const PhaseDetector().detect(seq);
        return (timing, timing == null ? null : const IssueDetector().detect(seq, timing, angle));
      });
      final limits = [
        'analysis.limit.single_2d_view',
        if (timing == null) 'analysis.limit.no_swing_detected',
        if (pose.fps < 50) 'analysis.limit.low_fps',
        if (issues?.angleMismatch ?? false) 'analysis.limit.angle_mismatch',
      ];
      final findings = issues?.findings ?? const <IssueFinding>[];
      final focus = const FocusSelector()
          .select(findings, editorialPriority: await _guides.editorialPriority());
      await _finish(row, [
        for (final f in findings)
          IssueObservationsCompanion.insert(
            id: const Uuid().v4(),
            analysisId: id,
            issueId: f.issue.wire,
            phase: f.issue.phase,
            level: f.level,
            confidence: f.confidence,
            hiddenFromUser: f.hidden,
            cameraAngle: angle,
            evidenceKey: 'issue.${f.issue.wire}.what_we_see',
            evidenceFrameMs: Value(f.evidenceFrameMs),
            isPriorityFocus: Value(focus.contains(f.issue)),
            metricValue: Value(f.metric),
          ),
      ], SwingAnalysesCompanion(
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

  /// Stores [observations] and marks [row] done and current in one
  /// transaction; older analyses of the swing are removed with their
  /// keypoints files (observations and feedback cascade).
  Future<void> _finish(SwingAnalysis row, List<IssueObservationsCompanion> observations,
      SwingAnalysesCompanion data) async {
    final older = await (_db.select(_db.swingAnalyses)
          ..where((a) => a.swingId.equals(row.swingId) & a.id.equals(row.id).not()))
        .get();
    await _db.transaction(() async {
      await _db.batch((b) => b.insertAll(_db.issueObservations, observations));
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
