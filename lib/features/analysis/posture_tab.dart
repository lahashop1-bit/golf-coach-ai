import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/flags.dart';
import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/db/database.dart';
import '../../domain/enums.dart';
import 'analysis_status.dart';
import 'issue_widgets.dart';

/// Tab Tư thế: priority issue, other issues, what was checked, and the
/// phases found. Issue feedback is experimental and only shown when
/// [experimentalIssues] is on (internal builds).
class PostureTab extends ConsumerWidget {
  const PostureTab({super.key, required this.swing});

  final Swing swing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final result = ref.watch(analysisProvider(swing.id)).value;

    if (result?.row.status != AnalysisStatus.completed) {
      return ListView(padding: const EdgeInsets.all(Gap.m), children: [
        AnalysisStatusCard(swingId: swing.id),
      ]);
    }
    final angle = ref.watch(sessionProvider(swing.sessionId)).value?.cameraAngle;

    return ListView(padding: const EdgeInsets.all(Gap.m), children: [
      Card(
        color: theme.colorScheme.secondaryContainer,
        child: ListTile(
          leading: const Icon(Icons.science_outlined),
          title: Text(l.postureTrialTitle),
          subtitle: Text(experimentalIssues ? l.postureTrialIssuesBody : l.postureTrialBody),
        ),
      ),
      const SizedBox(height: Gap.m),
      if (experimentalIssues) ...[
        IssueSections(swingId: swing.id, result: result!, angle: angle),
        const SizedBox(height: Gap.m),
      ],
      Text(l.phasesTitle, style: theme.textTheme.titleMedium),
      for (final p in SwingPhase.values)
        () {
          final m = result!.phase(p);
          // Low-confidence marks count as "not enough data" (AI_ANALYSIS_SPEC §4).
          final found = m != null && m.confidence != Confidence.low;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(found ? Icons.check_circle_outline : Icons.help_outline,
                color: found ? theme.colorScheme.primary : theme.colorScheme.outline),
            title: Text(p.label(l)),
            trailing: Text(found
                ? l.durationSeconds(formatSeconds(context, m.timestampMs))
                : l.levelInsufficientData),
          );
        }(),
      LimitationNotes(result: result!),
      const SizedBox(height: Gap.m),
      AnalysisStatusCard(swingId: swing.id, showWhenDone: true),
    ]);
  }
}
