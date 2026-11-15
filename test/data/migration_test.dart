import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_coach_ai/data/db/database.dart';
import 'package:golf_coach_ai/domain/enums.dart';

/// v1 → v2 adds `swing_analyses` and must keep every existing row.
void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  test('upgrading from v1 keeps profiles and adds the analyses table', () async {
    final dir = await Directory.systemTemp.createTemp('golf_mig');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/db.sqlite');

    // Build a v1 database: the v1 schema is the v2 schema minus swing_analyses.
    final v1 = AppDatabase(NativeDatabase(file));
    await v1.customStatement('DROP TABLE swing_analyses');
    await v1.customStatement(
        "INSERT INTO user_profiles (id, handedness, created_at, updated_at) "
        "VALUES ('u1', 'left', 0, 0)");
    await v1.customStatement('PRAGMA user_version = 1');
    await v1.close();

    final v2 = AppDatabase(NativeDatabase(file));
    final profiles = await v2.select(v2.userProfiles).get();
    expect(profiles.single.id, 'u1');
    expect(profiles.single.handedness, Handedness.left);
    expect(await v2.select(v2.swingAnalyses).get(), isEmpty);
    final version = await v2.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 2);
    await v2.close();
  });
}
