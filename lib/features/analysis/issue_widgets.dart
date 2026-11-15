import 'package:analysis_core/analysis_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/analysis_repository.dart';
import '../../data/db/database.dart';
import '../../data/guide_repository.dart';

/// Level as icon + text, never colour alone (UI_UX_SPEC §5.4).
class LevelBadge extends StatelessWidget {
  const LevelBadge(this.level, {super.key});
  final Level level;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (icon, color) = switch (level) {
      Level.ok => (Icons.check_circle_outline, scheme.primary),
      Level.attention => (Icons.visibility_outlined, scheme.tertiary),
      Level.review => (Icons.flag_outlined, scheme.error),
      Level.insufficientData => (Icons.help_outline, scheme.outline),
    };
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(width: Gap.xs),
      Flexible(child: Text(level.label(context.l10n))),
    ]);
  }
}

/// Wording for confidence instead of numbers (UI_UX_SPEC §5.4).
String confidenceText(BuildContext context, Confidence c) =>
    c == Confidence.high ? context.l10n.confidenceHigh : context.l10n.confidenceMedium;

void openIssueGuide(BuildContext context, String swingId, IssueId issue) =>
    context.push('/swing/$swingId/issue/${issue.wire}');

/// "Nên sửa trước", other issues and the checked list of the Posture tab.
class IssueSections extends ConsumerWidget {
  const IssueSections(
      {super.key, required this.swingId, required this.result, required this.angle});

  final String swingId;
  final AnalysisResult result;

  /// Camera angle of the swing's session (null while loading).
  final CameraAngle? angle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final guides = ref.watch(issueGuidesProvider(lang)).value;
    if (guides == null) return const SizedBox.shrink();

    final visible = result.visible.toList();
    final focus = visible.where((o) => o.isPriorityFocus).toList()
      ..sort((a, b) => _rank(b.level).compareTo(_rank(a.level)));
    final others = visible
        .where((o) => !o.isPriorityFocus && o.level != Level.ok)
        .toList()
      ..sort((a, b) => _rank(b.level).compareTo(_rank(a.level)));

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(l.focusTitle, style: theme.textTheme.titleMedium),
      const SizedBox(height: Gap.xs),
      if (focus.isEmpty)
        Text(l.noIssueFound, style: theme.textTheme.bodyMedium)
      else
        for (final o in focus) _IssueCard(swingId: swingId, observation: o, guides: guides),
      if (others.isNotEmpty) ...[
        const SizedBox(height: Gap.m),
        Text(l.otherIssuesTitle, style: theme.textTheme.titleMedium),
        for (final o in others) _IssueCard(swingId: swingId, observation: o, guides: guides),
      ],
      const SizedBox(height: Gap.m),
      Text(l.checkedTitle, style: theme.textTheme.titleMedium),
      for (final id in IssueId.values)
        if (guides[id] != null) _checkedRow(context, id, guides[id]!),
    ]);
  }

  Widget _checkedRow(BuildContext context, IssueId id, IssueGuide guide) {
    final l = context.l10n;
    final o = result.observation(id);
    final shown = o != null && !o.hiddenFromUser;
    final wrongAngle = angle != null && !id.angles.contains(angle);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(guide.title),
      subtitle: wrongAngle ? Text(l.issueNeedsAngle(id.angles.first.shortLabel(l))) : null,
      trailing: LevelBadge(shown ? o.level : Level.insufficientData),
      onTap: () => openIssueGuide(context, swingId, id),
    );
  }

  static int _rank(Level l) => l == Level.review ? 2 : (l == Level.attention ? 1 : 0);
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.swingId, required this.observation, required this.guides});

  final String swingId;
  final IssueObservation observation;
  final Map<IssueId, IssueGuide> guides;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final id = IssueId.byWire(observation.issueId);
    final guide = id == null ? null : guides[id];
    if (id == null || guide == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Gap.m),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(guide.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: Gap.xs),
          LevelBadge(observation.level),
          const SizedBox(height: Gap.xs),
          Text(confidenceText(context, observation.confidence)),
          Text(l.issueSeenAt(observation.phase.label(l)), style: theme.textTheme.bodySmall),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => openIssueGuide(context, swingId, id),
              child: Text(l.seeHowToFix),
            ),
          ),
        ]),
      ),
    );
  }
}
