import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/enums.dart';

part 'database.g.dart';

/// Stores a [WireEnum] by its stable wire value (DATABASE_SCHEMA §0).
class WireConverter<T extends WireEnum> extends TypeConverter<T, String> {
  const WireConverter(this.values);
  final List<T> values;

  @override
  T fromSql(String fromDb) => wireValue(values, fromDb);

  @override
  String toSql(T value) => value.wire;
}

/// Comma-separated list of [WireEnum] values.
class WireListConverter<T extends WireEnum>
    extends TypeConverter<List<T>, String> {
  const WireListConverter(this.values);
  final List<T> values;

  @override
  List<T> fromSql(String fromDb) => fromDb.isEmpty
      ? const []
      : fromDb.split(',').map((w) => wireValue(values, w)).toList();

  @override
  String toSql(List<T> value) => value.map((v) => v.wire).join(',');
}

/// DATABASE_SCHEMA §2. Exactly one local profile in the MVP.
@DataClassName('UserProfile')
class UserProfiles extends Table {
  TextColumn get id => text()();
  /// `vi-VN` | `en` | `ko-KR`; null = follow the system language.
  TextColumn get preferredLocale => text().nullable()();
  TextColumn get handedness =>
      text().map(const WireConverter(Handedness.values))();
  TextColumn get skillLevel =>
      text().map(const WireConverter(SkillLevel.values)).nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// DATABASE_SCHEMA §3.
@DataClassName('SwingSession')
class SwingSessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(UserProfiles, #id)();
  TextColumn get mode => text().map(const WireConverter(SessionMode.values))();
  TextColumn get source => text().map(const WireConverter(Source.values))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get clubType =>
      text().map(const WireConverter(ClubType.values)).nullable()();
  IntColumn get clubNumber => integer().nullable()();
  TextColumn get cameraAngle =>
      text().map(const WireConverter(CameraAngle.values))();
  TextColumn get handednessSnapshot =>
      text().map(const WireConverter(Handedness.values))();
  TextColumn get defaultSubject =>
      text().map(const WireConverter(Subject.values))();
  IntColumn get plannedSwingCount => integer().nullable()();
  TextColumn get feedbackTiming =>
      text().map(const WireConverter(FeedbackTiming.values))();
  IntColumn get feedbackDisplaySeconds => integer().nullable()();
  IntColumn get timerSeconds => integer().nullable()();
  IntColumn get requestedFps => integer().nullable()();
  TextColumn get status =>
      text().map(const WireConverter(SessionStatus.values))();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// DATABASE_SCHEMA §4. One swing = one clip.
class Swings extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(SwingSessions, #id)();
  IntColumn get orderIndex => integer()();
  TextColumn get subject => text().map(const WireConverter(Subject.values))();
  BoolColumn get includeInStats => boolean()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();
  TextColumn get platform =>
      text().map(const WireConverter(AppPlatform.values))();
  /// Relative to the app documents directory.
  TextColumn get localFilePath => text()();
  TextColumn get sourceAssetId => text().nullable()();
  TextColumn get thumbnailPath => text().nullable()();
  IntColumn get durationMs => integer()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  IntColumn get fileSizeBytes => integer()();
  RealColumn get actualFps => real()();
  IntColumn get rotationDegrees => integer()();
  TextColumn get qualityLevel =>
      text().map(const WireConverter(QualityLevel.values)).nullable()();
  TextColumn get qualityIssues =>
      text().map(const WireListConverter(QualityIssue.values))();
  TextColumn get uploadStatus =>
      text().withDefault(const Constant('local_only'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// DATABASE_SCHEMA §5. One analysis run of a swing; several may exist per
/// swing (model versions), `isCurrent` marks the one shown.
@DataClassName('SwingAnalysis')
class SwingAnalyses extends Table {
  TextColumn get id => text()();
  TextColumn get swingId => text().references(Swings, #id)();
  TextColumn get modelVersion => text()();
  TextColumn get schemaVersion => text()();
  TextColumn get status =>
      text().map(const WireConverter(AnalysisStatus.values))();
  BoolColumn get isCurrent => boolean().withDefault(const Constant(false))();
  /// True when keypoints were mirrored for a left-handed golfer before rules.
  BoolColumn get mirrored => boolean().withDefault(const Constant(false))();
  /// Relative to the app documents directory (derived file, DATABASE_SCHEMA §12).
  TextColumn get keypointsFilePath => text().nullable()();
  /// JSON array of PhaseMark (snake_case fields).
  TextColumn get phasesJson => text().nullable()();
  /// JSON object of Tempo, absent when not measurable.
  TextColumn get tempoJson => text().nullable()();
  TextColumn get limitationKeys => text().withDefault(const Constant(''))();
  TextColumn get errorCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [UserProfiles, SwingSessions, Swings, SwingAnalyses])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'golf_coach'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v2: swing analysis results. Existing rows are untouched.
          if (from < 2) await m.createTable(swingAnalyses);
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
