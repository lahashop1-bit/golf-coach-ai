import 'dart:io';

import 'package:analysis_core/analysis_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pose/pose.dart';

/// Runs the real MediaPipe model on a clip with one visible person.
///   flutter test integration_test/pose_test.dart --dart-define=POSE_VIDEO=/abs/clip.mp4
const _video = String.fromEnvironment('POSE_VIDEO');

/// Optional host path to keep the keypoints file (simulator only).
const _out = String.fromEnvironment('POSE_OUT');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('pose runs on a real clip and writes keypoints', (tester) async {
    if (_video.isEmpty) return markTestSkipped('POSE_VIDEO not set');
    final out = _out.isNotEmpty ? _out : '${Directory.systemTemp.path}/pose_it.gckp';
    final progress = <double>[];
    final sw = Stopwatch()..start();
    final r = await Pose().analyzeVideo(
        jobId: 'it', videoPath: _video, outputPath: out, onProgress: progress.add);
    debugPrint('pose: ${r.frameCount} frames, ${r.detectedFrames} detected, '
        '${r.fps.toStringAsFixed(1)} fps, ${r.width}x${r.height}, ${sw.elapsedMilliseconds} ms');
    expect(r.frameCount, greaterThan(100));
    expect(r.detectedFrames / r.frameCount, greaterThan(0.8));
    expect(progress.last, 1);
    expect(File(out).lengthSync(), greaterThan(r.frameCount * 401));

    final seq = KeypointSequence.decode(File(out).readAsBytesSync());
    expect(seq.frames, hasLength(r.frameCount));
    final timing = const PhaseDetector().detect(seq);
    debugPrint('phases: ${timing?.phases.map((m) => '${m.phase.wire}=${m.timestampMs}(${m.confidence.wire})').join(' ')}');
    debugPrint('tempo: ${timing?.tempo?.toJson()}');
    expect(timing, isNotNull);
    expect(timing![SwingPhase.top], isNotNull);
    expect(timing[SwingPhase.impact], isNotNull);
  });
}
