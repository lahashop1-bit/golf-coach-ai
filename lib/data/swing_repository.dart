import 'dart:io';

import 'package:capture/capture.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../domain/enums.dart';
import '../domain/quality.dart';
import 'db/database.dart';
import 'video_store.dart';

/// Settings chosen before recording/importing (UI_UX_SPEC §4.2–4.4).
class SessionSetup {
  const SessionSetup({
    required this.mode,
    required this.cameraAngle,
    required this.clubType,
    this.clubNumber,
    this.subject = Subject.self,
    this.plannedSwingCount,
    this.feedbackTiming = FeedbackTiming.afterEach,
    this.timerSeconds = 0,
  });

  final SessionMode mode;
  final CameraAngle cameraAngle;
  final ClubType clubType;
  final int? clubNumber;
  final Subject subject;
  final int? plannedSwingCount;
  final FeedbackTiming feedbackTiming;
  final int timerSeconds;
}

class SessionWithSwings {
  const SessionWithSwings(this.session, this.swings);
  final SwingSession session;
  final List<Swing> swings;
}

class SwingRepository {
  SwingRepository(this._db, this._videos, this._capture, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final VideoStore _videos;
  final Capture _capture;
  final Uuid _uuid;
  static const _quality = QualityRules();

  VideoStore get videos => _videos;

  Future<SwingSession> createSession({
    required String userId,
    required Handedness handedness,
    required SessionSetup setup,
    required Source source,
  }) async {
    final row = SwingSessionsCompanion.insert(
      id: _uuid.v4(),
      userId: userId,
      mode: setup.mode,
      source: source,
      startedAt: DateTime.now().toUtc(),
      clubType: Value(setup.clubType),
      clubNumber: Value(setup.clubType.hasNumber ? setup.clubNumber : null),
      cameraAngle: setup.cameraAngle,
      handednessSnapshot: handedness,
      defaultSubject: setup.subject,
      plannedSwingCount: Value(setup.plannedSwingCount),
      feedbackTiming: setup.feedbackTiming,
      timerSeconds: Value(setup.timerSeconds),
      status: source == Source.recorded
          ? SessionStatus.recording
          : SessionStatus.completed,
    );
    return _db.into(_db.swingSessions).insertReturning(row);
  }

  /// Moves [file] into the store, reads its real metadata and saves a swing.
  Future<Swing> addSwing({
    required SwingSession session,
    required File file,
    required AppPlatform platform,
    String? sourceAssetId,
  }) async {
    final id = _uuid.v4();
    final rel = await _videos.importFile(file, id);
    final thumbRel = _videos.thumbnailRelativePath(id);
    try {
      final info = await _capture.probeVideo(_videos.absolute(rel),
          thumbnailPath: _videos.absolute(thumbRel));
      final quality = _quality.check(durationMs: info.durationMs, fps: info.fps);
      final count = await _swingCount(session.id);
      final subject = session.defaultSubject;
      return await _db.into(_db.swings).insertReturning(SwingsCompanion.insert(
            id: id,
            sessionId: session.id,
            orderIndex: count + 1,
            subject: subject,
            includeInStats: subject == Subject.self,
            platform: platform,
            localFilePath: rel,
            sourceAssetId: Value(sourceAssetId),
            thumbnailPath: Value(info.thumbnailPath == null ? null : thumbRel),
            durationMs: info.durationMs,
            width: info.width,
            height: info.height,
            fileSizeBytes: info.fileSizeBytes,
            actualFps: info.fps,
            rotationDegrees: info.rotationDegrees,
            qualityLevel: Value(quality.level),
            qualityIssues: quality.issues,
            createdAt: DateTime.now().toUtc(),
          ));
    } catch (_) {
      await _videos.deleteFiles([rel, thumbRel]);
      rethrow;
    }
  }

  Future<int> _swingCount(String sessionId) async {
    final c = _db.swings.id.count();
    final q = _db.selectOnly(_db.swings)
      ..addColumns([c])
      ..where(_db.swings.sessionId.equals(sessionId));
    return (await q.getSingle()).read(c) ?? 0;
  }

  /// Completes a recording session; drops it when no swing was kept.
  Future<void> finishSession(String sessionId) async {
    if (await _swingCount(sessionId) == 0) {
      await (_db.delete(_db.swingSessions)..where((s) => s.id.equals(sessionId)))
          .go();
      return;
    }
    await (_db.update(_db.swingSessions)..where((s) => s.id.equals(sessionId)))
        .write(SwingSessionsCompanion(
      status: const Value(SessionStatus.completed),
      endedAt: Value(DateTime.now().toUtc()),
    ));
  }

  /// Sessions left in `recording` (app killed mid-session) are completed, or
  /// dropped when empty, so their kept swings show up in the log.
  Future<void> recoverInterruptedSessions() async {
    final open = await (_db.select(_db.swingSessions)
          ..where((s) => s.status.equals(SessionStatus.recording.wire)))
        .get();
    for (final s in open) {
      await finishSession(s.id);
    }
  }

  /// All sessions, newest first, each with its swings in recording order.
  Stream<List<SessionWithSwings>> watchSessions() {
    final sessions = (_db.select(_db.swingSessions)
          ..where((s) => s.status.equals(SessionStatus.completed.wire))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .watch();
    return sessions.asyncMap((list) async {
      final swings = await (_db.select(_db.swings)
            ..orderBy([(s) => OrderingTerm.asc(s.orderIndex)]))
          .get();
      final bySession = <String, List<Swing>>{};
      for (final s in swings) {
        bySession.putIfAbsent(s.sessionId, () => []).add(s);
      }
      return [
        for (final s in list) SessionWithSwings(s, bySession[s.id] ?? const []),
      ];
    });
  }

  Stream<Swing?> watchSwing(String id) =>
      (_db.select(_db.swings)..where((s) => s.id.equals(id))).watchSingleOrNull();

  Future<SwingSession> getSession(String id) =>
      (_db.select(_db.swingSessions)..where((s) => s.id.equals(id))).getSingle();

  Future<void> _updateSwing(String id, SwingsCompanion data) =>
      (_db.update(_db.swings)..where((s) => s.id.equals(id))).write(data);

  Future<void> setFavorite(String id, bool value) =>
      _updateSwing(id, SwingsCompanion(isFavorite: Value(value)));

  Future<void> setNote(String id, String? note) => _updateSwing(
      id, SwingsCompanion(note: Value(note?.trim().isEmpty ?? true ? null : note!.trim())));

  Future<void> setIncludeInStats(String id, bool value) =>
      _updateSwing(id, SwingsCompanion(includeInStats: Value(value)));

  Future<void> setSubject(String id, Subject subject) =>
      _updateSwing(id, SwingsCompanion(subject: Value(subject)));

  /// DATABASE_SCHEMA §13: deletes the clip, its derived files and its row.
  /// The session goes too when it becomes empty.
  Future<void> deleteSwing(String id) async {
    final swing = await (_db.select(_db.swings)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
    if (swing == null) return;
    await _db.transaction(() async {
      await (_db.delete(_db.swings)..where((s) => s.id.equals(id))).go();
      if (await _swingCount(swing.sessionId) == 0) {
        await (_db.delete(_db.swingSessions)
              ..where((s) => s.id.equals(swing.sessionId)))
            .go();
      }
    });
    await _videos.deleteFiles([swing.localFilePath, swing.thumbnailPath]);
  }

  Future<void> deleteSession(String sessionId) async {
    final swings = await (_db.select(_db.swings)
          ..where((s) => s.sessionId.equals(sessionId)))
        .get();
    await _db.transaction(() async {
      await (_db.delete(_db.swings)..where((s) => s.sessionId.equals(sessionId)))
          .go();
      await (_db.delete(_db.swingSessions)..where((s) => s.id.equals(sessionId)))
          .go();
    });
    await _videos.deleteFiles(
        swings.expand((s) => [s.localFilePath, s.thumbnailPath]));
  }
}
