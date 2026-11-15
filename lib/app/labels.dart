import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../data/db/database.dart';
import '../domain/enums.dart';
import '../l10n/gen/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Maps a stored `preferredLocale` (DATABASE_SCHEMA §2) to a Flutter locale.
Locale? localeFromPreference(String? pref) => switch (pref) {
      'vi-VN' => const Locale('vi'),
      'en' => const Locale('en'),
      'ko-KR' => const Locale('ko'),
      _ => null,
    };

const localePreferences = ['vi-VN', 'en', 'ko-KR'];

/// Language names are shown in their own language on purpose.
String localeDisplayName(String pref) => switch (pref) {
      'vi-VN' => 'Tiếng Việt',
      'ko-KR' => '한국어',
      _ => 'English',
    };

extension HandednessLabel on Handedness {
  String label(AppLocalizations l) =>
      this == Handedness.right ? l.handednessRight : l.handednessLeft;
}

extension SkillLabel on SkillLevel {
  String label(AppLocalizations l) => switch (this) {
        SkillLevel.beginner => l.skillBeginner,
        SkillLevel.basic => l.skillBasic,
        SkillLevel.intermediate => l.skillIntermediate,
        SkillLevel.advanced => l.skillAdvanced,
      };
}

extension AngleLabel on CameraAngle {
  String shortLabel(AppLocalizations l) =>
      this == CameraAngle.faceOn ? l.angleFaceOn : l.angleDtl;
  String fullLabel(AppLocalizations l) =>
      this == CameraAngle.faceOn ? l.angleFaceOnFull : l.angleDtlFull;
}

extension ClubLabel on ClubType {
  String label(AppLocalizations l) => switch (this) {
        ClubType.driver => l.clubDriver,
        ClubType.wood => l.clubWood,
        ClubType.hybrid => l.clubHybrid,
        ClubType.iron => l.clubIron,
        ClubType.wedge => l.clubWedge,
        ClubType.putter => l.clubPutter,
        ClubType.none => l.clubNone,
      };
}

String clubText(AppLocalizations l, ClubType? type, int? number) {
  if (type == null) return '';
  if (number == null || !type.hasNumber) return type.label(l);
  return l.clubWithNumber(type.label(l), number);
}

extension SubjectLabel on Subject {
  String label(AppLocalizations l) =>
      this == Subject.self ? l.subjectSelf : l.subjectOther;
}

/// "Gậy sắt số 7 · Chính diện"
String sessionSummary(AppLocalizations l, SwingSession s) => [
      clubText(l, s.clubType, s.clubNumber),
      s.cameraAngle.shortLabel(l),
    ].where((e) => e.isNotEmpty).join(' · ');

String formatDateTime(BuildContext context, DateTime utc) {
  return DateFormat.yMMMd(_lang(context)).add_Hm().format(utc.toLocal());
}

String _lang(BuildContext context) => Localizations.localeOf(context).toLanguageTag();

/// Frame rate with at most one decimal, locale separator: 60, 29,97 → "30".
/// Native nominal rates are often 59.99…, which must read as 60.
String formatFps(BuildContext context, double fps) =>
    NumberFormat('0.#', _lang(context)).format(fps);

/// Seconds with the locale separator ("3,0" in vi). Tempo uses 2 decimals:
/// a downswing lasts only ~0.3 s.
String formatSeconds(BuildContext context, int ms, {int decimals = 1}) =>
    NumberFormat('0.${'0' * decimals}', _lang(context)).format(ms / 1000);

extension PhaseLabel on SwingPhase {
  /// Short labels from the glossary ("Nhãn ngắn trên giao diện").
  String label(AppLocalizations l) => switch (this) {
        SwingPhase.address => l.phaseAddress,
        SwingPhase.takeaway => l.phaseTakeaway,
        SwingPhase.backswing => l.phaseBackswing,
        SwingPhase.top => l.phaseTop,
        SwingPhase.downswing => l.phaseDownswing,
        SwingPhase.impact => l.phaseImpact,
        SwingPhase.followThrough => l.phaseFollowThrough,
        SwingPhase.finish => l.phaseFinish,
      };
}

/// `analysis.limit.*` keys → text (I18N_L10N_SPEC §8). Unknown keys are
/// skipped rather than shown raw.
String? limitationText(AppLocalizations l, String key) => switch (key) {
      'analysis.limit.single_2d_view' => l.limitSingle2dView,
      'analysis.limit.low_fps' => l.limitLowFps,
      'analysis.limit.angle_mismatch' => l.limitAngleMismatch,
      _ => null,
    };

extension LevelLabel on Level {
  String label(AppLocalizations l) => switch (this) {
        Level.ok => l.levelOk,
        Level.attention => l.levelAttention,
        Level.review => l.levelReview,
        Level.insufficientData => l.levelInsufficientData,
      };
}

/// IssueGuide.correctionDifficulty (1–3, set by the editor).
String difficultyLabel(AppLocalizations l, int d) => switch (d) {
      1 => l.difficultyEasy,
      2 => l.difficultyMedium,
      _ => l.difficultyHard,
    };
