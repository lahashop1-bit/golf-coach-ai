import 'dart:io';

import 'package:capture/capture.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Runs the real native `capture` plugin on a device/simulator.
/// Pass a host-readable clip (simulator) via:
///   flutter test integration_test --dart-define=PROBE_VIDEO=/abs/path.mp4
const _video = String.fromEnvironment('PROBE_VIDEO');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('probeVideo reads real fps/duration and writes a thumbnail',
      (tester) async {
    if (_video.isEmpty) {
      markTestSkipped('PROBE_VIDEO not set');
      return;
    }
    final thumb = '${Directory.systemTemp.path}/probe_thumb.jpg';
    final info = await Capture().probeVideo(_video, thumbnailPath: thumb);
    expect(info.fps, closeTo(60, 0.5));
    expect(info.durationMs, closeTo(3000, 50));
    expect(info.width, 720);
    expect(info.height, 1280);
    expect(info.thumbnailPath, thumb);
    expect(File(thumb).lengthSync(), greaterThan(0));
  });
}
