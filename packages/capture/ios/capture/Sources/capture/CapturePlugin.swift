import AVFoundation
import Flutter
import UIKit

public class CapturePlugin: NSObject, FlutterPlugin, CaptureHostApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    CaptureHostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: CapturePlugin())
  }

  func probeVideo(videoPath: String, thumbnailPath: String?) async throws -> VideoInfo {
    let url = URL(fileURLWithPath: videoPath)
    let asset = AVURLAsset(url: url)
    guard let track = try await asset.loadTracks(withMediaType: .video).first else {
      throw PigeonError(code: "no_video_track", message: "File has no video track", details: nil)
    }
    let (fps, size, transform) = try await track.load(.nominalFrameRate, .naturalSize, .preferredTransform)
    let duration = try await asset.load(.duration)
    let attrs = try? FileManager.default.attributesOfItem(atPath: videoPath)
    let fileSize = (attrs?[.size] as? NSNumber)?.int64Value ?? 0

    var written: String?
    if let thumbnailPath {
      written = try? await writeThumbnail(asset: asset, to: thumbnailPath)
    }

    return VideoInfo(
      fps: Double(fps),
      durationMs: Int64((CMTimeGetSeconds(duration) * 1000).rounded()),
      width: Int64(size.width),
      height: Int64(size.height),
      rotationDegrees: Int64(Self.rotationDegrees(transform)),
      fileSizeBytes: fileSize,
      thumbnailPath: written
    )
  }

  private func writeThumbnail(asset: AVAsset, to path: String) async throws -> String {
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    generator.maximumSize = CGSize(width: 480, height: 480)
    let time = CMTime(value: 1, timescale: 10)
    let cgImage: CGImage
    if #available(iOS 16, *) {
      cgImage = try await generator.image(at: time).image
    } else {
      cgImage = try generator.copyCGImage(at: time, actualTime: nil)
    }
    guard let data = UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.8) else {
      throw PigeonError(code: "thumbnail_encode", message: "JPEG encoding failed", details: nil)
    }
    try data.write(to: URL(fileURLWithPath: path), options: .atomic)
    return path
  }

  private static func rotationDegrees(_ t: CGAffineTransform) -> Int {
    let degrees = Int((atan2(t.b, t.a) * 180 / .pi).rounded())
    return (degrees + 360) % 360
  }
}
