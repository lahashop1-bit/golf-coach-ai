import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/app/app.dart';
import 'package:golf_coach_ai/app/providers.dart';
import 'package:golf_coach_ai/data/video_store.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'support/fakes.dart';

void main() {
  late TestEnv env;

  setUpAll(() => initializeDateFormatting());

  /// Drift runs real async I/O, which fake-async pumping alone never
  /// completes; interleave real waits with frames (bounded, unlike
  /// pumpAndSettle with a loading spinner on screen).
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  Future<void> pumpApp(WidgetTester tester) async {
    // Real file I/O must run outside the fake-async test zone.
    env = (await tester.runAsync(TestEnv.create))!;
    tester.platformDispatcher.localesTestValue = const [Locale('vi')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(env.db),
        videoStoreProvider.overrideWithValue(VideoStore(env.root)),
      ],
      child: const GolfCoachApp(),
    ));
    await settle(tester);
  }

  /// Drift's stream-cleanup timers live in the fake-async zone, so the DB
  /// is closed there and the timers are flushed with a pump.
  Future<void> teardown(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    final closing = env.db.close();
    await tester.pump(const Duration(seconds: 1));
    await closing;
    await tester.runAsync(() => env.root.delete(recursive: true));
  }

  testWidgets('first launch: onboarding in Vietnamese, then 4 tabs', (tester) async {
    await pumpApp(tester);
    expect(find.text('Chào mừng bạn'), findsOneWidget);
    expect(find.text('Thuận tay phải'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Bắt đầu'), 200);
    await tester.tap(find.text('Bắt đầu'));
    await settle(tester);

    for (final tab in ['Trang chủ', 'Quay', 'Nhật ký', 'Luyện tập']) {
      expect(find.text(tab), findsWidgets, reason: tab);
    }
    expect(find.text('Quay cú swing'), findsOneWidget);
    expect(find.text('Bạn chưa có cú swing nào. Hãy quay cú đầu tiên.'), findsOneWidget);

    await tester.tap(find.text('Nhật ký').last);
    await settle(tester);
    expect(find.text('Yêu thích'), findsOneWidget);

    await tester.tap(find.text('Quay').last);
    await settle(tester);
    expect(find.text('Phân tích có hướng dẫn'), findsOneWidget);
    expect(find.text('Khuyên dùng'), findsOneWidget);

    await tester.tap(find.text('Luyện tập').last);
    await settle(tester);
    expect(find.text('Bài tập đang được biên soạn'), findsOneWidget);

    await teardown(tester);
  });

  testWidgets('choosing English in onboarding switches the UI', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('English'));
    await settle(tester);
    expect(find.text('Welcome'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Get started'), 200);
    await tester.tap(find.text('Get started'));
    await settle(tester);
    expect(find.text('Record a swing'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);

    await teardown(tester);
  });
}
