import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/labels.dart';
import '../app/providers.dart';
import '../app/theme.dart';
import '../data/db/database.dart';
import '../data/swing_repository.dart';
import '../domain/enums.dart';

/// Session card: date, club · angle, swing count, swing thumbnails.
class SessionCard extends ConsumerWidget {
  const SessionCard({super.key, required this.item, this.onLongPress});

  final SessionWithSwings item;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final s = item.session;
    return Card(
      child: InkWell(
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Gap.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formatDateTime(context, s.startedAt),
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: Gap.xs),
              Text([
                sessionSummary(l, s),
                l.swingCount(item.swings.length),
                if (s.source == Source.imported) l.sourceImported,
              ].join(' · ')),
              const SizedBox(height: Gap.s),
              SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.swings.length,
                  separatorBuilder: (_, _) => const SizedBox(width: Gap.s),
                  itemBuilder: (context, i) => SwingThumb(swing: item.swings[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwingThumb extends ConsumerWidget {
  const SwingThumb({super.key, required this.swing});

  final Swing swing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final path = swing.thumbnailPath;
    final file = path == null ? null : File(ref.watch(videoStoreProvider).absolute(path));
    void open() => context.push('/swing/${swing.id}');
    // One clean label for VoiceOver/TalkBack instead of image + badge text.
    return Semantics(
      button: true,
      label: context.l10n.swingThumbnail(swing.orderIndex),
      onTap: open,
      excludeSemantics: true,
      child: InkWell(
        onTap: open,
        borderRadius: BorderRadius.circular(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 66,
            child: Stack(fit: StackFit.expand, children: [
              if (file != null)
                Image.file(file, fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _placeholder(theme))
              else
                _placeholder(theme),
              Positioned(
                left: 4,
                bottom: 4,
                child: _badge(theme, '${swing.orderIndex}'),
              ),
              if (swing.isFavorite)
                const Positioned(
                    right: 2, top: 2,
                    child: Icon(Icons.star, size: 18, color: Colors.amber)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) => ColoredBox(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(Icons.videocam, color: theme.colorScheme.onSurfaceVariant),
      );

  Widget _badge(ThemeData theme, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(6)),
        child: Text(text,
            style: theme.textTheme.labelMedium?.copyWith(color: Colors.white)),
      );
}
