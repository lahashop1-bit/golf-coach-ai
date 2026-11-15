import 'package:flutter/material.dart';

import '../app/labels.dart';
import '../app/theme.dart';

/// Empty/error state with an optional first action (UI_UX_SPEC §11).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.title,
    this.action,
  });

  final IconData icon;
  final String? title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Gap.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: Gap.m),
            if (title != null) ...[
              Text(title!, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: Gap.s),
            ],
            Text(message, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: Gap.l), action!],
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => EmptyState(
        icon: Icons.error_outline,
        message: context.l10n.errorGeneric,
        action: onRetry == null
            ? null
            : OutlinedButton(onPressed: onRetry, child: Text(context.l10n.actionRetry)),
      );
}

/// Single-choice group rendered as wrapping chips (large touch targets).
class ChoiceGroup<T> extends StatelessWidget {
  const ChoiceGroup({
    super.key,
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.hint,
  });

  final String label;
  final String? hint;
  final List<T> values;
  final T? selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleMedium),
          if (hint != null)
            Text(hint!, style: theme.textTheme.bodySmall),
          const SizedBox(height: Gap.s),
          Wrap(
            spacing: Gap.s,
            runSpacing: Gap.s,
            children: [
              for (final v in values)
                ChoiceChip(
                  label: Text(labelOf(v)),
                  selected: v == selected,
                  onSelected: (_) => onSelected(v),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<bool> confirmDelete(BuildContext context,
    {required String title, required String body}) async {
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.actionCancel)),
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.actionDelete,
                style: TextStyle(color: Theme.of(context).colorScheme.error))),
      ],
    ),
  );
  return ok ?? false;
}
