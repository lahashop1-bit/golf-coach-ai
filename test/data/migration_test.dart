import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/data/db/database.dart';
import 'package:golf_coach_ai/domain/enums.dart';

/// Each upgrade only adds tables and must keep every existing row.
void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  test('upgrading from v1 keeps profiles and adds the analysis tables', () async {
    final dir = await Directory.systemTemp.createTemp('golf_mig');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/db.sqlite');

    // Build a v1 database: the current schema minus the tables added later.
    final v1 = AppDatabase(NativeDatabase(file));
    await v1.customStatement('DROP TABLE analysis_feedbacks');
    await v1.customStatement('DROP TABLE issue_observations');
    await v1.customStatement('DROP TABLE swing_analyses');
    await v1.customStatement(
        "INSERT INTO user_profiles (id, handedness, created_at, updated_at) "
        "VALUES ('u1', 'left', 0, 0)");
    await v1.customStatement('PRAGMA user_version = 1');
    await v1.close();

    final db = AppDatabase(NativeDatabase(file));
    final profiles = await db.select(db.userProfiles).get();
    expect(profiles.single.id, 'u1');
    expect(profiles.single.handedness, Handedness.left);
    expect(await db.select(db.swingAnalyses).get(), isEmpty);
    expect(await db.select(db.issueObservations).get(), isEmpty);
    expect(await db.select(db.analysisFeedbacks).get(), isEmpty);
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 3);
    await db.close();
  });

  test('upgrading from v2 keeps analyses and adds the issue tables', () async {
    final dir = await Directory.systemTemp.createTemp('golf_mig');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/db.sqlite');

    final v2 = AppDatabase(NativeDatabase(file));
    await v2.customStatement('DROP TABLE analysis_feedbacks');
    await v2.customStatement('DROP TABLE issue_observations');
    await v2.customStatement('PRAGMA foreign_keys = OFF');
    await v2.customStatement(
        "INSERT INTO swing_analyses (id, swing_id, model_version, schema_version, status, "
        "is_current, mirrored, limitation_keys, created_at) "
        "VALUES ('a1', 's1', 'm', '1.0', 'completed', 1, 0, '', 0)");
    await v2.customStatement('PRAGMA user_version = 2');
    await v2.close();

    final db = AppDatabase(NativeDatabase(file));
    expect((await db.select(db.swingAnalyses).get()).single.id, 'a1');
    expect(await db.select(db.issueObservations).get(), isEmpty);
    await db.close();
  });
}
