import 'dart:io';

import 'package:analysis_core/analysis_core.dart' show IssueId;
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
  TestWidgetsFlutterBinding.ensureInitialized(); // guides are bundled assets
  late TestEnv env;

  setUp(() async => env = await TestEnv.create());
  tearDown(() => env.dispose());

  Future<Swing> newSwing(
      {Handedness handedness = Handedness.right, CameraAngle angle = CameraAngle.faceOn}) async {
    final profile = await ProfileRepository(env.db, VideoStore(env.root))
        .create(handedness: handedness);
    final session = await env.repo.createSession(
        userId: profile.id,
        handedness: handedness,
        source: Source.recorded,
        setup: SessionSetup(
            mode: SessionMode.guidedAnalysis,
            cameraAngle: angle,
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

  group('issues', () {
    Future<AnalysisResult> analyse(Swing swing) async {
      await env.analysis.run(swing.id);
      return (await env.analysis.watchResult(swing.id).first)!;
    }

    test('rule results are stored with the priority focus', () async {
      env.pose.sequence = syntheticSwing(headRise: 0.05, hipShift: 0.05);
      final r = await analyse(await newSwing());
      expect(r.observations, hasLength(2));
      final head = r.observation(IssueId.headLiftAtImpact)!;
      expect(head.level, Level.review);
      expect(head.isPriorityFocus, isTrue);
      expect(head.hiddenFromUser, isFalse);
      expect(head.cameraAngle, CameraAngle.faceOn);
      expect(head.phase, SwingPhase.impact);
      expect(head.evidenceKey, 'issue.head_lift_at_impact.what_we_see');
      expect(head.evidenceFrameMs, r.phase(SwingPhase.impact)!.timestampMs);
      final back = r.observation(IssueId.hangingBackImpact)!;
      expect(back.level, Level.ok);
      expect(back.isPriorityFocus, isFalse);
    });

    test('a clip that does not match the session angle is flagged', () async {
      env.pose.sequence = syntheticSwing(); // face-on body
      final r = await analyse(await newSwing(angle: CameraAngle.downTheLine));
      expect(r.limitations, contains('analysis.limit.angle_mismatch'));
      expect(r.observations.map((o) => o.issueId), ['head_lift_at_impact']);
    });

    test('poorly visible landmarks are stored hidden and never focused', () async {
      env.pose.sequence = syntheticSwing(visibility: 0.45, headRise: 0.05);
      final r = await analyse(await newSwing());
      expect(r.observations, isNotEmpty);
      expect(r.visible, isEmpty);
      expect(r.observations.any((o) => o.isPriorityFocus), isFalse);
    });

    test('feedback keeps the latest answer and goes away with the swing', () async {
      env.pose.sequence = syntheticSwing(headRise: 0.05);
      final swing = await newSwing();
      final o = (await analyse(swing)).observation(IssueId.headLiftAtImpact)!;
      await env.analysis.setFeedback(o.id, FeedbackValue.unclear);
      await env.analysis.setFeedback(o.id, FeedbackValue.helpful);
      expect(await env.analysis.watchFeedback(o.id).first, FeedbackValue.helpful);
      expect(await env.db.select(env.db.analysisFeedbacks).get(), hasLength(1));

      await env.repo.deleteSwing(swing.id);
      expect(await env.db.select(env.db.issueObservations).get(), isEmpty);
      expect(await env.db.select(env.db.analysisFeedbacks).get(), isEmpty);
    });

    test('re-running replaces old observations', () async {
      final swing = await newSwing();
      await env.analysis.run(swing.id);
      final r = await analyse(swing);
      final all = await env.db.select(env.db.issueObservations).get();
      expect(all.map((o) => o.analysisId).toSet(), {r.row.id});
    });

    test('delete all data removes observations and feedback', () async {
      final o = (await analyse(await newSwing())).observations.first;
      await env.analysis.setFeedback(o.id, FeedbackValue.notRelevant);
      await ProfileRepository(env.db, VideoStore(env.root)).deleteAllData();
      expect(await env.db.select(env.db.issueObservations).get(), isEmpty);
      expect(await env.db.select(env.db.analysisFeedbacks).get(), isEmpty);
    });
  });
}
