/// An enum with a stable snake_case wire value (docs/DATABASE_SCHEMA.md §0).
mixin WireEnum on Enum {
  String get wire;
}

T wireValue<T extends WireEnum>(List<T> values, String wire) =>
    values.firstWhere((v) => v.wire == wire,
        orElse: () => throw ArgumentError('Unknown $T value: $wire'));

enum SwingPhase with WireEnum {
  address('address'),
  takeaway('takeaway'),
  backswing('backswing'),
  top('top'),
  downswing('downswing'),
  impact('impact'),
  followThrough('follow_through'),
  finish('finish');

  const SwingPhase(this.wire);
  @override
  final String wire;
}

enum Confidence with WireEnum {
  low('low'),
  medium('medium'),
  high('high');

  const Confidence(this.wire);
  @override
  final String wire;

  Confidence min(Confidence other) => index <= other.index ? this : other;
}

enum CameraAngle with WireEnum {
  faceOn('face_on'),
  downTheLine('down_the_line');

  const CameraAngle(this.wire);
  @override
  final String wire;
}

/// AI_ANALYSIS_SPEC §5. Severity order: review > attention > ok.
/// `insufficientData` is never stored on an observation.
enum Level with WireEnum {
  ok('ok'),
  attention('attention'),
  review('review'),
  insufficientData('insufficient_data');

  const Level(this.wire);
  @override
  final String wire;
}

class PhaseMark {
  const PhaseMark(this.phase, this.timestampMs, this.confidence,
      {this.userAdjusted = false});

  final SwingPhase phase;
  final int timestampMs;
  final Confidence confidence;
  final bool userAdjusted;

  Map<String, Object> toJson() => {
        'phase': phase.wire,
        'timestamp_ms': timestampMs,
        'confidence': confidence.wire,
        'user_adjusted': userAdjusted,
      };

  factory PhaseMark.fromJson(Map<String, Object?> j) => PhaseMark(
        wireValue(SwingPhase.values, j['phase']! as String),
        j['timestamp_ms']! as int,
        wireValue(Confidence.values, j['confidence']! as String),
        userAdjusted: j['user_adjusted'] as bool? ?? false,
      );
}

/// AI_ANALYSIS_SPEC §12. Durations are estimates from video.
class Tempo {
  const Tempo({
    required this.backswingMs,
    required this.topPauseMs,
    required this.downswingMs,
    required this.confidence,
  });

  final int backswingMs;
  final int topPauseMs;
  final int downswingMs;
  final Confidence confidence;

  double get ratio => downswingMs == 0 ? 0 : backswingMs / downswingMs;

  Map<String, Object> toJson() => {
        'backswing_ms': backswingMs,
        'top_pause_ms': topPauseMs,
        'downswing_ms': downswingMs,
        'ratio': double.parse(ratio.toStringAsFixed(2)),
        'confidence': confidence.wire,
      };

  factory Tempo.fromJson(Map<String, Object?> j) => Tempo(
        backswingMs: j['backswing_ms']! as int,
        topPauseMs: j['top_pause_ms']! as int,
        downswingMs: j['downswing_ms']! as int,
        confidence: wireValue(Confidence.values, j['confidence']! as String),
      );
}
