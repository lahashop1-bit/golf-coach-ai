// Pigeon definition for the native `pose` plugin.
// Regenerate: (cd packages/pose && dart run pigeon --input pigeons/pose_api.dart)
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    swiftOut: 'ios/pose/Sources/pose/Messages.g.swift',
    kotlinOut: 'android/src/main/kotlin/com/golfcoachai/pose/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.golfcoachai.pose'),
    dartPackageName: 'pose',
  ),
)
/// Summary of one offline pose run. The landmarks themselves are written to
/// the keypoints file (format: packages/analysis_core/lib/src/keypoints.dart).
class PoseRunResult {
  PoseRunResult({
    required this.frameCount,
    required this.detectedFrames,
    required this.fps,
    required this.width,
    required this.height,
    required this.model,
  });

  int frameCount;
  int detectedFrames;

  /// Effective sampling rate of the frames written.
  double fps;

  /// Upright (displayed) frame size; landmarks are normalized to it.
  int width;
  int height;
  String model;
}

@HostApi()
abstract class PoseHostApi {
  /// Runs pose estimation on every frame of [videoPath] (sampled down to at
  /// most [maxFps]) and writes a keypoints file to [outputPath].
  /// [modelAssetKey] is the Flutter asset key of the `.task` model.
  @async
  PoseRunResult analyzeVideo(
    String jobId,
    String videoPath,
    String outputPath,
    String modelAssetKey,
    double maxFps,
  );

  /// Stops [jobId] at the next frame; analyzeVideo then fails with
  /// code `cancelled`.
  void cancel(String jobId);
}

@FlutterApi()
abstract class PoseProgressApi {
  void onProgress(String jobId, double fraction);
}
