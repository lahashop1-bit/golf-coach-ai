import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/theme.dart';
import '../../data/db/database.dart';
import '../../domain/enums.dart';

/// Messages for the Phase 1 quality check.
List<String> qualityMessages(BuildContext context, Swing swing) {
  final l = context.l10n;
  if (swing.qualityIssues.isEmpty) return [l.qualityGood];
  return [
    for (final issue in swing.qualityIssues)
      switch (issue) {
        QualityIssue.tooShort => l.qualityTooShort,
        QualityIssue.lowFps => l.qualityLowFps(formatFps(context, swing.actualFps)),
        _ => l.errorGeneric,
      },
  ];
}

/// After-each-swing sheet (UI_UX_SPEC §4.5): replay, keep, retake.
/// Returns true to keep, false to retake.
Future<bool> showSwingReviewSheet(BuildContext context, Swing swing) async {
  final keep = await showModalBottomSheet<bool>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (context) {
      final l = context.l10n;
      final theme = Theme.of(context);
      final ok = swing.qualityLevel == QualityLevel.good;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Gap.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.swingNumber(swing.orderIndex), style: theme.textTheme.titleLarge),
              const SizedBox(height: Gap.s),
              for (final m in qualityMessages(context, swing))
                Row(children: [
                  Icon(ok ? Icons.check_circle_outline : Icons.info_outline,
                      color: ok ? theme.colorScheme.primary : theme.colorScheme.error),
                  const SizedBox(width: Gap.s),
                  Expanded(child: Text(m)),
                ]),
              const SizedBox(height: Gap.m),
              OutlinedButton.icon(
                icon: const Icon(Icons.play_circle_outline),
                label: Text(l.play),
                onPressed: () => context.push('/swing/${swing.id}'),
              ),
              const SizedBox(height: Gap.s),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l.retakeSwing),
                  ),
                ),
                const SizedBox(width: Gap.s),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l.keepSwing),
                  ),
                ),
              ]),
            ],
          ),
        ),
      );
    },
  );
  return keep ?? true;
}
