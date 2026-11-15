import 'dart:convert';

import 'package:analysis_core/analysis_core.dart';
import 'package:flutter/services.dart';

import '../domain/enums.dart';

/// DATABASE_SCHEMA §7 IssueGuide: bundled, versioned, per locale.
class IssueGuide {
  IssueGuide.fromJson(Map<String, Object?> j, {required this.contentVersion})
      : issue = IssueId.byWire(j['issue_id']! as String)!,
        title = j['title']! as String,
        whatWeSee = j['what_we_see']! as String,
        whyItMatters = j['why_it_matters']! as String,
        oneThingToTry = j['one_thing_to_try']! as String,
        feel = j['feel']! as String,
        selfCheck = j['self_check']! as String,
        commonMistakes = (j['common_mistakes']! as List).cast<String>(),
        correctionDifficulty = j['correction_difficulty']! as int,
        preferredCameraAngle = j['preferred_camera_angle'] == null
            ? null
            : wireValue(CameraAngle.values, j['preferred_camera_angle']! as String),
        applicableClubTypes = [
          for (final c in j['applicable_club_types']! as List)
            wireValue(ClubType.values, c as String),
        ],
        editorialPriority = j['editorial_priority']! as int,
        drillIds = (j['drill_ids']! as List).cast<String>(),
        reviewedBy = j['reviewed_by'] as String?;

  final IssueId issue;
  final String contentVersion;
  final String title, whatWeSee, whyItMatters, oneThingToTry, feel, selfCheck;
  final List<String> commonMistakes;
  final int correctionDifficulty;
  final CameraAngle? preferredCameraAngle;
  final List<ClubType> applicableClubTypes;
  final int editorialPriority;
  final List<String> drillIds;
  final String? reviewedBy;

  /// Not yet approved by a coach: the UI must label it as a draft.
  bool get isDraft => reviewedBy == null;
}

class GuideRepository {
  GuideRepository([AssetBundle? bundle]) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  final _cache = <String, Future<Map<IssueId, IssueGuide>>>{};

  static const languages = ['vi', 'en', 'ko'];

  /// Guides for a language code (`vi`, `en`, `ko`); unknown codes fall back
  /// to English.
  Future<Map<IssueId, IssueGuide>> guides(String languageCode) {
    final lang = languages.contains(languageCode) ? languageCode : 'en';
    return _cache[lang] ??= _load(lang);
  }

  Future<Map<IssueId, IssueGuide>> _load(String lang) async {
    final j = jsonDecode(await _bundle.loadString('assets/content/issue_guides_$lang.json'))
        as Map<String, Object?>;
    final version = j['content_version']! as String;
    final out = <IssueId, IssueGuide>{};
    for (final g in j['guides']! as List) {
      final guide = IssueGuide.fromJson((g as Map).cast(), contentVersion: version);
      out[guide.issue] = guide;
    }
    return out;
  }

  /// Editorial order is the same in every locale (checked by tests).
  Future<Map<IssueId, int>> editorialPriority() async =>
      (await guides('en')).map((k, g) => MapEntry(k, g.editorialPriority));
}
