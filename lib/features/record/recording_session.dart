import 'dart:io';

import '../../data/db/database.dart';
import '../../data/swing_repository.dart';
import '../../domain/enums.dart';

AppPlatform get currentPlatform =>
    Platform.isIOS ? AppPlatform.ios : AppPlatform.android;

/// One recording session: the DB session is created with the first kept
/// swing so cancelled sessions leave nothing behind.
class RecordingSession {
  RecordingSession(this._repo, this._profile, this.setup);

  final SwingRepository _repo;
  final UserProfile _profile;
  final SessionSetup setup;

  SwingSession? _session;
  final List<Swing> kept = [];

  int get count => kept.length;

  bool get isComplete =>
      setup.plannedSwingCount != null && count >= setup.plannedSwingCount!;

  Future<Swing> save(File clip) async {
    _session ??= await _repo.createSession(
      userId: _profile.id,
      handedness: _profile.handedness,
      setup: setup,
      source: Source.recorded,
    );
    final swing = await _repo.addSwing(
        session: _session!, file: clip, platform: currentPlatform);
    kept.add(swing);
    return swing;
  }

  /// Retake: removes the swing; the repository drops an emptied session.
  Future<void> discard(Swing swing) async {
    await _repo.deleteSwing(swing.id);
    kept.removeWhere((s) => s.id == swing.id);
    if (kept.isEmpty) _session = null;
  }

  Future<void> finish() async {
    final s = _session;
    if (s != null) await _repo.finishSession(s.id);
  }
}
