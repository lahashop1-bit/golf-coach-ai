import 'package:analysis_core/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/app/app.dart';
import 'package:golf_coach_ai/app/providers.dart';
import 'package:golf_coach_ai/app/router.dart';
import 'package:golf_coach_ai/data/profile_repository.dart';
import 'package:golf_coach_ai/data/swing_repository.dart';
import 'package:golf_coach_ai/data/video_store.dart';
import 'package:golf_coach_ai/domain/enums.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'support/fakes.dart';

/// Posture tab → issue guide → feedback, on a fake analysis with a known
/// fault (head rises by impact).
void main() {
  late TestEnv env;

  setUpAll(() => initializeDateFormatting());

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  testWidgets('priority issue opens its guide and records feedback', (tester) async {
    late String swingId;
    await tester.runAsync(() async {
      env = await TestEnv.create();
      env.pose.sequence = syntheticSwing(headRise: 0.05, hipShift: 0.05);
      final profile = await ProfileRepository(env.db, VideoStore(env.root))
          .create(handedness: Handedness.right);
      final session = await env.repo.createSession(
          userId: profile.id,
          handedness: Handedness.right,
          source: Source.recorded,
          setup: SessionSetup(
              mode: SessionMode.guidedAnalysis,
              cameraAngle: CameraAngle.faceOn,
              clubType: ClubType.iron,
              clubNumber: 7));
      final swing = await env.repo
          .addSwing(session: session, file: await env.clip(), platform: AppPlatform.ios);
      swingId = swing.id;
      await env.analysis.run(swing.id);
    });

    tester.platformDispatcher.localesTestValue = const [Locale('vi')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(env.db),
        videoStoreProvider.overrideWithValue(VideoStore(env.root)),
        poseEngineProvider.overrideWithValue(env.pose),
      ],
      child: const GolfCoachApp(),
    ));
    await settle(tester);
    ProviderScope.containerOf(tester.element(find.byType(GolfCoachApp)))
        .read(routerProvider)
        .push('/swing/$swingId');
    await settle(tester);

    await tester.tap(find.text('Tư thế'));
    await settle(tester);
    expect(find.text('Nên sửa trước'), findsOneWidget);
    expect(find.text('Ngẩng đầu lúc tiếp xúc bóng'), findsWidgets);
    expect(find.text('Cần xem lại'), findsWidgets);
    expect(find.text('Có vẻ có dấu hiệu này.'), findsOneWidget);
    expect(find.text('Thấy ở: Tiếp xúc'), findsOneWidget);

    await tester.tap(find.text('Xem cách sửa'));
    await settle(tester);
    expect(find.text('Nội dung nháp, đang chờ huấn luyện viên duyệt.'), findsOneWidget);
    expect(find.text('Điều AI quan sát thấy'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Hữu ích'), 300);
    await tester.tap(find.text('Hữu ích'));
    await settle(tester);
    expect(find.text('Cảm ơn bạn. Phản hồi chỉ được lưu trên máy này.'), findsOneWidget);
    final saved = await tester.runAsync(() => env.db.select(env.db.analysisFeedbacks).get());
    expect(saved!.single.value, FeedbackValue.helpful);

    // An issue judged "ok" must not describe the fault as seen.
    ProviderScope.containerOf(tester.element(find.byType(GolfCoachApp)))
        .read(routerProvider)
        .push('/swing/$swingId/issue/hanging_back_impact');
    await settle(tester);
    expect(find.text('Ổn'), findsOneWidget);
    expect(find.textContaining('Chưa thấy dấu hiệu này'), findsOneWidget);
    expect(find.text('Điều AI quan sát thấy'), findsNothing);
    expect(find.text('Có vẻ có dấu hiệu này.'), findsNothing);

    await tester.pumpWidget(const SizedBox());
    final closing = env.db.close();
    await tester.pump(const Duration(seconds: 1));
    await closing;
    await tester.runAsync(() => env.root.delete(recursive: true));
  });
}
