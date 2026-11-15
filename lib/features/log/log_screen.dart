import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/swing_repository.dart';
import '../../widgets/common.dart';
import '../../widgets/session_card.dart';

/// Nhật ký: sessions newest first, All / Favorites (UI_UX_SPEC §7).
class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  bool _favoritesOnly = false;

  Future<void> _deleteSession(SessionWithSwings item) async {
    final l = context.l10n;
    if (await confirmDelete(context,
        title: l.deleteSessionTitle, body: l.deleteSessionBody)) {
      await ref.read(swingRepositoryProvider).deleteSession(item.session.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sessions = ref.watch(sessionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.tabLog)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Gap.m, 0, Gap.m, Gap.s),
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l.filterAll)),
              ButtonSegment(
                  value: true,
                  label: Text(l.filterFavorites),
                  icon: const Icon(Icons.star_outline)),
            ],
            selected: {_favoritesOnly},
            onSelectionChanged: (v) => setState(() => _favoritesOnly = v.first),
          ),
        ),
        Expanded(
          child: sessions.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) =>
                ErrorState(onRetry: () => ref.invalidate(sessionsProvider)),
            data: (all) {
              final list = _favoritesOnly
                  ? [
                      for (final item in all)
                        if (item.swings.any((s) => s.isFavorite))
                          SessionWithSwings(item.session,
                              item.swings.where((s) => s.isFavorite).toList()),
                    ]
                  : all;
              if (list.isEmpty) {
                return _favoritesOnly
                    ? EmptyState(icon: Icons.star_outline, message: l.favoritesEmpty)
                    : EmptyState(
                        icon: Icons.sports_golf,
                        message: l.emptySwings,
                        action: FilledButton(
                            onPressed: () => context.go('/record'),
                            child: Text(l.homeRecordCta)),
                      );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(Gap.m),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: Gap.s),
                itemBuilder: (context, i) => SessionCard(
                  item: list[i],
                  onLongPress: () => _deleteSession(list[i]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
