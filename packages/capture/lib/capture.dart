/// Native camera/video helpers for Golf Coach AI (iOS: AVFoundation,
/// Android: MediaMetadataRetriever). See docs/PLATFORM_DECISION.md §3.1.
library;

import 'src/messages.g.dart';

export 'src/messages.g.dart' show VideoInfo;

class Capture {
  Capture({CaptureHostApi? api}) : _api = api ?? CaptureHostApi();

  final CaptureHostApi _api;

  /// Reads FPS, duration, size and rotation from the file itself, and writes a
  /// JPEG thumbnail to [thumbnailPath] when given.
  Future<VideoInfo> probeVideo(String videoPath, {String? thumbnailPath}) =>
      _api.probeVideo(videoPath, thumbnailPath);
}
