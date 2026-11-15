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

/// Full analysis loop on a simulator/device with real MediaPipe:
/// saved swing → "Phân tích cú này" → phases, skeleton, tempo.
///   flutter test integration_test/analysis_flow_test.dart \
///     --dart-define=POSE_VIDEO=/abs/real_swing.mp4 [--dart-define=HOLD_SECONDS=10]
const _video = String.fromEnvironment('POSE_VIDEO');
const _hold = int.fromEnvironment('HOLD_SECONDS');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpUntil(WidgetTester tester, Finder f, {int seconds = 60}) async {
    for (var i = 0; i < seconds * 4; i++) {
      await tester.pump(const Duration(milliseconds: 250));
      if (f.evaluate().isNotEmpty) return;
    }
    fail('Timed out waiting for $f');
  }

  testWidgets('analyze a real swing and read phases and tempo', (tester) async {
    if (_video.isEmpty) return markTestSkipped('POSE_VIDEO not set');
    await initializeDateFormatting();
    final root = await Directory.systemTemp.createTemp('golf_ai_it');
    final container = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(AppDatabase()),
      videoStoreProvider.overrideWithValue(VideoStore(root)),
    ]);
    addTearDown(container.dispose);
    final profiles = container.read(profileRepositoryProvider);
    await profiles.deleteAllData();
    final profile = await profiles.create(handedness: Handedness.right, preferredLocale: 'vi-VN');
    final repo = container.read(swingRepositoryProvider);
    final session = await repo.createSession(
        userId: profile.id,
        handedness: profile.handedness,
        source: Source.imported,
        setup: const SessionSetup(
            mode: SessionMode.selfRecord,
            cameraAngle: CameraAngle.faceOn,
            clubType: ClubType.iron,
            clubNumber: 7));
    final swing = await repo.addSwing(
        session: session,
        file: await File(_video).copy('${root.path}/in.mp4'),
        platform: AppPlatform.ios);
    await repo.finishSession(session.id);

    await tester.pumpWidget(UncontrolledProviderScope(
        container: container, child: const GolfCoachApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nhật ký').last);
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Ảnh bìa cú 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Phân tích cú này'));
    await pumpUntil(tester, find.byTooltip('Khung xương'));
    debugPrint('analysis: ${container.read(analysisProvider(swing.id)).value?.row.phasesJson}');

    final top = tester.widget<ActionChip>(find.widgetWithText(ActionChip, 'Đỉnh'));
    expect(top.onPressed, isNotNull);
    await tester.tap(find.widgetWithText(ActionChip, 'Đỉnh'));
    final controller = tester.widget<VideoPlayer>(find.byType(VideoPlayer)).controller;
    final topMs = container.read(analysisProvider(swing.id)).value!
        .phase(SwingPhase.top)!.timestampMs;
    // seekTo completes natively; wait for the reported position.
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
      await tester.pump();
      if ((controller.value.position.inMilliseconds - topMs).abs() < 60) break;
    }
    expect((controller.value.position.inMilliseconds - topMs).abs(), lessThan(60));

    if (_hold > 0) await tester.runAsync(() => Future.delayed(Duration(seconds: _hold)));

    await tester.tap(find.text('Nhịp'));
    await tester.pumpAndSettle();
    expect(find.text('Tỷ lệ nhịp'), findsOneWidget);
    if (_hold > 0) await tester.runAsync(() => Future.delayed(Duration(seconds: _hold)));

    await tester.tap(find.text('Tư thế'));
    await tester.pumpAndSettle();
    expect(find.text('Các pha swing'), findsOneWidget);
    if (_hold > 0) await tester.runAsync(() => Future.delayed(Duration(seconds: _hold)));

    await profiles.deleteAllData();
    await root.delete(recursive: true);
  });
}
