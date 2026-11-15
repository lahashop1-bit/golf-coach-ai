import 'dart:io';

import 'package:analysis_core/analysis_core.dart';
import 'package:analysis_core/testing.dart';
import 'package:capture/capture.dart';
import 'package:capture/src/messages.g.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:golf_coach_ai/data/analysis_repository.dart';
import 'package:golf_coach_ai/data/db/database.dart';
import 'package:golf_coach_ai/data/swing_repository.dart';
import 'package:golf_coach_ai/data/video_store.dart';
import 'package:pose/pose.dart';

/// Returns fixed metadata instead of reading the file natively.
class FakeCaptureApi extends CaptureHostApi {
  FakeCaptureApi({this.durationMs = 3000, this.fps = 60, this.fail = false});

  int durationMs;
  double fps;
  bool fail;

  @override
  Future<VideoInfo> probeVideo(String videoPath, String? thumbnailPath) async {
    if (fail) throw Exception('unreadable');
    return VideoInfo(
      fps: fps,
      durationMs: durationMs,
      width: 1920,
      height: 1080,
      rotationDegrees: 90,
      fileSizeBytes: await File(videoPath).length(),
    );
  }
}

/// Writes a synthetic swing as the keypoints file instead of running
/// MediaPipe. [sequence] null = no person detected; [errorCode] = fail.
class FakePoseEngine implements PoseEngine {
  KeypointSequence? sequence = syntheticSwing();
  String? errorCode;
  final cancelled = <String>[];

  @override
  Future<PoseRunResult> run(String jobId, String videoPath, String outputPath,
      void Function(double) onProgress) async {
    if (errorCode != null) throw PlatformException(code: errorCode!);
    final seq = sequence ??
        KeypointSequence(
            fps: 60,
            width: 720,
            height: 1280,
            model: 'fake',
            frames: [for (var i = 0; i < 60; i++) PoseFrame(i * 16, null)]);
    await File(outputPath).parent.create(recursive: true);
    await File(outputPath).writeAsBytes(seq.encode());
    onProgress(1);
    return PoseRunResult(
        frameCount: seq.frames.length,
        detectedFrames: seq.frames.where((f) => f.points != null).length,
        fps: seq.fps,
        width: seq.width,
        height: seq.height,
        model: seq.model);
  }

  @override
  Future<void> cancel(String jobId) async => cancelled.add(jobId);
}

class TestEnv {
  TestEnv._(this.db, this.root, this.api, this.repo, this.pose, this.analysis);

  final AppDatabase db;
  final Directory root;
  final FakeCaptureApi api;
  final SwingRepository repo;
  final FakePoseEngine pose;
  final AnalysisRepository analysis;

  static Future<TestEnv> create() async {
    final db = AppDatabase(NativeDatabase.memory());
    final root = await Directory.systemTemp.createTemp('golf_test');
    final api = FakeCaptureApi();
    final store = VideoStore(root);
    final repo = SwingRepository(db, store, Capture(api: api));
    final pose = FakePoseEngine();
    return TestEnv._(db, root, api, repo, pose, AnalysisRepository(db, store, pose));
  }

  /// A fake clip file outside the store (like a camera temp file).
  Future<File> clip([String name = 'clip.mov']) async {
    final dir = await Directory.systemTemp.createTemp('golf_clip');
    return File('${dir.path}/$name').writeAsBytes(List.filled(64, 1));
  }

  Future<void> dispose() async {
    await db.close();
    if (await root.exists()) await root.delete(recursive: true);
  }
}
