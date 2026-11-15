// Canonical enums. Wire values (DB/JSON) follow docs/DATABASE_SCHEMA.md §1
// and must never be renamed once released.

import 'package:analysis_core/analysis_core.dart';

export 'package:analysis_core/analysis_core.dart'
    show CameraAngle, Confidence, Level, SwingPhase, WireEnum, wireValue;

enum Handedness with WireEnum {
  right('right'),
  left('left');

  const Handedness(this.wire);
  @override
  final String wire;
}

enum SkillLevel with WireEnum {
  beginner('beginner'),
  basic('basic'),
  intermediate('intermediate'),
  advanced('advanced');

  const SkillLevel(this.wire);
  @override
  final String wire;
}

enum ClubType with WireEnum {
  driver('driver'),
  wood('wood'),
  hybrid('hybrid'),
  iron('iron'),
  wedge('wedge'),
  putter('putter'),
  none('none');

  const ClubType(this.wire);
  @override
  final String wire;

  /// Club types that take a number (e.g. iron + 7).
  bool get hasNumber => this == iron || this == wood || this == hybrid;
}

enum SessionMode with WireEnum {
  guidedAnalysis('guided_analysis'),
  selfRecord('self_record');

  const SessionMode(this.wire);
  @override
  final String wire;
}

enum Subject with WireEnum {
  self('self'),
  other('other');

  const Subject(this.wire);
  @override
  final String wire;
}

enum Source with WireEnum {
  recorded('recorded'),
  imported('imported');

  const Source(this.wire);
  @override
  final String wire;
}

enum AppPlatform with WireEnum {
  ios('ios'),
  android('android');

  const AppPlatform(this.wire);
  @override
  final String wire;
}

enum QualityLevel with WireEnum {
  poor('poor'),
  fair('fair'),
  good('good');

  const QualityLevel(this.wire);
  @override
  final String wire;
}

enum QualityIssue with WireEnum {
  tooDark('too_dark'),
  notFullBody('not_full_body'),
  shaky('shaky'),
  occluded('occluded'),
  tooShort('too_short'),
  lowFps('low_fps');

  const QualityIssue(this.wire);
  @override
  final String wire;
}

enum FeedbackTiming with WireEnum {
  afterEach('after_each'),
  endOfSession('end_of_session');

  const FeedbackTiming(this.wire);
  @override
  final String wire;
}

enum SessionStatus with WireEnum {
  draft('draft'),
  recording('recording'),
  review('review'),
  completed('completed'),
  cancelled('cancelled');

  const SessionStatus(this.wire);
  @override
  final String wire;
}

enum FeedbackValue with WireEnum {
  helpful('helpful'),
  unclear('unclear'),
  notRelevant('not_relevant');

  const FeedbackValue(this.wire);
  @override
  final String wire;
}

enum AnalysisStatus with WireEnum {
  queued('queued'),
  processing('processing'),
  completed('completed'),
  insufficientQuality('insufficient_quality'),
  failed('failed'),
  cancelled('cancelled');

  const AnalysisStatus(this.wire);
  @override
  final String wire;
}
