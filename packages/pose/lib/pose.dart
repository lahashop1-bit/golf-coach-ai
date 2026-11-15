/// On-device pose estimation for Golf Coach AI (MediaPipe Pose Landmarker,
/// same model on iOS and Android). See docs/PLATFORM_DECISION.md §3.2.
library;

import 'dart:async';

import 'src/messages.g.dart';

export 'src/messages.g.dart' show PoseRunResult;

/// Flutter asset key of the bundled model (Apache-2.0, see NOTICE).
const poseModelAsset = 'assets/models/pose_landmarker_full.task';

class Pose implements PoseProgressApi {
  Pose({PoseHostApi? api}) : _api = api ?? PoseHostApi() {
    PoseProgressApi.setUp(this);
  }

  final PoseHostApi _api;
  final _progress = StreamController<(String, double)>.broadcast();

  /// Writes keypoints for [videoPath] to [outputPath]. [onProgress] receives
  /// 0–1. Throws a PlatformException with code `cancelled` after [cancel].
  Future<PoseRunResult> analyzeVideo({
    required String jobId,
    required String videoPath,
    required String outputPath,
    double maxFps = 120,
    void Function(double fraction)? onProgress,
  }) async {
    final sub = onProgress == null
        ? null
        : _progress.stream
            .where((e) => e.$1 == jobId)
            .listen((e) => onProgress(e.$2));
    try {
      return await _api.analyzeVideo(
          jobId, videoPath, outputPath, poseModelAsset, maxFps);
    } finally {
      await sub?.cancel();
    }
  }

  Future<void> cancel(String jobId) => _api.cancel(jobId);

  @override
  void onProgress(String jobId, double fraction) =>
      _progress.add((jobId, fraction));
}
