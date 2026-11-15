import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../widgets/common.dart';
import '../../widgets/session_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final sessions = ref.watch(sessionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.homeGreeting),
        actions: [
          IconButton(
            tooltip: l.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Gap.m),
        children: [
          FilledButton.icon(
            onPressed: () => context.go('/record'),
            icon: const Icon(Icons.videocam),
            label: Text(l.homeRecordCta),
          ),
          const SizedBox(height: Gap.l),
          Row(children: [
            Expanded(
                child: Text(l.homeRecentSessions, style: theme.textTheme.titleLarge)),
            TextButton(onPressed: () => context.go('/log'), child: Text(l.seeAll)),
          ]),
          const SizedBox(height: Gap.s),
          ...sessions.when(
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (_, _) =>
                [ErrorState(onRetry: () => ref.invalidate(sessionsProvider))],
            data: (list) => list.isEmpty
                ? [EmptyState(icon: Icons.sports_golf, message: l.emptySwings)]
                : [
                    for (final item in list.take(3)) ...[
                      SessionCard(item: item),
                      const SizedBox(height: Gap.s),
                    ],
                  ],
          ),
        ],
      ),
    );
  }
}
