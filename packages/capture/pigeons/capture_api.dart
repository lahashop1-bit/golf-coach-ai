// Pigeon definition for the native `capture` plugin.
// Regenerate: (cd packages/capture && dart run pigeon --input pigeons/capture_api.dart)
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    swiftOut: 'ios/capture/Sources/capture/Messages.g.swift',
    kotlinOut: 'android/src/main/kotlin/com/golfcoachai/capture/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.golfcoachai.capture'),
    dartPackageName: 'capture',
  ),
)
/// Metadata read from the video file itself (never from the requested settings).
class VideoInfo {
  VideoInfo({
    required this.fps,
    required this.durationMs,
    required this.width,
    required this.height,
    required this.rotationDegrees,
    required this.fileSizeBytes,
    this.thumbnailPath,
  });

  /// Nominal frame rate of the video track.
  double fps;
  int durationMs;

  /// Encoded (pre-rotation) size.
  int width;
  int height;
  int rotationDegrees;
  int fileSizeBytes;

  /// Set when a thumbnail was requested and written successfully.
  String? thumbnailPath;
}

@HostApi()
abstract class CaptureHostApi {
  /// Reads [VideoInfo] from [videoPath]. When [thumbnailPath] is given, writes a
  /// JPEG frame from near the start of the clip there.
  @async
  VideoInfo probeVideo(String videoPath, String? thumbnailPath);
}
