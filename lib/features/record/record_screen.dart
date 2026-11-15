import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/theme.dart';

/// Tab Quay: choose mode or import (UI_UX_SPEC §4.1).
class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabRecord)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.m),
        children: [
          _ModeCard(
            icon: Icons.insights,
            title: l.modeGuided,
            badge: l.modeRecommended,
            description: l.modeGuidedDesc,
            onTap: () => context.push('/setup/guided'),
          ),
          const SizedBox(height: Gap.m),
          _ModeCard(
            icon: Icons.videocam_outlined,
            title: l.modeSelf,
            description: l.modeSelfDesc,
            onTap: () => context.push('/setup/self'),
          ),
          const SizedBox(height: Gap.l),
          OutlinedButton.icon(
            onPressed: () => context.push('/import'),
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(l.importVideo),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Gap.m),
          child: Row(children: [
            Icon(icon, size: 40, color: theme.colorScheme.primary),
            const SizedBox(width: Gap.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(spacing: Gap.s, crossAxisAlignment: WrapCrossAlignment.center, children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    if (badge != null)
                      Chip(
                        label: Text(badge!),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: theme.colorScheme.primaryContainer,
                      ),
                  ]),
                  const SizedBox(height: Gap.xs),
                  Text(description),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ]),
        ),
      ),
    );
  }
}
