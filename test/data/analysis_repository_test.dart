import 'dart:io';

import 'package:analysis_core/testing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/data/analysis_repository.dart';
import 'package:golf_coach_ai/data/db/database.dart';
import 'package:golf_coach_ai/data/profile_repository.dart';
import 'package:golf_coach_ai/data/swing_repository.dart';
import 'package:golf_coach_ai/data/video_store.dart';
import 'package:golf_coach_ai/domain/enums.dart';

import '../support/fakes.dart';

void main() {
  late TestEnv env;

  setUp(() async => env = await TestEnv.create());
  tearDown(() => env.dispose());

  Future<Swing> newSwing({Handedness handedness = Handedness.right}) async {
    final profile = await ProfileRepository(env.db, VideoStore(env.root))
        .create(handedness: handedness);
    final session = await env.repo.createSession(
        userId: profile.id,
        handedness: handedness,
        source: Source.recorded,
        setup: const SessionSetup(
            mode: SessionMode.guidedAnalysis,
            cameraAngle: CameraAngle.faceOn,
            clubType: ClubType.iron,
            clubNumber: 7));
    return env.repo.addSwing(session: session, file: await env.clip(), platform: AppPlatform.ios);
  }

  bool exists(String? rel) => File(env.repo.videos.absolute(rel!)).existsSync();

  test('completed analysis stores phases, tempo and limitations', () async {
    final swing = await newSwing();
    final row = await env.analysis.run(swing.id);
    expect(row.status, AnalysisStatus.completed);
    expect(row.isCurrent, isTrue);
    expect(row.mirrored, isFalse);
    expect(exists(row.keypointsFilePath), isTrue);

    final r = AnalysisResult(row);
    expect(r.phases.map((m) => m.phase), SwingPhase.values);
    expect(r.tempo, isNotNull);
    expect(r.limitations, ['analysis.limit.single_2d_view']);
    expect(await env.analysis.loadKeypoints(row), isNotNull);
  });

  test('left-handed swings are mirrored before rules', () async {
    env.pose.sequence = syntheticSwing().mirrored();
    final swing = await newSwing(handedness: Handedness.left);
    final row = await env.analysis.run(swing.id);
    expect(row.mirrored, isTrue);
    expect(AnalysisResult(row).phase(SwingPhase.top), isNotNull);
  });

  test('low fps adds a limitation', () async {
    env.pose.sequence = syntheticSwing(fps: 30);
    final row = await env.analysis.run((await newSwing()).id);
    expect(AnalysisResult(row).limitations, contains('analysis.limit.low_fps'));
  });

  test('no person / no swing is insufficient quality, not an error', () async {
    env.pose.sequence = null;
    final row = await env.analysis.run((await newSwing()).id);
    expect(row.status, AnalysisStatus.insufficientQuality);
    expect(AnalysisResult(row).phases, isEmpty);
    expect(AnalysisResult(row).limitations, contains('analysis.limit.no_swing_detected'));
  });

  test('native failure is recorded with a code', () async {
    env.pose.errorCode = 'unsupported';
    final row = await env.analysis.run((await newSwing()).id);
    expect(row.status, AnalysisStatus.failed);
    expect(row.errorCode, 'unsupported');
  });

  test('cancelled run leaves nothing behind', () async {
    env.pose.errorCode = 'cancelled';
    final swing = await newSwing();
    await expectLater(env.analysis.run(swing.id), throwsA(isA<PlatformException>()));
    expect(await env.analysis.watchLatest(swing.id).first, isNull);
  });

  test('re-running replaces the previous analysis and its file', () async {
    final swing = await newSwing();
    final first = await env.analysis.run(swing.id);
    final second = await env.analysis.run(swing.id);
    expect((await env.analysis.watchLatest(swing.id).first)!.id, second.id);
    expect(exists(first.keypointsFilePath), isFalse);
    expect(exists(second.keypointsFilePath), isTrue);
  });

  test('deleting a swing deletes its analysis and keypoints', () async {
    final swing = await newSwing();
    final row = await env.analysis.run(swing.id);
    await env.repo.deleteSwing(swing.id);
    expect(await env.analysis.watchLatest(swing.id).first, isNull);
    expect(exists(row.keypointsFilePath), isFalse);
  });
}
