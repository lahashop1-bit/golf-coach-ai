import 'dart:io';

import 'package:analysis_core/analysis_core.dart' show IssueId;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/app/app.dart';
import 'package:golf_coach_ai/app/providers.dart';
import 'package:golf_coach_ai/data/db/database.dart';
import 'package:golf_coach_ai/features/analysis/issue_guide_screen.dart';
import 'package:golf_coach_ai/data/swing_repository.dart';
import 'package:golf_coach_ai/data/video_store.dart';
import 'package:golf_coach_ai/domain/enums.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:video_player/video_player.dart';

/// Full analysis loop on a simulator/device with real MediaPipe:
/// saved swing → "Phân tích cú này" → phases, skeleton, tempo, issues, guide.
///   flutter test integration_test/analysis_flow_test.dart \
///     --dart-define=POSE_VIDEO=/abs/real_swing.mp4 \
///     [--dart-define=POSE_ANGLE=down_the_line] [--dart-define=HOLD_SECONDS=10]
const _video = String.fromEnvironment('POSE_VIDEO');
const _angle = String.fromEnvironment('POSE_ANGLE', defaultValue: 'face_on');
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
        setup: SessionSetup(
            mode: SessionMode.selfRecord,
            cameraAngle: wireValue(CameraAngle.values, _angle),
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
    final result = container.read(analysisProvider(swing.id)).value!;
    for (final o in result.observations) {
      debugPrint('issue ${o.issueId}: ${o.level.wire} ${o.confidence.wire} '
          'metric=${o.metricValue?.toStringAsFixed(3)} focus=${o.isPriorityFocus}');
    }
    debugPrint('limitations: ${result.limitations}');
    expect(find.text('Nên sửa trước'), findsOneWidget);
    await tester.ensureVisible(find.text('Các pha swing'));
    await tester.pumpAndSettle();
    expect(find.text('Các điểm đã kiểm tra'), findsOneWidget);
    if (_hold > 0) await tester.runAsync(() => Future.delayed(Duration(seconds: _hold)));

    // Every checked issue opens its guide, with or without an observation.
    await tester.ensureVisible(find.text('Ngẩng đầu lúc tiếp xúc bóng').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ngẩng đầu lúc tiếp xúc bóng').last);
    await tester.pumpAndSettle();
    expect(find.text('Một điều nên thử'), findsOneWidget);
    expect(find.text('Nội dung nháp, đang chờ huấn luyện viên duyệt.'), findsOneWidget);
    final head = result.observation(IssueId.headLiftAtImpact);
    if (head != null && !head.hiddenFromUser) {
      await tester.scrollUntilVisible(find.text('Hữu ích'), 300,
          scrollable: find.descendant(
              of: find.byType(IssueGuideScreen), matching: find.byType(Scrollable)));
      await tester.ensureVisible(find.text('Hữu ích'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hữu ích'));
      await pumpUntil(tester, find.text('Cảm ơn bạn. Phản hồi chỉ được lưu trên máy này.'),
          seconds: 5);
    }
    if (_hold > 0) await tester.runAsync(() => Future.delayed(Duration(seconds: _hold)));

    await profiles.deleteAllData();
    await root.delete(recursive: true);
  });
}
