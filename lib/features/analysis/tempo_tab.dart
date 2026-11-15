import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/db/database.dart';
import '../../domain/enums.dart';
import 'analysis_status.dart';

/// Tab Nhịp: measured tempo only, no judgement and no pro comparison
/// (AI_ANALYSIS_SPEC §12). Low-confidence tempo is not shown.
class TempoTab extends ConsumerWidget {
  const TempoTab({super.key, required this.swing});

  final Swing swing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final result = ref.watch(analysisProvider(swing.id)).value;
    final tempo = result?.row.status == AnalysisStatus.completed ? result!.tempo : null;
    final lang = Localizations.localeOf(context).toLanguageTag();

    if (result?.row.status != AnalysisStatus.completed) {
      return ListView(padding: const EdgeInsets.all(Gap.m), children: [
        AnalysisStatusCard(swingId: swing.id),
      ]);
    }
    if (tempo == null || tempo.confidence == Confidence.low) {
      return ListView(padding: const EdgeInsets.all(Gap.m), children: [
        Text(l.tempoInsufficient, style: theme.textTheme.bodyLarge),
        LimitationNotes(result: result!),
      ]);
    }

    Widget row(String label, String value) => ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          trailing: Text(value, style: theme.textTheme.titleLarge),
        );

    return ListView(padding: const EdgeInsets.all(Gap.m), children: [
      row(l.tempoBackswing, l.durationSeconds(formatSeconds(context, tempo.backswingMs, decimals: 2))),
      row(l.tempoTopPause, l.durationSeconds(formatSeconds(context, tempo.topPauseMs, decimals: 2))),
      row(l.tempoDownswing, l.durationSeconds(formatSeconds(context, tempo.downswingMs, decimals: 2))),
      const Divider(),
      row(l.tempoRatio, l.tempoRatioValue(NumberFormat('0.0', lang).format(tempo.ratio))),
      Text(l.tempoRatioHint, style: theme.textTheme.bodySmall),
      const SizedBox(height: Gap.m),
      if (tempo.confidence == Confidence.medium)
        Padding(
          padding: const EdgeInsets.only(bottom: Gap.xs),
          child: Text(l.tempoMaybe, style: theme.textTheme.bodyMedium),
        ),
      Text(l.tempoEstimate(formatFps(context, swing.actualFps)),
          style: theme.textTheme.bodySmall),
      LimitationNotes(result: result!),
    ]);
  }
}
