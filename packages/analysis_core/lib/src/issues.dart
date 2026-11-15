import 'dart:math' as math;

import 'keypoints.dart';
import 'phases.dart';
import 'types.dart';

/// Group-A issue catalogue (AI_ANALYSIS_SPEC §10): which phase each issue is
/// judged at and which camera angles can show it.
enum IssueId {
  headLiftAtImpact('head_lift_at_impact', SwingPhase.impact,
      {CameraAngle.faceOn, CameraAngle.downTheLine}),
  spineAngleLossTop('spine_angle_loss_top', SwingPhase.top, {CameraAngle.downTheLine}),
  earlyExtension('early_extension', SwingPhase.impact, {CameraAngle.downTheLine}),
  hangingBackImpact('hanging_back_impact', SwingPhase.impact, {CameraAngle.faceOn});

  const IssueId(this.wire, this.phase, this.angles);
  final String wire;
  final SwingPhase phase;
  final Set<CameraAngle> angles;

  static IssueId? byWire(String w) {
    for (final i in values) {
      if (i.wire == w) return i;
    }
    return null;
  }
}

/// One rule result for one swing (stored as an IssueObservation).
class IssueFinding {
  const IssueFinding({
    required this.issue,
    required this.level,
    required this.confidence,
    required this.evidenceFrameMs,
    required this.metric,
  });

  final IssueId issue;

  /// `ok`, `attention` or `review`.
  final Level level;
  final Confidence confidence;
  final int evidenceFrameMs;

  /// Raw measurement the level came from (unit depends on the rule). Kept for
  /// threshold tuning; never shown to the user.
  final double metric;

  /// Low-confidence findings are stored for evaluation but not shown (§4).
  bool get hidden => confidence == Confidence.low;
}

class IssueReport {
  const IssueReport(this.findings, {required this.angleMismatch});
  final List<IssueFinding> findings;

  /// The body does not look like the camera angle chosen for the session.
  final bool angleMismatch;
}

/// Provisional thresholds: [attention] and [review] on a metric where a
/// larger value is worse. NOT validated — Phase 3 must tune them on labelled
/// video (AI_ANALYSIS_SPEC §10).
class Threshold {
  const Threshold(this.attention, this.review);
  final double attention, review;

  Level levelOf(double v) =>
      v >= review ? Level.review : (v >= attention ? Level.attention : Level.ok);
}

/// Geometric rules on smoothed keypoints, written for right-handed golfers
/// (left-handed sequences arrive mirrored). Distances are in torso lengths
/// so they do not depend on how far the golfer stands from the camera.
class IssueDetector {
  const IssueDetector();

  /// Rise of the head from address to impact, in torso lengths.
  static const headLift = Threshold(0.08, 0.15);

  /// Loss of forward bend from address to top, in degrees (DTL).
  static const spineLoss = Threshold(7, 13);

  /// Hip travel toward the ball from address to impact, in torso lengths (DTL).
  static const hipTowardBall = Threshold(0.07, 0.14);

  /// Hip travel *away* from the target from address to impact, in stance
  /// widths (face-on). 0 = hips back where they started.
  static const hipHangBack = Threshold(-0.08, 0.0);

  /// Thresholds are unvalidated, so no finding is reported above medium.
  static const maxConfidence = Confidence.medium;

  /// Shoulder width / torso length at address. Facing the camera the
  /// shoulders look wide (about 0.7+); from DTL they nearly overlap (about
  /// 0.2). Below this the clip is not treated as face-on, at or above it not
  /// as DTL.
  static const faceOnMinShoulderRatio = 0.45;

  /// Every group-A rule that can run for [angle]. Rules whose phases or
  /// landmarks are missing are left out; the UI shows those as
  /// "not enough data". When the body does not look like the chosen [angle],
  /// angle-specific rules are skipped and [IssueReport.angleMismatch] is set.
  IssueReport detect(KeypointSequence seq, SwingTiming timing, CameraAngle angle) {
    const none = IssueReport([], angleMismatch: false);
    final address = timing[SwingPhase.address];
    if (address == null) return none;
    final body = _Body(seq);
    final a = body.at(address.timestampMs);
    if (a == null) return none;
    final torso = a.torso;
    if (torso <= 0) return none;
    final looksFaceOn = a.shoulderWidth / torso >= faceOnMinShoulderRatio;
    final mismatch = looksFaceOn != (angle == CameraAngle.faceOn);

    final out = <IssueFinding>[];
    void add(IssueId id, PhaseMark mark, double metric, Threshold th, double vis) {
      out.add(IssueFinding(
        issue: id,
        level: th.levelOf(metric),
        confidence: address.confidence
            .min(mark.confidence)
            .min(_visConfidence(vis))
            .min(maxConfidence),
        evidenceFrameMs: mark.timestampMs,
        metric: metric,
      ));
    }

    final impact = timing[SwingPhase.impact];
    final top = timing[SwingPhase.top];
    final i = impact == null ? null : body.at(impact.timestampMs);
    final t = top == null ? null : body.at(top.timestampMs);

    if (i != null) {
      add(IssueId.headLiftAtImpact, impact!, (a.head.y - i.head.y) / torso,
          headLift, math.min(a.headVis, i.headVis));
    }
    if (mismatch) {
      // Only the angle-independent rule above applies.
    } else if (angle == CameraAngle.downTheLine) {
      // Hands hang in front of the body, so they show which way the golfer faces.
      final facing = (a.hands.x - a.hips.x).sign;
      if (facing != 0) {
        if (t != null) {
          add(IssueId.spineAngleLossTop, top!, a.bend(facing) - t.bend(facing), spineLoss,
              math.min(a.trunkVis, t.trunkVis));
        }
        if (i != null) {
          add(IssueId.earlyExtension, impact!, (i.hips.x - a.hips.x) * facing / torso,
              hipTowardBall, math.min(a.trunkVis, i.trunkVis));
        }
      }
    } else if (i != null) {
      // Facing the camera, the lead (left) hip is on the target side.
      final target = (a.leftHip.x - a.rightHip.x).sign;
      final stance = a.stance;
      if (target != 0 && stance > torso * 0.2) {
        add(IssueId.hangingBackImpact, impact!, -(i.hips.x - a.hips.x) * target / stance,
            hipHangBack, math.min(a.trunkVis, i.trunkVis));
      }
    }
    return IssueReport(out, angleMismatch: mismatch);
  }

  static Confidence _visConfidence(double v) =>
      v >= 0.7 ? Confidence.high : (v >= 0.5 ? Confidence.medium : Confidence.low);
}

typedef _P = ({double x, double y});

/// Body landmarks averaged over a few frames around a moment. x is scaled by
/// the aspect ratio so x and y share one unit (frame height).
class _Body {
  _Body(this.seq) : aspect = seq.width / math.max(seq.height, 1);
  final KeypointSequence seq;
  final double aspect;

  static const _radius = 2;

  _Pose? at(int ms) {
    final frames = seq.frames;
    var c = 0;
    for (var k = 1; k < frames.length; k++) {
      if ((frames[k].timestampMs - ms).abs() < (frames[c].timestampMs - ms).abs()) c = k;
    }
    final window = [
      for (var k = math.max(0, c - _radius); k <= math.min(frames.length - 1, c + _radius); k++)
        if (frames[k].points != null) frames[k].points!,
    ];
    if (window.isEmpty) return null;
    Landmark avg(int idx) {
      var x = 0.0, y = 0.0, v = 0.0;
      for (final p in window) {
        x += p[idx].x;
        y += p[idx].y;
        v += p[idx].visibility;
      }
      final n = window.length;
      return Landmark(x / n * aspect, y / n, v / n);
    }

    return _Pose({
      for (final idx in const [
        Lm.nose, Lm.leftEar, Lm.rightEar, Lm.leftShoulder, Lm.rightShoulder,
        Lm.leftWrist, Lm.rightWrist, Lm.leftHip, Lm.rightHip, Lm.leftAnkle, Lm.rightAnkle,
      ])
        idx: avg(idx),
    });
  }
}

class _Pose {
  _Pose(this.lm);
  final Map<int, Landmark> lm;

  _P _mid(int a, int b) => (x: (lm[a]!.x + lm[b]!.x) / 2, y: (lm[a]!.y + lm[b]!.y) / 2);
  double _vis(List<int> idx) =>
      idx.map((i) => lm[i]!.visibility).reduce((s, v) => s + v) / idx.length;

  _P get shoulders => _mid(Lm.leftShoulder, Lm.rightShoulder);
  _P get hips => _mid(Lm.leftHip, Lm.rightHip);
  _P get hands => _mid(Lm.leftWrist, Lm.rightWrist);
  Landmark get leftHip => lm[Lm.leftHip]!;
  Landmark get rightHip => lm[Lm.rightHip]!;
  double get stance => (lm[Lm.leftAnkle]!.x - lm[Lm.rightAnkle]!.x).abs();
  double get shoulderWidth => (lm[Lm.leftShoulder]!.x - lm[Lm.rightShoulder]!.x).abs();

  double get torso {
    final dx = shoulders.x - hips.x, dy = shoulders.y - hips.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Visibility-weighted mean of nose and ears (one ear is often hidden).
  _P get head {
    var x = 0.0, y = 0.0, w = 0.0;
    for (final i in const [Lm.nose, Lm.leftEar, Lm.rightEar]) {
      final p = lm[i]!;
      final wi = math.max(p.visibility, 0.01);
      x += p.x * wi;
      y += p.y * wi;
      w += wi;
    }
    return (x: x / w, y: y / w);
  }

  double get headVis => math.max(
      lm[Lm.nose]!.visibility, math.max(lm[Lm.leftEar]!.visibility, lm[Lm.rightEar]!.visibility));

  double get trunkVis =>
      _vis(const [Lm.leftShoulder, Lm.rightShoulder, Lm.leftHip, Lm.rightHip]);

  /// Forward bend of the trunk in degrees (0 = upright), seen from DTL.
  /// [facing] is +1 when the golfer faces +x.
  double bend(double facing) {
    final dx = (shoulders.x - hips.x) * facing, dy = hips.y - shoulders.y;
    return math.atan2(dx, dy) * 180 / math.pi;
  }
}
