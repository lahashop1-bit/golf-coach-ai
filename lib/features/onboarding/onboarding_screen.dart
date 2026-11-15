import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../domain/enums.dart';
import '../../widgets/common.dart';

/// UI_UX_SPEC §3: language, handedness, level; only handedness is required.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _locale; // null = system
  Handedness _handedness = Handedness.right;
  SkillLevel? _skill;
  bool _saving = false;

  Future<void> _start() async {
    setState(() => _saving = true);
    try {
      await ref.read(profileRepositoryProvider).create(
          handedness: _handedness, skillLevel: _skill, preferredLocale: _locale);
      // The router redirects to /home once the profile stream emits.
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Preview the chosen language immediately.
    return Localizations.override(
      context: context,
      locale: localeFromPreference(_locale),
      child: Builder(builder: (context) {
        final l = context.l10n;
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(Gap.l),
              children: [
                Text(l.onboardingTitle, style: theme.textTheme.headlineMedium),
                const SizedBox(height: Gap.s),
                Text(l.onboardingIntro, style: theme.textTheme.bodyLarge),
                const SizedBox(height: Gap.l),
                ChoiceGroup<String?>(
                  label: l.languageLabel,
                  values: const [null, ...localePreferences],
                  selected: _locale,
                  labelOf: (v) => v == null ? l.languageSystem : localeDisplayName(v),
                  onSelected: (v) => setState(() => _locale = v),
                ),
                ChoiceGroup<Handedness>(
                  label: l.onboardingHandedness,
                  values: Handedness.values,
                  selected: _handedness,
                  labelOf: (v) => v.label(l),
                  onSelected: (v) => setState(() => _handedness = v),
                ),
                ChoiceGroup<SkillLevel>(
                  label: l.onboardingSkill,
                  values: SkillLevel.values,
                  selected: _skill,
                  labelOf: (v) => v.label(l),
                  onSelected: (v) => setState(() => _skill = _skill == v ? null : v),
                ),
                const SizedBox(height: Gap.s),
                Row(children: [
                  Icon(Icons.lock_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: Gap.s),
                  Expanded(child: Text(l.privacyLocalOnly)),
                ]),
                const SizedBox(height: Gap.l),
                FilledButton(
                  onPressed: _saving ? null : _start,
                  child: Text(l.onboardingStart),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
