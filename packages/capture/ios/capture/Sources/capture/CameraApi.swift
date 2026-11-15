import AVFoundation
import Flutter

/// Pigeon entry point for the live camera. Holds at most one open
/// [CameraSession]; calls arrive on the main thread.
final class CameraApi: CameraHostApi {
  private let textures: FlutterTextureRegistry
  private var camera: CameraSession?

  init(textures: FlutterTextureRegistry) {
    self.textures = textures
  }

  func availableLenses() throws -> [CameraLens] {
    [CameraLens.back, .front].filter { CameraSession.device(for: $0) != nil }
  }

  func open(lens: CameraLens, targetFps: Int64) async throws -> CameraPreviewInfo {
    try await Self.ensureAccess()
    if let old = camera {
      camera = nil
      await old.close()
    }
    let session = CameraSession(lens: lens, textures: textures)
    try await session.open(targetFps: Int(targetFps))
    camera = session
    return CameraPreviewInfo(
      textureId: session.textureId,
      width: Int64(session.dimensions.width),
      height: Int64(session.dimensions.height),
      rotationDegrees: Int64(session.rotationDegrees),
      mirrored: lens == .front,
      fps: session.fps)
  }

  func startRecording(path: String) async throws {
    try await current().startRecording(path: path)
  }

  func stopRecording() async throws {
    try await current().stopRecording()
  }

  func close() async throws {
    let old = camera
    camera = nil
    await old?.close()
  }

  private func current() throws -> CameraSession {
    guard let camera else {
      throw PigeonError(code: "camera_closed", message: "Camera is not open", details: nil)
    }
    return camera
  }

  /// Camera only; the app never asks for the microphone.
  private static func ensureAccess() async throws {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      return
    case .notDetermined:
      if await AVCaptureDevice.requestAccess(for: .video) { return }
    default:
      break
    }
    throw PigeonError(code: "permission_denied", message: "Camera access denied", details: nil)
  }
}
