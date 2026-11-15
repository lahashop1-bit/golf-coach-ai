import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/db/database.dart';
import '../../domain/enums.dart';
import '../../widgets/common.dart';
import '../analysis/analysis_status.dart';
import '../analysis/posture_tab.dart';
import '../analysis/tempo_tab.dart';
import 'swing_player.dart';

/// Swing detail with 3 tabs: Tư thế · Toàn bộ swing · Nhịp (GOLF_FEATURES §8).
class SwingDetailScreen extends ConsumerWidget {
  const SwingDetailScreen({super.key, required this.swingId});

  final String swingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final swing = ref.watch(swingProvider(swingId));
    return swing.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(appBar: AppBar(), body: const ErrorState()),
      data: (s) {
        if (s == null) {
          return Scaffold(
              appBar: AppBar(),
              body: EmptyState(icon: Icons.videocam_off_outlined, message: l.videoMissing));
        }
        return _Detail(swing: s);
      },
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.swing});

  final Swing swing;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    if (await confirmDelete(context, title: l.deleteSwingTitle, body: l.deleteSwingBody)) {
      if (context.mounted) context.pop();
      await ref.read(swingRepositoryProvider).deleteSwing(swing.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final repo = ref.read(swingRepositoryProvider);
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.swingNumber(swing.orderIndex)),
          actions: [
            IconButton(
              tooltip: swing.isFavorite ? l.favoriteRemove : l.favoriteAdd,
              icon: Icon(swing.isFavorite ? Icons.star : Icons.star_outline,
                  color: swing.isFavorite ? Colors.amber : null),
              onPressed: () => repo.setFavorite(swing.id, !swing.isFavorite),
            ),
            IconButton(
              tooltip: l.actionDelete,
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(context, ref),
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(text: l.tabPosture),
            Tab(text: l.tabFullSwing),
            Tab(text: l.tabTempo),
          ]),
        ),
        body: TabBarView(children: [
          PostureTab(swing: swing),
          _FullSwingTab(swing: swing),
          TempoTab(swing: swing),
        ]),
      ),
    );
  }
}

class _FullSwingTab extends ConsumerWidget {
  const _FullSwingTab({required this.swing});

  final Swing swing;

  Future<void> _editNote(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final controller = TextEditingController(text: swing.note);
    final saved = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(l.noteLabel),
        content: Material(
          type: MaterialType.transparency,
          child: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            decoration: InputDecoration(hintText: l.noteHint),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l.actionCancel)),
          TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(l.actionSave)),
        ],
      ),
    );
    controller.dispose();
    if (saved != null) await ref.read(swingRepositoryProvider).setNote(swing.id, saved);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final repo = ref.read(swingRepositoryProvider);
    final session = ref.watch(sessionProvider(swing.sessionId)).value;
    final file = File(ref.watch(videoStoreProvider).absolute(swing.localFilePath));
    final analysis = ref.watch(analysisProvider(swing.id)).value;
    final done = analysis?.row.status == AnalysisStatus.completed;
    final keypoints = done ? ref.watch(keypointsProvider(analysis!.row)).value : null;

    Widget info(String label, String value) => ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          trailing: Text(value, style: theme.textTheme.bodyLarge),
        );

    return ListView(
      padding: const EdgeInsets.all(Gap.m),
      children: [
        SwingPlayer(
          file: file,
          fps: swing.actualFps,
          phases: done ? analysis!.phases : const [],
          keypoints: keypoints,
        ),
        const SizedBox(height: Gap.m),
        AnalysisStatusCard(swingId: swing.id),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.edit_note),
          title: Text(swing.note ?? l.noteAdd,
              style: swing.note == null
                  ? TextStyle(color: theme.colorScheme.primary)
                  : null),
          onTap: () => _editNote(context, ref),
        ),
        const Divider(),
        Text(l.swingInfo, style: theme.textTheme.titleMedium),
        if (session != null) ...[
          info(l.cameraAngleLabel, session.cameraAngle.fullLabel(l)),
          if (session.clubType != null)
            info(l.clubLabel, clubText(l, session.clubType, session.clubNumber)),
          info(l.handednessLabel, session.handednessSnapshot.label(l)),
        ],
        info(l.recordedAtLabel, formatDateTime(context, swing.createdAt)),
        info(l.durationLabel,
            l.durationSeconds(formatSeconds(context, swing.durationMs))),
        info(l.frameRateLabel, l.fpsValue(formatFps(context, swing.actualFps))),
        const SizedBox(height: Gap.s),
        ChoiceGroup<Subject>(
          label: l.subjectLabel,
          values: Subject.values,
          selected: swing.subject,
          labelOf: (v) => v.label(l),
          onSelected: (v) => repo.setSubject(swing.id, v),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text(l.includeInStats),
          value: swing.includeInStats,
          onChanged: (v) => repo.setIncludeInStats(swing.id, v),
        ),
      ],
    );
  }
}
