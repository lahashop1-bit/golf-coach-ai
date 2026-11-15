import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../domain/enums.dart';
import 'db/database.dart';
import 'video_store.dart';

/// The single local profile (no account in the MVP).
class ProfileRepository {
  ProfileRepository(this._db, this._videos);

  final AppDatabase _db;
  final VideoStore _videos;

  Stream<UserProfile?> watch() =>
      (_db.select(_db.userProfiles)..limit(1)).watchSingleOrNull();

  Future<UserProfile> create({
    required Handedness handedness,
    SkillLevel? skillLevel,
    String? preferredLocale,
  }) {
    final now = DateTime.now().toUtc();
    return _db.into(_db.userProfiles).insertReturning(
          UserProfilesCompanion.insert(
            id: const Uuid().v4(),
            preferredLocale: Value(preferredLocale),
            handedness: handedness,
            skillLevel: Value(skillLevel),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> update(String id, UserProfilesCompanion data) =>
      (_db.update(_db.userProfiles)..where((p) => p.id.equals(id))).write(
          data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  /// Settings → "Xóa toàn bộ dữ liệu": DB rows and every video file.
  Future<void> deleteAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.swingAnalyses).go();
      await _db.delete(_db.swings).go();
      await _db.delete(_db.swingSessions).go();
      await _db.delete(_db.userProfiles).go();
    });
    await _videos.deleteAll();
  }
}
