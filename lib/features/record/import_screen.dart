import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/swing_repository.dart';
import '../../domain/enums.dart';
import 'recording_session.dart';
import 'setup_fields.dart';

/// Import from the system picker (PHPicker on iOS, Photo Picker on Android),
/// then confirm angle/club/subject (GOLF_FEATURES §2.3).
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _draft = SetupDraft();
  XFile? _picked;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _pick());
  }

  Future<void> _pick() async {
    final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (!mounted) return;
    if (file != null) return setState(() => _picked = file);
    // Cancelled the first pick: nothing to confirm, leave.
    if (_picked == null) context.pop();
  }

  Future<void> _save() async {
    final picked = _picked;
    final profile = ref.read(profileProvider).value;
    if (picked == null || profile == null) return;
    setState(() => _saving = true);
    final repo = ref.read(swingRepositoryProvider);
    try {
      final session = await repo.createSession(
        userId: profile.id,
        handedness: profile.handedness,
        source: Source.imported,
        setup: SessionSetup(
          mode: SessionMode.selfRecord,
          cameraAngle: _draft.angle,
          clubType: _draft.club,
          clubNumber: _draft.clubNumber,
          subject: _draft.subject,
        ),
      );
      try {
        final swing = await repo.addSwing(
            session: session, file: File(picked.path), platform: currentPlatform);
        if (mounted) context.pushReplacement('/swing/${swing.id}');
      } catch (_) {
        await repo.deleteSession(session.id);
        rethrow;
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.importFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.importConfirmTitle)),
      body: _picked == null
          ? const SizedBox.shrink()
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(Gap.m),
                children: [
                  SetupFields(draft: _draft, onChanged: () => setState(() {})),
                  const SizedBox(height: Gap.m),
                  if (_saving)
                    Column(children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: Gap.s),
                      Text(l.importing),
                    ])
                  else ...[
                    FilledButton(onPressed: _save, child: Text(l.importSave)),
                    const SizedBox(height: Gap.s),
                    OutlinedButton(onPressed: _pick, child: Text(l.importVideo)),
                  ],
                ],
              ),
            ),
    );
  }
}
