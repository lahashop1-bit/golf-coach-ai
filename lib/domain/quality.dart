import 'enums.dart';

/// Result of the Phase 1 quality check (no pose; docs/GOLF_FEATURES.md §2.4).
class QualityResult {
  const QualityResult(this.level, this.issues);

  final QualityLevel level;
  final List<QualityIssue> issues;
}

/// Basic checks that need only file metadata.
///
/// Brightness and shake need frame sampling and are not checked yet.
/// Thresholds are provisional and will be tuned on the test video set.
class QualityRules {
  const QualityRules();

  /// A full swing from address to finish takes well over one second.
  static const minDurationMs = 1000;

  /// 29.97 fps clips must pass; below ~30 fps tempo/phase timing gets coarse.
  static const minFps = 29.0;

  QualityResult check({required int durationMs, required double fps}) {
    final issues = <QualityIssue>[
      if (durationMs < minDurationMs) QualityIssue.tooShort,
      if (fps > 0 && fps < minFps) QualityIssue.lowFps,
    ];
    final level = issues.contains(QualityIssue.tooShort)
        ? QualityLevel.poor
        : issues.isEmpty
            ? QualityLevel.good
            : QualityLevel.fair;
    return QualityResult(level, issues);
  }
}
