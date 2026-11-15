import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/db/database.dart';
import '../../domain/enums.dart';
import '../../widgets/common.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final profile = ref.watch(profileProvider).value;
    final repo = ref.read(profileRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: profile == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(Gap.m),
              children: [
                ChoiceGroup<String?>(
                  label: l.languageLabel,
                  values: const [null, ...localePreferences],
                  selected: profile.preferredLocale,
                  labelOf: (v) => v == null ? l.languageSystem : localeDisplayName(v),
                  onSelected: (v) => repo.update(
                      profile.id, UserProfilesCompanion(preferredLocale: Value(v))),
                ),
                ChoiceGroup<Handedness>(
                  label: l.handednessLabel,
                  values: Handedness.values,
                  selected: profile.handedness,
                  labelOf: (v) => v.label(l),
                  onSelected: (v) => repo.update(
                      profile.id, UserProfilesCompanion(handedness: Value(v))),
                ),
                ChoiceGroup<SkillLevel>(
                  label: l.onboardingSkill,
                  values: SkillLevel.values,
                  selected: profile.skillLevel,
                  labelOf: (v) => v.label(l),
                  onSelected: (v) => repo.update(profile.id,
                      UserProfilesCompanion(skillLevel: Value(v))),
                ),
                const Divider(height: Gap.l * 2),
                Text(l.privacyLabel, style: theme.textTheme.titleMedium),
                const SizedBox(height: Gap.s),
                Text(l.privacyLocalOnly),
                const SizedBox(height: Gap.m),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error),
                  icon: const Icon(Icons.delete_forever_outlined),
                  label: Text(l.deleteAllData),
                  onPressed: () async {
                    if (await confirmDelete(context,
                        title: l.deleteAllTitle, body: l.deleteAllBody)) {
                      await repo.deleteAllData();
                      // Router redirects to onboarding when the profile is gone.
                    }
                  },
                ),
              ],
            ),
    );
  }
}
