import 'dart:math' as math;

import 'keypoints.dart';
import 'signals.dart';
import 'types.dart';

/// Result of phase + tempo detection for one swing clip.
class SwingTiming {
  const SwingTiming(this.phases, this.tempo);

  /// Only phases that could be located; missing ones mean "not enough data".
  final List<PhaseMark> phases;
  final Tempo? tempo;

  PhaseMark? operator [](SwingPhase p) {
    for (final m in phases) {
      if (m.phase == p) return m;
    }
    return null;
  }
}

/// Locates the 8 swing phases from the hand trajectory (AI_ANALYSIS_SPEC §6,
/// §12). Works on face-on and down-the-line clips of a right-handed golfer
/// (mirror left-handers first). Hand height is the main signal:
///
/// - impact region = fastest hand movement in the clip;
/// - top = highest hands before that;
/// - impact = lowest hands between top and shortly after peak speed;
/// - takeaway = end of the still address period before the top;
/// - finish = hands come to rest (or highest point) after impact;
/// - backswing / downswing / follow-through = midway hand height between
///   their neighbouring marks.
///
/// The plausibility bounds below reject clips that are not a full swing;
/// they are signal-processing limits, not swing-fault thresholds.
class PhaseDetector {
  const PhaseDetector();

  /// Fraction of peak hand speed below which hands count as still.
  static const stillFraction = 0.08;
  static const minStillMs = 150;
  static const searchBeforeTopMs = 3000;
  static const backswingRangeMs = (300, 2500);
  static const downswingRangeMs = (100, 900);

  SwingTiming? detect(KeypointSequence seq) {
    final s = HandSignal.from(seq);
    if (s == null) return null;
    final n = s.length;

    final peak = _argMax(s.speed, 0, n - 1);
    final peakSpeed = s.speed[peak];
    if (peakSpeed <= 0) return null;
    final still = peakSpeed * stillFraction;

    final top = _argMin(s.y, s.indexAt(s.t[peak] - searchBeforeTopMs), peak);
    final impactEnd = s.indexAt(s.t[peak] + 250);
    final impact = _argMax(s.y, top, impactEnd);
    if (impact <= top) return null;

    final backStill = _stillRunBefore(s, top, still);
    final takeaway = backStill == null ? null : backStill.end + 1;
    final finish = _finishAfter(s, impact, still);

    final downMs = s.t[impact] - s.t[top];
    if (downMs < downswingRangeMs.$1 || downMs > downswingRangeMs.$2) return null;
    if (takeaway != null) {
      final backMs = s.t[top] - s.t[takeaway];
      if (backMs < backswingRangeMs.$1 || backMs > backswingRangeMs.$2) return null;
    }

    final marks = <PhaseMark>[];
    void mark(SwingPhase p, int? i, {bool timingCritical = true}) {
      if (i == null) return;
      marks.add(PhaseMark(p, s.t[i], _confidence(s, seq.fps, i, timingCritical)));
    }

    if (takeaway != null) {
      mark(SwingPhase.address,
          math.max(backStill!.start, s.indexAt(s.t[takeaway] - 300)),
          timingCritical: false);
      mark(SwingPhase.takeaway, takeaway);
      mark(SwingPhase.backswing, _crossing(s.y, takeaway, top, (s.y[takeaway] + s.y[top]) / 2));
    }
    mark(SwingPhase.top, top);
    mark(SwingPhase.downswing, _crossing(s.y, top, impact, (s.y[top] + s.y[impact]) / 2));
    mark(SwingPhase.impact, impact);
    if (finish != null) {
      mark(SwingPhase.followThrough,
          _crossing(s.y, impact, finish, (s.y[impact] + s.y[finish]) / 2));
      mark(SwingPhase.finish, finish, timingCritical: false);
    }
    marks.sort((a, b) => a.phase.index.compareTo(b.phase.index));

    return SwingTiming(marks, _tempo(s, seq.fps, takeaway, top, impact, still));
  }

  Tempo? _tempo(HandSignal s, double fps, int? takeaway, int top, int impact, double still) {
    if (takeaway == null) return null;
    // Pause at the top: contiguous slow frames around the top.
    final slow = still * 2;
    var a = top, b = top;
    while (a > takeaway && s.speed[a - 1] < slow) {
      a--;
    }
    while (b < impact && s.speed[b + 1] < slow) {
      b++;
    }
    var conf = _confidence(s, fps, takeaway, true)
        .min(_confidence(s, fps, top, true))
        .min(_confidence(s, fps, impact, true));
    return Tempo(
      backswingMs: s.t[top] - s.t[takeaway],
      topPauseMs: s.t[b] - s.t[a],
      downswingMs: s.t[impact] - s.t[top],
      confidence: conf,
    );
  }

  /// Visibility and frame rate decide how much a timestamp can be trusted
  /// (AI_ANALYSIS_SPEC §14: low FPS lowers confidence of phases and tempo).
  Confidence _confidence(HandSignal s, double fps, int i, bool timingCritical) {
    final v = s.visibilityAround(i);
    var c = v >= 0.7 ? Confidence.high : (v >= 0.5 ? Confidence.medium : Confidence.low);
    if (timingCritical) {
      if (fps < 25) {
        c = c.min(Confidence.low);
      } else if (fps < 50) {
        c = c.min(Confidence.medium);
      }
    }
    return c;
  }

  /// Last run of still frames (≥ [minStillMs]) within the search window
  /// before [top].
  ({int start, int end})? _stillRunBefore(HandSignal s, int top, double still) {
    final from = s.indexAt(s.t[top] - searchBeforeTopMs);
    int? end;
    for (var i = top - 1; i >= from; i--) {
      if (s.speed[i] < still) {
        end ??= i;
      } else if (end != null) {
        if (s.t[end] - s.t[i + 1] >= minStillMs) return (start: i + 1, end: end);
        end = null;
      }
    }
    if (end != null && s.t[end] - s.t[from] >= minStillMs) return (start: from, end: end);
    return null;
  }

  int? _finishAfter(HandSignal s, int impact, double still) {
    final limit = s.indexAt(s.t[impact] + 2500);
    final from = s.indexAt(s.t[impact] + 200);
    int? runStart;
    for (var i = from; i <= limit; i++) {
      if (s.speed[i] < still) {
        runStart ??= i;
        if (s.t[i] - s.t[runStart] >= minStillMs) return runStart;
      } else {
        runStart = null;
      }
    }
    // No rest found: use the highest hands after impact if the clip covers it.
    if (s.t.last - s.t[impact] < 400) return null;
    return _argMin(s.y, from, limit);
  }

  static int? _crossing(List<double> y, int from, int to, double level) {
    for (var i = from; i < to; i++) {
      if ((y[i] - level) * (y[i + 1] - level) <= 0) {
        return (y[i] - level).abs() <= (y[i + 1] - level).abs() ? i : i + 1;
      }
    }
    return null;
  }

  static int _argMax(List<double> v, int from, int to) {
    var best = from;
    for (var i = from; i <= to; i++) {
      if (v[i] > v[best]) best = i;
    }
    return best;
  }

  static int _argMin(List<double> v, int from, int to) {
    var best = from;
    for (var i = from; i <= to; i++) {
      if (v[i] < v[best]) best = i;
    }
    return best;
  }
}
