import Flutter
import UIKit

public class PosePlugin: NSObject, FlutterPlugin, PoseHostApi {
  private let registrar: FlutterPluginRegistrar
  private let progressApi: PoseProgressApi
  private let jobs = CancelRegistry()

  init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
    self.progressApi = PoseProgressApi(binaryMessenger: registrar.messenger())
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    PoseHostApiSetup.setUp(
      binaryMessenger: registrar.messenger(), api: PosePlugin(registrar: registrar))
  }

  func analyzeVideo(
    jobId: String, videoPath: String, outputPath: String, modelAssetKey: String, maxFps: Double
  ) async throws -> PoseRunResult {
    let key = registrar.lookupKey(forAsset: modelAssetKey)
    guard let modelPath = Bundle.main.path(forResource: key, ofType: nil) else {
      throw PigeonError(code: "model_missing", message: "Model asset not found: \(modelAssetKey)", details: nil)
    }
    jobs.start(jobId)
    defer { jobs.finish(jobId) }

    let progressApi = self.progressApi
    let jobs = self.jobs
    // Heavy work off the main actor (Pigeon dispatches this call on it).
    return try await Task.detached(priority: .userInitiated) {
      try VideoPoseRunner(modelPath: modelPath, maxFps: maxFps).run(
        videoPath: videoPath,
        outputPath: outputPath,
        isCancelled: { jobs.isCancelled(jobId) },
        onProgress: { fraction in
          Task { @MainActor in try? await progressApi.onProgress(jobId: jobId, fraction: fraction) }
        })
    }.value
  }

  func cancel(jobId: String) throws {
    jobs.cancel(jobId)
  }
}

/// Thread-safe set of running / cancelled job ids.
final class CancelRegistry: @unchecked Sendable {
  private let lock = NSLock()
  private var cancelled = Set<String>()

  func start(_ id: String) { lock.withLock { _ = cancelled.remove(id) } }
  func finish(_ id: String) { lock.withLock { _ = cancelled.remove(id) } }
  func cancel(_ id: String) { lock.withLock { _ = cancelled.insert(id) } }
  func isCancelled(_ id: String) -> Bool { lock.withLock { cancelled.contains(id) } }
}
