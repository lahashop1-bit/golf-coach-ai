/// Native camera/video helpers for Golf Coach AI (iOS: AVFoundation,
/// Android: MediaMetadataRetriever). See docs/PLATFORM_DECISION.md §3.1.
library;

import 'src/messages.g.dart';

export 'src/camera_preview.dart';
export 'src/messages.g.dart' show CameraLens, CameraPreviewInfo, VideoInfo;

/// Live camera for swing recording (iOS only for now; Android keeps the
/// `camera` plugin until CameraX lands). Errors are [PlatformException]s
/// with codes `permission_denied`, `camera_unavailable`, `camera_failed`,
/// `record_failed`, `record_empty`.
class NativeCamera {
  NativeCamera({CameraHostApi? api}) : _api = api ?? CameraHostApi();

  final CameraHostApi _api;

  Future<List<CameraLens>> availableLenses() => _api.availableLenses();

  Future<CameraPreviewInfo> open(CameraLens lens, {int targetFps = 60}) =>
      _api.open(lens, targetFps);

  Future<void> startRecording(String path) => _api.startRecording(path);

  /// Returns once the file is complete.
  Future<void> stopRecording() => _api.stopRecording();

  Future<void> close() => _api.close();
}

class Capture {
  Capture({CaptureHostApi? api}) : _api = api ?? CaptureHostApi();

  final CaptureHostApi _api;

  /// Reads FPS, duration, size and rotation from the file itself, and writes a
  /// JPEG thumbnail to [thumbnailPath] when given.
  Future<VideoInfo> probeVideo(String videoPath, {String? thumbnailPath}) =>
      _api.probeVideo(videoPath, thumbnailPath);
}
