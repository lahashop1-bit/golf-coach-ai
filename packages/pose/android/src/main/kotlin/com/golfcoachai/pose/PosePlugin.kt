package com.golfcoachai.pose

import io.flutter.embedding.engine.plugins.FlutterPlugin

/**
 * Android implementation is pending (iOS first). It must use the same
 * MediaPipe Pose Landmarker model and keypoints file format as iOS
 * (docs/PLATFORM_DECISION.md §3.2).
 */
class PosePlugin : FlutterPlugin, PoseHostApi {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        PoseHostApi.setUp(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        PoseHostApi.setUp(binding.binaryMessenger, null)
    }

    override suspend fun analyzeVideo(
        jobId: String,
        videoPath: String,
        outputPath: String,
        modelAssetKey: String,
        maxFps: Double,
    ): PoseRunResult = throw FlutterError("unsupported", "Pose analysis is not available on Android yet")

    override fun cancel(jobId: String) {}
}
