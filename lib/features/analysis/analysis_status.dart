import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/analysis_repository.dart';
import '../../domain/enums.dart';
import 'analysis_jobs.dart';

/// Shows the state of a swing's analysis and the action that fits it:
/// analyze, progress + cancel, retry after failure (UI_UX_SPEC §4.7).
/// Returns an empty box when a completed analysis exists.
class AnalysisStatusCard extends ConsumerWidget {
  const AnalysisStatusCard({super.key, required this.swingId, this.showWhenDone = false});

  final String swingId;

  /// Show "Analyze again" even when a result exists.
  final bool showWhenDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final jobs = ref.watch(analysisJobsProvider);
    final notifier = ref.read(analysisJobsProvider.notifier);
    final progress = jobs[swingId];
    final result = ref.watch(analysisProvider(swingId)).value;

    if (progress != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(Gap.m),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(progress == 0 ? l.analysisQueued : l.analyzingLabel,
                style: theme.textTheme.titleMedium),
            const SizedBox(height: Gap.s),
            LinearProgressIndicator(value: progress == 0 ? null : progress),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () => notifier.cancel(swingId), child: Text(l.actionCancel)),
            ),
          ]),
        ),
      );
    }

    final status = result?.row.status;
    if (status == AnalysisStatus.completed && !showWhenDone) return const SizedBox.shrink();

    final message = switch ((status, result?.row.errorCode)) {
      (AnalysisStatus.failed, 'unsupported') => l.analysisUnsupported,
      (AnalysisStatus.failed, _) => l.analysisFailed,
      (AnalysisStatus.insufficientQuality, _) => l.analysisNoSwing,
      // A run interrupted by closing the app stays "processing" in the DB.
      (AnalysisStatus.processing, _) => l.analysisFailed,
      _ => null,
    };
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (message != null) ...[
        Row(children: [
          Icon(Icons.info_outline, color: theme.colorScheme.error),
          const SizedBox(width: Gap.s),
          Expanded(child: Text(message)),
        ]),
        const SizedBox(height: Gap.s),
      ],
      if (result?.row.errorCode != 'unsupported')
        FilledButton.icon(
          icon: const Icon(Icons.insights),
          label: Text(result == null ? l.analyzeSwing : l.analyzeAgain),
          onPressed: () => notifier.enqueue(swingId),
        ),
    ]);
  }
}

/// Short limitation lines shown with every result (AI_ANALYSIS_SPEC §13).
class LimitationNotes extends StatelessWidget {
  const LimitationNotes({super.key, required this.result});

  final AnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lines = [
      for (final k in result.limitations) ?limitationText(l, k),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final t in lines)
        Padding(
          padding: const EdgeInsets.only(top: Gap.xs),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.info_outline, size: 16),
            const SizedBox(width: Gap.s),
            Expanded(child: Text(t, style: Theme.of(context).textTheme.bodySmall)),
          ]),
        ),
    ]);
  }
}
