import 'dart:math' as math;

import 'keypoints.dart';

/// Smoothed per-frame hand signal used by phase and tempo detection.
///
/// Hands = midpoint of both wrists. Speed is in torso lengths (per frame) so
/// it does not depend on how far the golfer stands from the camera.
class HandSignal {
  HandSignal._(this.t, this.x, this.y, this.speed, this.visibility, this.torso, this.scale);

  /// Frame timestamps (ms).
  final List<int> t;

  /// Hand position in normalized image units (y grows downward).
  final List<double> x, y;

  /// Hand speed in torso lengths per second.
  final List<double> speed;

  /// Mean wrist visibility per frame (0 where interpolated).
  final List<double> visibility;
  final double torso;

  /// Smoothed torso length per frame (normalized image units).
  final List<double> scale;

  int get length => t.length;

  /// Best-wrist visibility below this is treated as missing. Fast hands are
  /// motion-blurred, so MediaPipe reports low visibility mid-swing even when
  /// the position is usable.
  static const minVisibility = 0.15;

  /// Gaps up to this long are interpolated; longer gaps fail the analysis.
  static const maxGapMs = 250;

  /// Returns null when there are too few usable frames.
  static HandSignal? from(KeypointSequence seq) {
    final frames = seq.frames;
    if (frames.length < 10) return null;
    final n = frames.length;
    final xs = List<double?>.filled(n, null), ys = List<double?>.filled(n, null);
    final vis = List<double>.filled(n, 0);
    final torsoAt = List<double?>.filled(n, null);
    final torsos = <double>[];
    for (var i = 0; i < n; i++) {
      final p = frames[i].points;
      if (p == null) continue;
      // Both hands hold the grip, so one wrist is usually hidden behind the
      // other: weight by visibility and trust the clearer wrist.
      final l = p[Lm.leftWrist], r = p[Lm.rightWrist];
      final v = math.max(l.visibility, r.visibility);
      if (v < minVisibility) continue;
      final wl = math.max(l.visibility, 0.01), wr = math.max(r.visibility, 0.01);
      xs[i] = (l.x * wl + r.x * wr) / (wl + wr);
      ys[i] = (l.y * wl + r.y * wr) / (wl + wr);
      vis[i] = v;
      final sh = _mid(p[Lm.leftShoulder], p[Lm.rightShoulder]);
      final hp = _mid(p[Lm.leftHip], p[Lm.rightHip]);
      final len = _dist(sh, hp, seq.width / math.max(seq.height, 1));
      torsos.add(len);
      if (len > 0) torsoAt[i] = len;
    }
    if (torsos.length < n * 0.6) return null;
    torsos.sort();
    final torso = torsos[torsos.length ~/ 2];
    if (torso <= 0) return null;

    final t = [for (final f in frames) f.timestampMs];
    final fx = _fillGaps(xs, t), fy = _fillGaps(ys, t), ft = _fillGaps(torsoAt, t);
    if (fx == null || fy == null || ft == null) return null;
    final win = math.max(1, (seq.fps * 0.05).round());
    final sx = _smooth(fx, win), sy = _smooth(fy, win);
    // Speed is scaled by each frame's own torso length: golfers often walk
    // up to the phone before and after the swing, and a body twice as large
    // in the frame would otherwise look twice as fast. Torso length changes
    // slowly, so a wide window keeps pose jitter out of the scale.
    final scale = _smooth(ft, math.max(1, (seq.fps * 0.25).round()));

    final aspect = seq.width / math.max(seq.height, 1);
    final speed = List<double>.filled(n, 0);
    for (var i = 1; i < n - 1; i++) {
      final dt = (t[i + 1] - t[i - 1]) / 1000;
      if (dt <= 0) continue;
      final dx = (sx[i + 1] - sx[i - 1]) * aspect, dy = sy[i + 1] - sy[i - 1];
      speed[i] = math.sqrt(dx * dx + dy * dy) / dt / scale[i];
    }
    speed[0] = speed[1];
    speed[n - 1] = speed[n - 2];
    return HandSignal._(t, sx, sy, speed, vis, torso, scale);
  }

  /// Linear interpolation over short gaps; leading/trailing gaps are
  /// extended from the nearest value.
  static List<double>? _fillGaps(List<double?> v, List<int> t) {
    final first = v.indexWhere((e) => e != null);
    if (first < 0) return null;
    final out = List<double>.filled(v.length, 0);
    var last = first;
    for (var i = 0; i < v.length; i++) {
      if (v[i] != null) {
        if (i - last > 1) {
          if (t[i] - t[last] > maxGapMs) return null;
          for (var k = last + 1; k < i; k++) {
            final a = (t[k] - t[last]) / (t[i] - t[last]);
            out[k] = v[last]! + (v[i]! - v[last]!) * a;
          }
        }
        out[i] = v[i]!;
        last = i;
      } else if (i < first) {
        out[i] = v[first]!;
      } else {
        out[i] = v[last]!;
      }
    }
    return out;
  }

  static List<double> _smooth(List<double> v, int half) => [
        for (var i = 0; i < v.length; i++)
          () {
            var s = 0.0, c = 0;
            for (var k = math.max(0, i - half); k <= math.min(v.length - 1, i + half); k++) {
              s += v[k];
              c++;
            }
            return s / c;
          }(),
      ];

  static ({double x, double y}) _mid(Landmark a, Landmark b) =>
      (x: (a.x + b.x) / 2, y: (a.y + b.y) / 2);

  static double _dist(({double x, double y}) a, ({double x, double y}) b, double aspect) {
    final dx = (a.x - b.x) * aspect, dy = a.y - b.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Index of the frame nearest [ms].
  int indexAt(int ms) {
    var best = 0;
    for (var i = 1; i < t.length; i++) {
      if ((t[i] - ms).abs() < (t[best] - ms).abs()) best = i;
    }
    return best;
  }

  /// Mean visibility over ±[radius] frames around [i].
  double visibilityAround(int i, [int radius = 2]) {
    var s = 0.0, c = 0;
    for (var k = math.max(0, i - radius); k <= math.min(length - 1, i + radius); k++) {
      s += visibility[k];
      c++;
    }
    return c == 0 ? 0 : s / c;
  }
}
