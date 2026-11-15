import 'dart:typed_data';

import 'package:analysis_core/analysis_core.dart';
import 'package:test/test.dart';

import 'package:analysis_core/testing.dart';

void main() {
  const detector = PhaseDetector();

  group('keypoints file', () {
    test('encode/decode round trip', () {
      final seq = syntheticSwing();
      final back = KeypointSequence.decode(seq.encode());
      expect(back.frames, hasLength(seq.frames.length));
      expect(back.fps, 60);
      expect(back.width, 720);
      expect(back.model, 'synthetic');
      final a = seq.frames[70].points![Lm.leftWrist];
      final b = back.frames[70].points![Lm.leftWrist];
      expect(b.x, closeTo(a.x, 1e-6));
      expect(b.y, closeTo(a.y, 1e-6));
    });

    test('undetected frames survive the round trip', () {
      final seq = syntheticSwing();
      final frames = [...seq.frames]..[5] = PoseFrame(seq.frames[5].timestampMs, null);
      final withGap = KeypointSequence(
          fps: 60, width: 720, height: 1280, model: 'm', frames: frames);
      expect(KeypointSequence.decode(withGap.encode()).frames[5].points, isNull);
    });

    test('rejects other files', () {
      expect(() => KeypointSequence.decode(Uint8List(40)),
          throwsFormatException);
    });

    test('mirroring flips x and swaps left/right', () {
      final seq = syntheticSwing();
      final m = seq.mirrored();
      final o = seq.frames[0].points!, p = m.frames[0].points!;
      expect(p[Lm.leftShoulder].x, closeTo(1 - o[Lm.rightShoulder].x, 1e-9));
      final twice = m.mirrored().frames[0].points!;
      expect(twice[Lm.leftWrist].x, closeTo(o[Lm.leftWrist].x, 1e-9));
    });

    test('frameAt finds the nearest frame', () {
      final seq = syntheticSwing();
      // 60 fps frames at 1000 and 1017 ms: 1009 is closer to 1017.
      expect(seq.frameAt(1009)!.timestampMs, 1017);
      expect(seq.frameAt(1007)!.timestampMs, 1000);
    });
  });

  group('phases', () {
    void expectNear(SwingTiming r, SwingPhase p, int ms, {int tol = 40}) {
      final m = r[p];
      expect(m, isNotNull, reason: '$p missing');
      expect((m!.timestampMs - ms).abs(), lessThanOrEqualTo(tol),
          reason: '$p at ${m.timestampMs}, expected ~$ms');
    }

    test('finds all 8 phases in order on a 60 fps swing', () {
      final r = detector.detect(syntheticSwing())!;
      expect(r.phases.map((m) => m.phase), SwingPhase.values);
      final times = r.phases.map((m) => m.timestampMs).toList();
      expect(times, orderedEquals([...times]..sort()));
      // Threshold-based start detection lags a very gentle (smoothstep)
      // takeaway; tune on real labelled clips, not on this fixture.
      expectNear(r, SwingPhase.takeaway, 1000, tol: 100);
      expectNear(r, SwingPhase.top, 1950, tol: 60);
      expectNear(r, SwingPhase.impact, 2270);
      expectNear(r, SwingPhase.finish, 2770, tol: 120);
    });

    test('tempo is measured and trusted at 60 fps', () {
      final t = detector.detect(syntheticSwing())!.tempo!;
      expect(t.backswingMs, closeTo(900, 100));
      expect(t.downswingMs, closeTo(320, 80));
      expect(t.topPauseMs, greaterThan(50));
      expect(t.confidence, Confidence.high);
      expect(t.toJson()['ratio'], isA<double>());
    });

    test('low fps lowers timing confidence', () {
      final at30 = detector.detect(syntheticSwing(fps: 30))!;
      expect(at30.tempo!.confidence, Confidence.medium);
      final at24 = detector.detect(syntheticSwing(fps: 24))!;
      expect(at24.tempo!.confidence, Confidence.low);
      // Address is a still pose: frame rate does not matter.
      expect(at24[SwingPhase.address]!.confidence, Confidence.high);
    });

    test('poorly visible wrists lower confidence', () {
      final r = detector.detect(syntheticSwing(visibility: 0.55))!;
      expect(r[SwingPhase.top]!.confidence, Confidence.medium);
    });

    test('left-handed swing gives the same timing after mirroring', () {
      final right = detector.detect(syntheticSwing())!;
      final left = detector.detect(syntheticSwing().mirrored())!;
      for (final p in SwingPhase.values) {
        expect(left[p]?.timestampMs, right[p]?.timestampMs, reason: '$p');
      }
    });

    test('clip starting mid-backswing has no takeaway or tempo', () {
      final r = detector.detect(syntheticSwing(startAt: 1500))!;
      expect(r[SwingPhase.takeaway], isNull);
      expect(r[SwingPhase.address], isNull);
      expect(r.tempo, isNull);
      expect(r[SwingPhase.impact], isNotNull);
    });

    test('no swing in a still clip', () {
      expect(detector.detect(syntheticSwing(takeaway: 99999, top: 99999,
          topEnd: 99999, impact: 99999, finish: 99999)), isNull);
    });

    test('no person detected gives no result', () {
      final seq = syntheticSwing();
      final empty = KeypointSequence(fps: 60, width: 720, height: 1280, model: 'm',
          frames: [for (final f in seq.frames) PoseFrame(f.timestampMs, null)]);
      expect(detector.detect(empty), isNull);
    });

    test('json round trip of marks and tempo', () {
      final r = detector.detect(syntheticSwing())!;
      final m = r.phases.first;
      final back = PhaseMark.fromJson(m.toJson());
      expect(back.phase, m.phase);
      expect(back.timestampMs, m.timestampMs);
      expect(Tempo.fromJson(r.tempo!.toJson()).downswingMs, r.tempo!.downswingMs);
    });
  });
}
