import AVFoundation
import Flutter

/// One open camera: live preview into a Flutter texture and swing recording
/// with AVAssetWriter. Frames stay in sensor orientation; the portrait
/// rotation is written as track metadata, so it does not depend on the
/// connection rotating buffers (which the iPhone 17 front camera ignores).
/// Recordings are never mirrored, so the golfer's left and right are real.
final class CameraSession: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
  let lens: CameraLens
  let rotationDegrees: Int
  private(set) var fps: Double = 30
  private(set) var dimensions = CMVideoDimensions(width: 0, height: 0)

  private let session = AVCaptureSession()
  private let output = AVCaptureVideoDataOutput()
  /// Session configuration, start/stop.
  private let sessionQueue = DispatchQueue(label: "capture.session")
  /// Frame delivery and all writer state.
  private let videoQueue = DispatchQueue(label: "capture.video")
  private let texture = PreviewTexture()
  private let textures: FlutterTextureRegistry
  private(set) var textureId: Int64 = 0

  private var writer: AVAssetWriter?
  private var writerInput: AVAssetWriterInput?
  private var writerStarted = false
  /// Size of the delivered frames (videoQueue).
  private var frameSize: CMVideoDimensions?

  init(lens: CameraLens, textures: FlutterTextureRegistry) {
    self.lens = lens
    self.textures = textures
    rotationDegrees = Self.portraitRotation(for: lens)
    super.init()
  }

  /// Clockwise rotation of this lens's frames for an upright portrait
  /// picture. Sensor mounting differs per model (the iPhone 17 front
  /// camera delivers upright frames: 0°), so it is measured, not assumed.
  /// The rotation coordinator follows how the phone is held, so the lens is
  /// compared with the back camera, which needs 90° on every iPhone.
  static func portraitRotation(for lens: CameraLens) -> Int {
    let back = 90
    guard lens == .front, #available(iOS 17.0, *),
      let front = device(for: .front), let rear = device(for: .back)
    else { return back }
    func angle(_ d: AVCaptureDevice) -> Double {
      AVCaptureDevice.RotationCoordinator(device: d, previewLayer: nil)
        .videoRotationAngleForHorizonLevelCapture
    }
    let offset = Int((angle(front) - angle(rear)).rounded() / 90) * 90
    return ((back + offset) % 360 + 360) % 360
  }

  static func device(for lens: CameraLens) -> AVCaptureDevice? {
    AVCaptureDevice.default(
      .builtInWideAngleCamera, for: .video, position: lens == .front ? .front : .back)
  }

  // MARK: Open / close

  func open(targetFps: Int) async throws {
    guard let device = Self.device(for: lens) else {
      throw PigeonError(code: "camera_unavailable", message: "No camera for \(lens)", details: nil)
    }
    try await sessionQueue.run { try self.configure(device: device, targetFps: targetFps) }
    textureId = textures.register(texture)
    sessionQueue.async { self.session.startRunning() }
    // The active format's size is not always the frame size: the iPhone 17
    // front camera reports 1024x768 but delivers upright 768x1024 frames.
    for _ in 0..<60 {
      if let size = await videoQueue.run({ self.frameSize }) {
        dimensions = size
        break
      }
      try await Task.sleep(nanoseconds: 50_000_000)
    }
    print("[capture] lens=\(lens) frames=\(dimensions.width)x\(dimensions.height) "
      + "rotation=\(rotationDegrees) fps=\(fps)")
  }

  func close() async {
    await sessionQueue.run { self.session.stopRunning() }
    await videoQueue.run {
      self.writer?.cancelWriting()
      self.writer = nil
      self.writerInput = nil
    }
    textures.unregisterTexture(textureId)
  }

  private func configure(device: AVCaptureDevice, targetFps: Int) throws {
    session.beginConfiguration()
    defer { session.commitConfiguration() }

    let input = try AVCaptureDeviceInput(device: device)
    guard session.canAddInput(input) else {
      throw PigeonError(code: "camera_failed", message: "Cannot add camera input", details: nil)
    }
    session.addInput(input)

    output.videoSettings = [
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
    ]
    output.alwaysDiscardsLateVideoFrames = true
    output.setSampleBufferDelegate(self, queue: videoQueue)
    guard session.canAddOutput(output) else {
      throw PigeonError(code: "camera_failed", message: "Cannot add video output", details: nil)
    }
    session.addOutput(output)

    if let connection = output.connection(with: .video) {
      if connection.isVideoMirroringSupported {
        connection.automaticallyAdjustsVideoMirroring = false
        connection.isVideoMirrored = false
      }
      if #available(iOS 17.0, *), connection.isVideoRotationAngleSupported(0) {
        connection.videoRotationAngle = 0
      }
      if connection.isVideoStabilizationSupported {
        // Stabilization crops and lags; the phone should be on a stand.
        connection.preferredVideoStabilizationMode = .off
      }
    }

    try lockFormat(device: device, targetFps: targetFps)
  }

  /// Picks a 720p–1080p format that reaches [targetFps] if any does
  /// (smallest first: enough for pose, lighter files), else the fastest.
  private func lockFormat(device: AVCaptureDevice, targetFps: Int) throws {
    func maxRate(_ f: AVCaptureDevice.Format) -> Double {
      f.videoSupportedFrameRateRanges.map(\.maxFrameRate).max() ?? 0
    }
    let candidates = device.formats.filter {
      let d = CMVideoFormatDescriptionGetDimensions($0.formatDescription)
      return min(d.width, d.height) >= 720 && min(d.width, d.height) <= 1080
        && CMFormatDescriptionGetMediaSubType($0.formatDescription)
          == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
    }
    let target = Double(targetFps)
    func pixels(_ f: AVCaptureDevice.Format) -> Int32 {
      let d = CMVideoFormatDescriptionGetDimensions(f.formatDescription)
      return d.width * d.height
    }
    let reaching = candidates.filter { maxRate($0) >= target }.sorted { pixels($0) < pixels($1) }
    guard let format = reaching.first ?? candidates.max(by: { maxRate($0) < maxRate($1) }) else {
      session.sessionPreset = .hd1280x720
      dimensions = CMVideoFormatDescriptionGetDimensions(device.activeFormat.formatDescription)
      fps = min(maxRate(device.activeFormat), 30)
      return
    }
    fps = min(target, maxRate(format))
    try device.lockForConfiguration()
    defer { device.unlockForConfiguration() }
    device.activeFormat = format
    let duration = CMTime(value: 1, timescale: CMTimeScale(fps.rounded()))
    device.activeVideoMinFrameDuration = duration
    device.activeVideoMaxFrameDuration = duration
    if device.isFocusModeSupported(.continuousAutoFocus) { device.focusMode = .continuousAutoFocus }
    dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
  }

  // MARK: Recording

  func startRecording(path: String) async throws {
    let url = URL(fileURLWithPath: path)
    try? FileManager.default.removeItem(at: url)
    let writer = try AVAssetWriter(outputURL: url, fileType: .mp4)
    var settings = output.recommendedVideoSettingsForAssetWriter(writingTo: .mp4)
      ?? [AVVideoCodecKey: AVVideoCodecType.h264]
    settings[AVVideoWidthKey] = Int(dimensions.width)
    settings[AVVideoHeightKey] = Int(dimensions.height)
    var compression = settings[AVVideoCompressionPropertiesKey] as? [String: Any] ?? [:]
    compression[AVVideoExpectedSourceFrameRateKey] = fps
    settings[AVVideoCompressionPropertiesKey] = compression
    let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
    input.expectsMediaDataInRealTime = true
    input.transform = CGAffineTransform(rotationAngle: CGFloat(rotationDegrees) * .pi / 180)
    guard writer.canAdd(input) else {
      throw PigeonError(code: "record_failed", message: "Cannot add writer input", details: nil)
    }
    writer.add(input)
    guard writer.startWriting() else {
      throw PigeonError(
        code: "record_failed", message: writer.error?.localizedDescription, details: nil)
    }
    await videoQueue.run {
      self.writer = writer
      self.writerInput = input
      self.writerStarted = false
    }
  }

  func stopRecording() async throws {
    let (writer, started) = await videoQueue.run { () -> (AVAssetWriter?, Bool) in
      let w = self.writer
      self.writer = nil
      self.writerInput?.markAsFinished()
      self.writerInput = nil
      return (w, self.writerStarted)
    }
    guard let writer else {
      throw PigeonError(code: "not_recording", message: "No recording in progress", details: nil)
    }
    guard started else {
      writer.cancelWriting()
      throw PigeonError(code: "record_empty", message: "No frames were recorded", details: nil)
    }
    await writer.finishWriting()
    if writer.status != .completed {
      throw PigeonError(
        code: "record_failed", message: writer.error?.localizedDescription, details: nil)
    }
  }

  // MARK: Frames (videoQueue)

  func captureOutput(
    _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    if let pixels = CMSampleBufferGetImageBuffer(sampleBuffer) {
      if frameSize == nil {
        frameSize = CMVideoDimensions(
          width: Int32(CVPixelBufferGetWidth(pixels)), height: Int32(CVPixelBufferGetHeight(pixels)))
      }
      texture.update(pixels)
      textures.textureFrameAvailable(textureId)
    }
    guard let writer, let input = writerInput, writer.status == .writing else { return }
    if !writerStarted {
      writer.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
      writerStarted = true
    }
    if input.isReadyForMoreMediaData { input.append(sampleBuffer) }
  }
}

/// Holds the latest camera frame for Flutter to draw.
private final class PreviewTexture: NSObject, FlutterTexture {
  private let lock = NSLock()
  private var latest: CVPixelBuffer?

  func update(_ buffer: CVPixelBuffer) {
    lock.lock()
    latest = buffer
    lock.unlock()
  }

  func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
    lock.lock()
    defer { lock.unlock() }
    guard let latest else { return nil }
    return Unmanaged.passRetained(latest)
  }
}

extension DispatchQueue {
  /// Runs [work] on this queue and awaits its result.
  func run<T>(_ work: @escaping () throws -> T) async throws -> T {
    try await withCheckedThrowingContinuation { cont in
      self.async(execute: { cont.resume(with: Result { try work() }) })
    }
  }

  func run<T>(_ work: @escaping () -> T) async -> T {
    await withCheckedContinuation { cont in
      self.async(execute: { cont.resume(returning: work()) })
    }
  }
}
