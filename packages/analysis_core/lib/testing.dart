/// Test fixtures shared by package and app tests. Not used by app code.
library;

import 'dart:math' as math;

import 'analysis_core.dart';

/// Builds a synthetic right-handed swing with known timing (ms):
/// still until [takeaway], backswing to [top], pause to [topEnd],
/// downswing to [impact], follow-through to [finish], then still.
///
/// Body faults, all in normalized frame units and reached by impact (or by
/// the top for [shoulderShiftAtTop]):
/// - [headRise]: head moves up.
/// - [hipShift]: hips move along +x (toward the ball in DTL, toward the
///   target face-on).
/// - [shoulderShiftAtTop]: shoulders move along -x (DTL: the trunk stands up).
KeypointSequence syntheticSwing({
  double fps = 60,
  int takeaway = 1000,
  int top = 1900,
  int topEnd = 2000,
  int impact = 2270,
  int finish = 2770,
  int end = 3800,
  int startAt = 0,
  double visibility = 0.9,
  CameraAngle angle = CameraAngle.faceOn,
  double headRise = 0,
  double hipShift = 0,
  double shoulderShiftAtTop = 0,
}) {
  double smooth(double a) => a * a * (3 - 2 * a);
  double lerp(double a, double b, double k) => a + (b - a) * k;
  ({double x, double y}) hands(int t) {
    if (t < takeaway) return (x: 0.5, y: 0.62);
    if (t < top) {
      final k = smooth((t - takeaway) / (top - takeaway));
      return (x: lerp(0.5, 0.62, k), y: lerp(0.62, 0.25, k));
    }
    if (t < topEnd) return (x: 0.62, y: 0.25);
    if (t < impact) {
      final k = math.pow((t - topEnd) / (impact - topEnd), 2).toDouble();
      return (x: lerp(0.62, 0.5, k), y: lerp(0.25, 0.64, k));
    }
    if (t < finish) {
      final a = (t - impact) / (finish - impact);
      final k = 1 - (1 - a) * (1 - a);
      return (x: lerp(0.5, 0.38, k), y: lerp(0.64, 0.22, k));
    }
    return (x: 0.38, y: 0.22);
  }

  double ramp(int t, int to) =>
      t <= takeaway ? 0 : (t >= to ? 1 : (t - takeaway) / (to - takeaway));

  final faceOn = angle == CameraAngle.faceOn;
  // Face-on: shoulders and feet look wide. DTL: they overlap, the trunk leans
  // toward the ball (+x) and the hips sit behind the hands.
  const shoulderX = 0.5;
  final shoulderHalf = faceOn ? 0.12 : 0.01;
  final hipX = faceOn ? 0.5 : 0.44, hipHalf = faceOn ? 0.06 : 0.01;
  final ankleHalf = faceOn ? 0.1 : 0.01;

  final frames = <PoseFrame>[];
  for (var i = 0;; i++) {
    final t = startAt + (i * 1000 / fps).round();
    if (t > end) break;
    final h = hands(t);
    final toImpact = ramp(t, impact), toTop = ramp(t, top);
    final head = headRise * toImpact;
    final hips = hipX + hipShift * toImpact;
    final sh = shoulderX - shoulderShiftAtTop * toTop;
    final pts = List.generate(Lm.count, (_) => Landmark(0.5, 0.5, visibility));
    void set(int idx, double x, double y) => pts[idx] = Landmark(x, y, visibility);
    set(Lm.nose, sh, 0.2 - head);
    set(Lm.leftEar, sh + 0.01, 0.19 - head);
    set(Lm.rightEar, sh - 0.01, 0.19 - head);
    set(Lm.leftShoulder, sh + shoulderHalf, 0.32);
    set(Lm.rightShoulder, sh - shoulderHalf, 0.32);
    set(Lm.leftHip, hips + hipHalf, 0.55);
    set(Lm.rightHip, hips - hipHalf, 0.55);
    set(Lm.leftAnkle, hipX + ankleHalf, 0.9);
    set(Lm.rightAnkle, hipX - ankleHalf, 0.9);
    set(Lm.leftWrist, h.x + 0.01, h.y);
    set(Lm.rightWrist, h.x - 0.01, h.y);
    frames.add(PoseFrame(t, pts));
  }
  return KeypointSequence(
      fps: fps, width: 720, height: 1280, model: 'synthetic', frames: frames);
}
