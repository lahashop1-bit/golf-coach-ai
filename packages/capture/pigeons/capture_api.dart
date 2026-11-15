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

enum CameraLens { back, front }

/// What Flutter needs to draw the live preview texture upright.
class CameraPreviewInfo {
  CameraPreviewInfo({
    required this.textureId,
    required this.width,
    required this.height,
    required this.rotationDegrees,
    required this.mirrored,
    required this.fps,
  });

  int textureId;

  /// Size of the frames in the texture (sensor orientation, not rotated).
  int width;
  int height;

  /// Clockwise rotation that makes the frames upright in portrait.
  int rotationDegrees;

  /// Front camera: the preview is shown mirrored (recordings are not).
  bool mirrored;

  /// Frame rate the device was configured for.
  double fps;
}

/// Live camera for recording swings (iOS: AVFoundation). Recordings are
/// written in sensor orientation with the rotation stored as file metadata,
/// never mirrored, without audio.
@HostApi()
abstract class CameraHostApi {
  List<CameraLens> availableLenses();

  /// Opens [lens] (closing any open camera), asking for [targetFps] and
  /// falling back to the best rate the device supports.
  @async
  CameraPreviewInfo open(CameraLens lens, int targetFps);

  @async
  void startRecording(String path);

  /// Finishes the file started by [startRecording].
  @async
  void stopRecording();

  /// Stops the camera and releases the preview texture. A recording in
  /// progress is discarded.
  @async
  void close();
}

@HostApi()
abstract class CaptureHostApi {
  /// Reads [VideoInfo] from [videoPath]. When [thumbnailPath] is given, writes a
  /// JPEG frame from near the start of the clip there.
  @async
  VideoInfo probeVideo(String videoPath, String? thumbnailPath);
}
