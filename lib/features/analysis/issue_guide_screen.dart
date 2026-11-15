import 'package:analysis_core/analysis_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/db/database.dart';
import '../../domain/enums.dart';
import '../../widgets/common.dart';
import 'issue_widgets.dart';

/// Issue explanation (UI_UX_SPEC §5.3) for one issue of one swing. The
/// "what we see" part and the feedback buttons only appear when the swing
/// has a visible observation for this issue.
class IssueGuideScreen extends ConsumerWidget {
  const IssueGuideScreen({super.key, required this.swingId, required this.issueWire});

  final String swingId;
  final String issueWire;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final issue = IssueId.byWire(issueWire);
    final lang = Localizations.localeOf(context).languageCode;
    final guides = ref.watch(issueGuidesProvider(lang));
    final guide = issue == null ? null : guides.value?[issue];
    if (guides.hasError || (guides.hasValue && guide == null)) {
      return Scaffold(appBar: AppBar(), body: const ErrorState());
    }
    if (guide == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final result = ref.watch(analysisProvider(swingId)).value;
    final o = result?.observation(issue!);
    final observation = o != null && !o.hiddenFromUser ? o : null;
    return Scaffold(
      appBar: AppBar(title: Text(guide.title)),
      body: ListView(padding: const EdgeInsets.all(Gap.m), children: [
        if (guide.isDraft)
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: ListTile(
              leading: const Icon(Icons.edit_note),
              title: Text(l.guideDraftNote),
            ),
          ),
        if (observation != null) ...[
          LevelBadge(observation.level),
          const SizedBox(height: Gap.xs),
          // "What we see" describes the fault, so it only applies when the
          // rule found signs of it.
          if (observation.level == Level.ok)
            Text(l.issueNotSeen)
          else ...[
            Text(confidenceText(context, observation.confidence)),
            Text(l.issueSeenAt(observation.phase.label(l))),
            _Section(l.guideWhatWeSee, guide.whatWeSee),
          ],
        ],
        _Section(l.guideWhyItMatters, guide.whyItMatters),
        _Section(l.guideOneThing, guide.oneThingToTry),
        _Section(l.guideFeel, guide.feel),
        _Section(l.guideSelfCheck, guide.selfCheck),
        _Section(l.guideCommonMistakes, guide.commonMistakes.map((m) => '• $m').join('\n')),
        if (guide.preferredCameraAngle != null)
          _Section(l.guidePreferredAngle, guide.preferredCameraAngle!.fullLabel(l)),
        _Section(l.guideDifficulty, difficultyLabel(l, guide.correctionDifficulty)),
        const SizedBox(height: Gap.m),
        Text(l.limitSingle2dView, style: Theme.of(context).textTheme.bodySmall),
        if (observation != null) _FeedbackBar(observation: observation),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.body);
  final String title, body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: Gap.m),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Semantics(header: true, child: Text(title, style: theme.textTheme.titleMedium)),
        const SizedBox(height: Gap.xs),
        Text(body, style: theme.textTheme.bodyLarge),
      ]),
    );
  }
}

/// "Hữu ích / Không hiểu / Không phù hợp" (DATABASE_SCHEMA §9). Stored
/// locally only.
class _FeedbackBar extends ConsumerWidget {
  const _FeedbackBar({required this.observation});
  final IssueObservation observation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final current = ref.watch(feedbackProvider(observation.id)).value;
    String label(FeedbackValue v) => switch (v) {
          FeedbackValue.helpful => l.feedbackHelpful,
          FeedbackValue.unclear => l.feedbackUnclear,
          FeedbackValue.notRelevant => l.feedbackNotRelevant,
        };
    return Padding(
      padding: const EdgeInsets.only(top: Gap.l),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.feedbackQuestion, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: Gap.s),
        Wrap(spacing: Gap.s, runSpacing: Gap.s, children: [
          for (final v in FeedbackValue.values)
            ChoiceChip(
              label: Text(label(v)),
              selected: current == v,
              onSelected: (_) =>
                  ref.read(analysisRepositoryProvider).setFeedback(observation.id, v),
            ),
        ]),
        if (current != null)
          Padding(
            padding: const EdgeInsets.only(top: Gap.s),
            child: Text(l.feedbackSaved, style: Theme.of(context).textTheme.bodySmall),
          ),
      ]),
    );
  }
}
