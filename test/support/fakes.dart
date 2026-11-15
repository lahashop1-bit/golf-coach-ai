import 'dart:io';

import 'package:capture/capture.dart';
import 'package:capture/src/messages.g.dart';
import 'package:drift/native.dart';
import 'package:golf_coach_ai/data/db/database.dart';
import 'package:golf_coach_ai/data/swing_repository.dart';
import 'package:golf_coach_ai/data/video_store.dart';

/// Returns fixed metadata instead of reading the file natively.
class FakeCaptureApi extends CaptureHostApi {
  FakeCaptureApi({this.durationMs = 3000, this.fps = 60, this.fail = false});

  int durationMs;
  double fps;
  bool fail;

  @override
  Future<VideoInfo> probeVideo(String videoPath, String? thumbnailPath) async {
    if (fail) throw Exception('unreadable');
    return VideoInfo(
      fps: fps,
      durationMs: durationMs,
      width: 1920,
      height: 1080,
      rotationDegrees: 90,
      fileSizeBytes: await File(videoPath).length(),
    );
  }
}

class TestEnv {
  TestEnv._(this.db, this.root, this.api, this.repo);

  final AppDatabase db;
  final Directory root;
  final FakeCaptureApi api;
  final SwingRepository repo;

  static Future<TestEnv> create() async {
    final db = AppDatabase(NativeDatabase.memory());
    final root = await Directory.systemTemp.createTemp('golf_test');
    final api = FakeCaptureApi();
    final repo = SwingRepository(db, VideoStore(root), Capture(api: api));
    return TestEnv._(db, root, api, repo);
  }

  /// A fake clip file outside the store (like a camera temp file).
  Future<File> clip([String name = 'clip.mov']) async {
    final dir = await Directory.systemTemp.createTemp('golf_clip');
    return File('${dir.path}/$name').writeAsBytes(List.filled(64, 1));
  }

  Future<void> dispose() async {
    await db.close();
    if (await root.exists()) await root.delete(recursive: true);
  }
}
