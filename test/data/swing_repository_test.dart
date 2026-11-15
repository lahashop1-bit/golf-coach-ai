import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/data/db/database.dart';
import 'package:golf_coach_ai/data/profile_repository.dart';
import 'package:golf_coach_ai/data/swing_repository.dart';
import 'package:golf_coach_ai/data/video_store.dart';
import 'package:golf_coach_ai/domain/enums.dart';

import '../support/fakes.dart';

void main() {
  late TestEnv env;
  late UserProfile profile;

  const setup = SessionSetup(
    mode: SessionMode.guidedAnalysis,
    cameraAngle: CameraAngle.downTheLine,
    clubType: ClubType.iron,
    clubNumber: 7,
    plannedSwingCount: 3,
  );

  setUp(() async {
    env = await TestEnv.create();
    profile = await ProfileRepository(env.db, VideoStore(env.root))
        .create(handedness: Handedness.left);
  });
  tearDown(() => env.dispose());

  Future<SwingSession> newSession({SessionSetup s = setup}) => env.repo.createSession(
      userId: profile.id, handedness: profile.handedness, setup: s, source: Source.recorded);

  test('addSwing moves the clip into the store with real metadata', () async {
    final session = await newSession();
    final clip = await env.clip();
    final swing = await env.repo
        .addSwing(session: session, file: clip, platform: AppPlatform.ios);

    expect(await clip.exists(), isFalse);
    expect(swing.localFilePath, 'swings/${swing.id}.mov');
    expect(await File(env.repo.videos.absolute(swing.localFilePath)).exists(), isTrue);
    expect(swing.actualFps, 60);
    expect(swing.orderIndex, 1);
    expect(swing.qualityLevel, QualityLevel.good);
    expect(swing.includeInStats, isTrue);
    expect(session.handednessSnapshot, Handedness.left);
  });

  test('swings of someone else are excluded from stats by default', () async {
    final session = await newSession(
        s: const SessionSetup(
            mode: SessionMode.selfRecord,
            cameraAngle: CameraAngle.faceOn,
            clubType: ClubType.none,
            clubNumber: 7,
            subject: Subject.other));
    final swing = await env.repo
        .addSwing(session: session, file: await env.clip(), platform: AppPlatform.ios);
    expect(swing.subject, Subject.other);
    expect(swing.includeInStats, isFalse);
    expect(session.clubNumber, isNull, reason: 'no-club sessions have no number');
  });

  test('low fps and short clips are flagged', () async {
    env.api
      ..fps = 24
      ..durationMs = 500;
    final swing = await env.repo.addSwing(
        session: await newSession(), file: await env.clip(), platform: AppPlatform.ios);
    expect(swing.qualityLevel, QualityLevel.poor);
    expect(swing.qualityIssues, [QualityIssue.tooShort, QualityIssue.lowFps]);
  });

  test('unreadable clip is not left behind', () async {
    env.api.fail = true;
    final session = await newSession();
    await expectLater(
        env.repo.addSwing(session: session, file: await env.clip(), platform: AppPlatform.ios),
        throwsException);
    final dir = Directory('${env.root.path}/swings');
    expect(await dir.list().isEmpty, isTrue);
  });

  test('sessions appear in the log only once finished', () async {
    final session = await newSession();
    await env.repo.addSwing(session: session, file: await env.clip(), platform: AppPlatform.ios);
    expect(await env.repo.watchSessions().first, isEmpty);

    await env.repo.finishSession(session.id);
    final list = await env.repo.watchSessions().first;
    expect(list.single.swings, hasLength(1));
  });

  test('interrupted sessions are recovered; empty ones dropped', () async {
    final kept = await newSession();
    await env.repo.addSwing(session: kept, file: await env.clip(), platform: AppPlatform.ios);
    await newSession(); // empty, interrupted

    await env.repo.recoverInterruptedSessions();
    final list = await env.repo.watchSessions().first;
    expect(list.map((e) => e.session.id), [kept.id]);
  });

  test('deleting the last swing deletes its files and the session', () async {
    final session = await newSession();
    final swing = await env.repo
        .addSwing(session: session, file: await env.clip(), platform: AppPlatform.ios);
    await env.repo.finishSession(session.id);

    await env.repo.deleteSwing(swing.id);
    expect(await File(env.repo.videos.absolute(swing.localFilePath)).exists(), isFalse);
    expect(await env.repo.watchSessions().first, isEmpty);
  });

  test('favorite, note and subject updates', () async {
    final session = await newSession();
    final swing = await env.repo
        .addSwing(session: session, file: await env.clip(), platform: AppPlatform.ios);
    await env.repo.setFavorite(swing.id, true);
    await env.repo.setNote(swing.id, '  đứng gần bóng hơn ');
    await env.repo.setIncludeInStats(swing.id, false);
    final updated = (await env.repo.watchSwing(swing.id).first)!;
    expect(updated.isFavorite, isTrue);
    expect(updated.note, 'đứng gần bóng hơn');
    expect(updated.includeInStats, isFalse);

    await env.repo.setNote(swing.id, '   ');
    expect((await env.repo.watchSwing(swing.id).first)!.note, isNull);
  });
}
