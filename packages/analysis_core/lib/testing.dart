/// Test fixtures shared by package and app tests. Not used by app code.
library;

import 'dart:math' as math;

import 'analysis_core.dart';

/// Builds a synthetic face-on swing with known timing (ms):
/// still until [takeaway], backswing to [top], pause to [topEnd],
/// downswing to [impact], follow-through to [finish], then still.
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
}) {
  double smooth(double a) => a * a * (3 - 2 * a);
  ({double x, double y}) hands(int t) {
    double lerp(double a, double b, double k) => a + (b - a) * k;
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

  final frames = <PoseFrame>[];
  for (var i = 0;; i++) {
    final t = startAt + (i * 1000 / fps).round();
    if (t > end) break;
    final h = hands(t);
    final pts = List.generate(Lm.count, (_) => Landmark(0.5, 0.5, visibility));
    void set(int idx, double x, double y) => pts[idx] = Landmark(x, y, visibility);
    set(Lm.nose, 0.5, 0.2);
    set(Lm.leftShoulder, 0.56, 0.32);
    set(Lm.rightShoulder, 0.44, 0.32);
    set(Lm.leftHip, 0.54, 0.55);
    set(Lm.rightHip, 0.46, 0.55);
    set(Lm.leftWrist, h.x + 0.01, h.y);
    set(Lm.rightWrist, h.x - 0.01, h.y);
    frames.add(PoseFrame(t, pts));
  }
  return KeypointSequence(
      fps: fps, width: 720, height: 1280, model: 'synthetic', frames: frames);
}
