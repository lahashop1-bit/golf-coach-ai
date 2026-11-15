package com.golfcoachai.capture

import android.graphics.Bitmap
import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMetadataRetriever
import io.flutter.embedding.engine.plugins.FlutterPlugin
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileOutputStream

class CapturePlugin : FlutterPlugin, CaptureHostApi {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        CaptureHostApi.setUp(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        CaptureHostApi.setUp(binding.binaryMessenger, null)
    }

    override suspend fun probeVideo(videoPath: String, thumbnailPath: String?): VideoInfo =
        withContext(Dispatchers.IO) {
            val retriever = MediaMetadataRetriever()
            try {
                retriever.setDataSource(videoPath)
                fun meta(key: Int) = retriever.extractMetadata(key)?.toLongOrNull() ?: 0L
                val written = thumbnailPath?.let { writeThumbnail(retriever, it) }
                VideoInfo(
                    fps = readFps(videoPath),
                    durationMs = meta(MediaMetadataRetriever.METADATA_KEY_DURATION),
                    width = meta(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH),
                    height = meta(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT),
                    rotationDegrees = meta(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION),
                    fileSizeBytes = File(videoPath).length(),
                    thumbnailPath = written,
                )
            } finally {
                retriever.release()
            }
        }

    private fun readFps(path: String): Double {
        val extractor = MediaExtractor()
        try {
            extractor.setDataSource(path)
            for (i in 0 until extractor.trackCount) {
                val format = extractor.getTrackFormat(i)
                val mime = format.getString(MediaFormat.KEY_MIME) ?: continue
                if (mime.startsWith("video/") && format.containsKey(MediaFormat.KEY_FRAME_RATE)) {
                    return format.getInteger(MediaFormat.KEY_FRAME_RATE).toDouble()
                }
            }
            return 0.0
        } finally {
            extractor.release()
        }
    }

    private fun writeThumbnail(retriever: MediaMetadataRetriever, path: String): String? {
        val frame = retriever.getFrameAtTime(100_000) ?: return null
        val scaled = Bitmap.createScaledBitmap(frame, 480, 480 * frame.height / frame.width, true)
        FileOutputStream(path).use { scaled.compress(Bitmap.CompressFormat.JPEG, 80, it) }
        return path
    }
}
