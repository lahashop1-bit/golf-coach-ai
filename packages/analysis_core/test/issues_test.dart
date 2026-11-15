import 'package:analysis_core/analysis_core.dart';
import 'package:analysis_core/testing.dart';
import 'package:test/test.dart';

/// Group-A rules on synthetic swings with known faults. Thresholds are
/// provisional; these tests pin the rule logic, not real-world accuracy.
void main() {
  const detector = IssueDetector();

  IssueReport run(KeypointSequence seq, CameraAngle angle) =>
      detector.detect(seq, const PhaseDetector().detect(seq)!, angle);

  Map<IssueId, Level> levels(IssueReport r) =>
      {for (final f in r.findings) f.issue: f.level};

  group('issue rules', () {
    test('a clean face-on swing is ok on every face-on rule', () {
      final r = run(syntheticSwing(hipShift: 0.05), CameraAngle.faceOn);
      expect(r.angleMismatch, isFalse);
      expect(levels(r), {
        IssueId.headLiftAtImpact: Level.ok,
        IssueId.hangingBackImpact: Level.ok,
      });
    });

    test('a clean DTL swing is ok on every DTL rule', () {
      final r = run(syntheticSwing(angle: CameraAngle.downTheLine), CameraAngle.downTheLine);
      expect(r.angleMismatch, isFalse);
      expect(levels(r), {
        IssueId.headLiftAtImpact: Level.ok,
        IssueId.spineAngleLossTop: Level.ok,
        IssueId.earlyExtension: Level.ok,
      });
    });

    test('head rise grades attention then review', () {
      expect(levels(run(syntheticSwing(hipShift: 0.05, headRise: 0.03), CameraAngle.faceOn))
          [IssueId.headLiftAtImpact], Level.attention);
      expect(levels(run(syntheticSwing(hipShift: 0.05, headRise: 0.05), CameraAngle.faceOn))
          [IssueId.headLiftAtImpact], Level.review);
    });

    test('hips staying back face-on is hanging back', () {
      Level? at(double shift) =>
          levels(run(syntheticSwing(hipShift: shift), CameraAngle.faceOn))[IssueId.hangingBackImpact];
      expect(at(0.05), Level.ok);
      expect(at(0.01), Level.attention);
      expect(at(-0.02), Level.review);
    });

    test('DTL: hips toward the ball is early extension', () {
      Level? at(double shift) => levels(run(
          syntheticSwing(angle: CameraAngle.downTheLine, hipShift: shift),
          CameraAngle.downTheLine))[IssueId.earlyExtension];
      expect(at(0.04), Level.attention);
      expect(at(0.07), Level.review);
    });

    test('DTL: trunk standing up at the top is spine angle loss', () {
      Level? at(double shift) => levels(run(
          syntheticSwing(angle: CameraAngle.downTheLine, shoulderShiftAtTop: shift),
          CameraAngle.downTheLine))[IssueId.spineAngleLossTop];
      expect(at(0.06), Level.attention);
      expect(at(0.10), Level.review);
    });

    test('evidence frame is the phase the issue is judged at', () {
      final seq = syntheticSwing(angle: CameraAngle.downTheLine);
      final timing = const PhaseDetector().detect(seq)!;
      for (final f in detector.detect(seq, timing, CameraAngle.downTheLine).findings) {
        expect(f.evidenceFrameMs, timing[f.issue.phase]!.timestampMs);
      }
    });

    test('a wrong camera angle skips angle-specific rules', () {
      final r = run(syntheticSwing(angle: CameraAngle.downTheLine), CameraAngle.faceOn);
      expect(r.angleMismatch, isTrue);
      expect(levels(r).keys, [IssueId.headLiftAtImpact]);
      final r2 = run(syntheticSwing(), CameraAngle.downTheLine);
      expect(r2.angleMismatch, isTrue);
      expect(levels(r2).keys, [IssueId.headLiftAtImpact]);
    });

    test('confidence is capped at medium while thresholds are provisional', () {
      final r = run(syntheticSwing(hipShift: 0.05, headRise: 0.05), CameraAngle.faceOn);
      expect(r.findings.map((f) => f.confidence).toSet(), {Confidence.medium});
    });

    test('poorly visible landmarks give hidden findings', () {
      final r = run(syntheticSwing(visibility: 0.4, hipShift: 0.05, headRise: 0.05),
          CameraAngle.faceOn);
      expect(r.findings, isNotEmpty);
      expect(r.findings.every((f) => f.hidden), isTrue);
    });
  });

  group('focus selector', () {
    IssueFinding f(IssueId id, Level level, [Confidence c = Confidence.medium]) =>
        IssueFinding(issue: id, level: level, confidence: c, evidenceFrameMs: 0, metric: 0);
    const priority = {
      IssueId.spineAngleLossTop: 1,
      IssueId.earlyExtension: 2,
      IssueId.hangingBackImpact: 3,
      IssueId.headLiftAtImpact: 4,
    };

    test('review beats attention; ok and hidden are never chosen', () {
      final pick = const FocusSelector().select([
        f(IssueId.spineAngleLossTop, Level.attention),
        f(IssueId.headLiftAtImpact, Level.review),
        f(IssueId.earlyExtension, Level.ok),
        f(IssueId.hangingBackImpact, Level.review, Confidence.low),
      ], editorialPriority: priority);
      expect(pick, [IssueId.headLiftAtImpact, IssueId.spineAngleLossTop]);
    });

    test('ties go to repeats, then editorial priority', () {
      final findings = [
        f(IssueId.headLiftAtImpact, Level.attention),
        f(IssueId.earlyExtension, Level.attention),
        f(IssueId.spineAngleLossTop, Level.attention),
      ];
      expect(const FocusSelector().select(findings, editorialPriority: priority),
          [IssueId.spineAngleLossTop, IssueId.earlyExtension]);
      expect(
          const FocusSelector().select(findings,
              editorialPriority: priority, repeats: {IssueId.headLiftAtImpact: 3}),
          [IssueId.headLiftAtImpact, IssueId.spineAngleLossTop]);
    });

    test('nothing to fix gives an empty focus', () {
      expect(const FocusSelector().select([f(IssueId.earlyExtension, Level.ok)],
          editorialPriority: priority), isEmpty);
    });
  });
}
