import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/app/app.dart';
import 'package:golf_coach_ai/app/providers.dart';
import 'package:golf_coach_ai/data/db/database.dart';
import 'package:golf_coach_ai/data/swing_repository.dart';
import 'package:golf_coach_ai/data/video_store.dart';
import 'package:golf_coach_ai/domain/enums.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:video_player/video_player.dart';

/// End to end on a simulator/device with the real DB, native probe and
/// player. The camera and the system picker are not automatable here, so a
/// clip is saved through the same repository call they use.
///   flutter test integration_test --dart-define=PROBE_VIDEO=/abs/path.mp4
const _video = String.fromEnvironment('PROBE_VIDEO');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('saved swing shows in the log and plays frame by frame', (tester) async {
    if (_video.isEmpty) return markTestSkipped('PROBE_VIDEO not set');
    await initializeDateFormatting();
    final root = await Directory.systemTemp.createTemp('golf_it');
    final container = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(AppDatabase()),
      videoStoreProvider.overrideWithValue(VideoStore(root)),
    ]);
    addTearDown(container.dispose);
    final profiles = container.read(profileRepositoryProvider);
    await profiles.deleteAllData();
    final profile = await profiles.create(
        handedness: Handedness.right, preferredLocale: 'vi-VN');

    final repo = container.read(swingRepositoryProvider);
    final session = await repo.createSession(
      userId: profile.id,
      handedness: profile.handedness,
      source: Source.recorded,
      setup: const SessionSetup(
          mode: SessionMode.guidedAnalysis,
          cameraAngle: CameraAngle.faceOn,
          clubType: ClubType.iron,
          clubNumber: 7,
          plannedSwingCount: 1),
    );
    final copy = await File(_video).copy('${root.path}/incoming.mp4');
    final swing = await repo.addSwing(
        session: session, file: copy, platform: AppPlatform.ios);
    await repo.finishSession(session.id);
    expect(swing.actualFps, closeTo(60, 0.5));
    expect(swing.qualityLevel, QualityLevel.good);

    await tester.pumpWidget(UncontrolledProviderScope(
        container: container, child: const GolfCoachApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nhật ký').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Gậy sắt số 7 · Chính diện'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Ảnh bìa cú 1'));
    await tester.pumpAndSettle();
    expect(find.text('Cú 1'), findsOneWidget);

    final controller =
        tester.widget<VideoPlayer>(find.byType(VideoPlayer)).controller;
    expect(controller.value.isInitialized, isTrue);
    for (var i = 0; i < 6; i++) {
      await tester.tap(find.byTooltip('Khung hình sau'));
      await tester.pumpAndSettle();
    }
    final ms = controller.value.position.inMilliseconds;
    // 6 frames at 60 fps ≈ 100 ms; report the real value for the spike.
    debugPrint('frame-step position after 6 steps: $ms ms');
    expect(ms, inInclusiveRange(66, 134));

    await tester.drag(find.byType(ListView).last, const Offset(0, -600));
    await tester.pumpAndSettle();
    // Locale-aware numbers: nominal 59.99… fps reads as 60, "3,0" in vi.
    expect(find.text('60 khung/giây'), findsOneWidget);
    expect(find.text('3,0 giây'), findsOneWidget);

    await profiles.deleteAllData();
    await root.delete(recursive: true);
  });
}
