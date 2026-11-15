import AVFoundation
import MediaPipeTasksVision

/// Offline pose estimation over a video file (PLATFORM_DECISION §3.2).
/// Frames are rendered upright (preferred transform applied) and scaled so
/// the long side is at most `maxSide`; landmarks are normalized 0–1 to that
/// upright frame.
struct VideoPoseRunner {
  static let modelName = "mediapipe_pose_landmarker_full"
  static let pointCount = 33
  let modelPath: String
  let maxFps: Double
  var maxSide: CGFloat = 1280

  func run(
    videoPath: String,
    outputPath: String,
    isCancelled: () -> Bool,
    onProgress: (Double) -> Void
  ) throws -> PoseRunResult {
    let asset = AVURLAsset(url: URL(fileURLWithPath: videoPath))
    guard let track = asset.tracks(withMediaType: .video).first else {
      throw PigeonError(code: "no_video_track", message: "File has no video track", details: nil)
    }
    let duration = CMTimeGetSeconds(asset.duration)

    let transform = track.preferredTransform
    let upright = CGRect(origin: .zero, size: track.naturalSize).applying(transform).size
    let scale = min(1, maxSide / max(abs(upright.width), abs(upright.height)))
    let width = Int((abs(upright.width) * scale / 2).rounded()) * 2
    let height = Int((abs(upright.height) * scale / 2).rounded()) * 2

    let composition = AVMutableVideoComposition()
    composition.renderSize = CGSize(width: width, height: height)
    composition.frameDuration =
      track.minFrameDuration.isValid && track.minFrameDuration.seconds > 0
      ? track.minFrameDuration : CMTime(value: 1, timescale: 60)
    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRange(start: .zero, duration: asset.duration)
    let layer = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
    layer.setTransform(transform.concatenating(CGAffineTransform(scaleX: scale, y: scale)), at: .zero)
    instruction.layerInstructions = [layer]
    composition.instructions = [instruction]

    let reader = try AVAssetReader(asset: asset)
    let output = AVAssetReaderVideoCompositionOutput(
      videoTracks: [track],
      videoSettings: [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA])
    output.videoComposition = composition
    output.alwaysCopiesSampleData = false
    reader.add(output)

    let options = PoseLandmarkerOptions()
    options.baseOptions.modelAssetPath = modelPath
    options.runningMode = .video
    options.numPoses = 1
    let landmarker = try PoseLandmarker(options: options)

    guard reader.startReading() else {
      throw PigeonError(code: "reader_failed", message: reader.error?.localizedDescription, details: nil)
    }

    var writer = KeypointsWriter(pointCount: Self.pointCount)
    let minStepMs = maxFps > 0 ? 1000.0 / maxFps - 0.5 : 0
    var lastMs = -Double.infinity
    var detected = 0
    var lastReported = 0.0

    while let sample = output.copyNextSampleBuffer() {
      if isCancelled() {
        reader.cancelReading()
        throw PigeonError(code: "cancelled", message: "Cancelled", details: nil)
      }
      let ms = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sample)) * 1000
      guard ms - lastMs >= minStepMs, ms > lastMs,
        let pixels = CMSampleBufferGetImageBuffer(sample)
      else { continue }
      lastMs = ms

      let image = try MPImage(pixelBuffer: pixels, orientation: .up)
      let result = try landmarker.detect(videoFrame: image, timestampInMilliseconds: Int(ms))
      if let pose = result.landmarks.first, pose.count == Self.pointCount {
        detected += 1
        writer.addFrame(
          timestampMs: UInt32(ms.rounded()),
          points: pose.map { ($0.x, $0.y, $0.visibility?.floatValue ?? 0) })
      } else {
        writer.addFrame(timestampMs: UInt32(ms.rounded()), points: nil)
      }

      if duration > 0 {
        let fraction = min(1, ms / 1000 / duration)
        if fraction - lastReported >= 0.05 {
          lastReported = fraction
          onProgress(fraction)
        }
      }
    }
    if reader.status == .failed {
      throw PigeonError(code: "reader_failed", message: reader.error?.localizedDescription, details: nil)
    }

    let fps = writer.effectiveFps
    try writer.write(
      to: outputPath, fps: Float(fps), width: UInt32(width), height: UInt32(height),
      model: Self.modelName)
    onProgress(1)
    return PoseRunResult(
      frameCount: Int64(writer.frameCount), detectedFrames: Int64(detected), fps: fps,
      width: Int64(width), height: Int64(height), model: Self.modelName)
  }
}

/// Binary keypoints file, little-endian. Must match
/// packages/analysis_core/lib/src/keypoints.dart.
///   header: "GCKP" | u16 version=1 | u16 pointCount | u32 frameCount |
///           f32 fps | u32 width | u32 height | u16 modelLen | model utf8
///   frame:  u32 timestampMs | u8 detected | pointCount × (f32 x, f32 y, f32 visibility)
struct KeypointsWriter {
  let pointCount: Int
  private(set) var frameCount = 0
  private var body = Data()
  private var firstMs: UInt32?
  private var lastMs: UInt32 = 0

  init(pointCount: Int) { self.pointCount = pointCount }

  var effectiveFps: Double {
    guard let first = firstMs, frameCount > 1, lastMs > first else { return 0 }
    return Double(frameCount - 1) * 1000 / Double(lastMs - first)
  }

  mutating func addFrame(timestampMs: UInt32, points: [(Float, Float, Float)]?) {
    if firstMs == nil { firstMs = timestampMs }
    lastMs = timestampMs
    frameCount += 1
    body.appendLE(timestampMs)
    body.append(points == nil ? 0 : 1)
    for i in 0..<pointCount {
      let p = points?[i] ?? (0, 0, 0)
      body.appendLE(p.0.bitPattern)
      body.appendLE(p.1.bitPattern)
      body.appendLE(p.2.bitPattern)
    }
  }

  func write(to path: String, fps: Float, width: UInt32, height: UInt32, model: String) throws {
    var data = Data("GCKP".utf8)
    data.appendLE(UInt16(1))
    data.appendLE(UInt16(pointCount))
    data.appendLE(UInt32(frameCount))
    data.appendLE(fps.bitPattern)
    data.appendLE(width)
    data.appendLE(height)
    let name = Data(model.utf8)
    data.appendLE(UInt16(name.count))
    data.append(name)
    data.append(body)
    let url = URL(fileURLWithPath: path)
    try FileManager.default.createDirectory(
      at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
    try data.write(to: url, options: .atomic)
  }
}

extension Data {
  fileprivate mutating func appendLE<T: FixedWidthInteger>(_ value: T) {
    var v = value.littleEndian
    Swift.withUnsafeBytes(of: &v) { append(contentsOf: $0) }
  }
}
