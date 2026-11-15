import 'package:analysis_core/analysis_core.dart' show IssueId;
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/data/guide_repository.dart';

/// The bundled IssueGuide files (DATABASE_SCHEMA §7) must cover every rule in
/// every locale and agree on the locale-independent fields.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repo = GuideRepository();

  test('every locale has a complete guide for every group-A issue', () async {
    for (final lang in GuideRepository.languages) {
      final guides = await repo.guides(lang);
      expect(guides.keys.toSet(), IssueId.values.toSet(), reason: lang);
      for (final g in guides.values) {
        for (final text in [
          g.title, g.whatWeSee, g.whyItMatters, g.oneThingToTry, g.feel, g.selfCheck,
          ...g.commonMistakes,
        ]) {
          expect(text.trim(), isNotEmpty, reason: '$lang ${g.issue}');
        }
        expect(g.correctionDifficulty, inInclusiveRange(1, 3));
        // Drafts until a coach signs off (AI_ANALYSIS_SPEC §13).
        expect(g.isDraft, isTrue);
      }
    }
  });

  test('locales agree on priority, difficulty and camera angle', () async {
    final en = await repo.guides('en');
    for (final lang in ['vi', 'ko']) {
      final other = await repo.guides(lang);
      for (final id in IssueId.values) {
        expect(other[id]!.editorialPriority, en[id]!.editorialPriority, reason: '$lang $id');
        expect(other[id]!.correctionDifficulty, en[id]!.correctionDifficulty);
        expect(other[id]!.preferredCameraAngle, en[id]!.preferredCameraAngle);
        expect(other[id]!.contentVersion, en[id]!.contentVersion);
      }
    }
  });

  test('preferred camera angle is one the rule can use', () async {
    for (final g in (await repo.guides('en')).values) {
      expect(g.issue.angles, contains(g.preferredCameraAngle), reason: '${g.issue}');
    }
  });

  test('unknown language falls back to English', () async {
    expect((await repo.guides('fr'))[IssueId.earlyExtension]!.title, 'Early extension');
  });
}
