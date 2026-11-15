// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredLocaleMeta = const VerificationMeta(
    'preferredLocale',
  );
  @override
  late final GeneratedColumn<String> preferredLocale = GeneratedColumn<String>(
    'preferred_locale',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Handedness, String> handedness =
      GeneratedColumn<String>(
        'handedness',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Handedness>($UserProfilesTable.$converterhandedness);
  @override
  late final GeneratedColumnWithTypeConverter<SkillLevel?, String> skillLevel =
      GeneratedColumn<String>(
        'skill_level',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<SkillLevel?>($UserProfilesTable.$converterskillLeveln);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    preferredLocale,
    handedness,
    skillLevel,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('preferred_locale')) {
      context.handle(
        _preferredLocaleMeta,
        preferredLocale.isAcceptableOrUnknown(
          data['preferred_locale']!,
          _preferredLocaleMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      preferredLocale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_locale'],
      ),
      handedness: $UserProfilesTable.$converterhandedness.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}handedness'],
        )!,
      ),
      skillLevel: $UserProfilesTable.$converterskillLeveln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}skill_level'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }

  static TypeConverter<Handedness, String> $converterhandedness =
      const WireConverter(Handedness.values);
  static TypeConverter<SkillLevel, String> $converterskillLevel =
      const WireConverter(SkillLevel.values);
  static TypeConverter<SkillLevel?, String?> $converterskillLeveln =
      NullAwareTypeConverter.wrap($converterskillLevel);
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;

  /// `vi-VN` | `en` | `ko-KR`; null = follow the system language.
  final String? preferredLocale;
  final Handedness handedness;
  final SkillLevel? skillLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProfile({
    required this.id,
    this.preferredLocale,
    required this.handedness,
    this.skillLevel,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || preferredLocale != null) {
      map['preferred_locale'] = Variable<String>(preferredLocale);
    }
    {
      map['handedness'] = Variable<String>(
        $UserProfilesTable.$converterhandedness.toSql(handedness),
      );
    }
    if (!nullToAbsent || skillLevel != null) {
      map['skill_level'] = Variable<String>(
        $UserProfilesTable.$converterskillLeveln.toSql(skillLevel),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      preferredLocale: preferredLocale == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredLocale),
      handedness: Value(handedness),
      skillLevel: skillLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(skillLevel),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      preferredLocale: serializer.fromJson<String?>(json['preferredLocale']),
      handedness: serializer.fromJson<Handedness>(json['handedness']),
      skillLevel: serializer.fromJson<SkillLevel?>(json['skillLevel']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'preferredLocale': serializer.toJson<String?>(preferredLocale),
      'handedness': serializer.toJson<Handedness>(handedness),
      'skillLevel': serializer.toJson<SkillLevel?>(skillLevel),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfile copyWith({
    String? id,
    Value<String?> preferredLocale = const Value.absent(),
    Handedness? handedness,
    Value<SkillLevel?> skillLevel = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfile(
    id: id ?? this.id,
    preferredLocale: preferredLocale.present
        ? preferredLocale.value
        : this.preferredLocale,
    handedness: handedness ?? this.handedness,
    skillLevel: skillLevel.present ? skillLevel.value : this.skillLevel,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      preferredLocale: data.preferredLocale.present
          ? data.preferredLocale.value
          : this.preferredLocale,
      handedness: data.handedness.present
          ? data.handedness.value
          : this.handedness,
      skillLevel: data.skillLevel.present
          ? data.skillLevel.value
          : this.skillLevel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('preferredLocale: $preferredLocale, ')
          ..write('handedness: $handedness, ')
          ..write('skillLevel: $skillLevel, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    preferredLocale,
    handedness,
    skillLevel,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.preferredLocale == this.preferredLocale &&
          other.handedness == this.handedness &&
          other.skillLevel == this.skillLevel &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String?> preferredLocale;
  final Value<Handedness> handedness;
  final Value<SkillLevel?> skillLevel;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.preferredLocale = const Value.absent(),
    this.handedness = const Value.absent(),
    this.skillLevel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    this.preferredLocale = const Value.absent(),
    required Handedness handedness,
    this.skillLevel = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       handedness = Value(handedness),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? preferredLocale,
    Expression<String>? handedness,
    Expression<String>? skillLevel,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preferredLocale != null) 'preferred_locale': preferredLocale,
      if (handedness != null) 'handedness': handedness,
      if (skillLevel != null) 'skill_level': skillLevel,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? preferredLocale,
    Value<Handedness>? handedness,
    Value<SkillLevel?>? skillLevel,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      preferredLocale: preferredLocale ?? this.preferredLocale,
      handedness: handedness ?? this.handedness,
      skillLevel: skillLevel ?? this.skillLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (preferredLocale.present) {
      map['preferred_locale'] = Variable<String>(preferredLocale.value);
    }
    if (handedness.present) {
      map['handedness'] = Variable<String>(
        $UserProfilesTable.$converterhandedness.toSql(handedness.value),
      );
    }
    if (skillLevel.present) {
      map['skill_level'] = Variable<String>(
        $UserProfilesTable.$converterskillLeveln.toSql(skillLevel.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('preferredLocale: $preferredLocale, ')
          ..write('handedness: $handedness, ')
          ..write('skillLevel: $skillLevel, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SwingSessionsTable extends SwingSessions
    with TableInfo<$SwingSessionsTable, SwingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SwingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_profiles (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionMode, String> mode =
      GeneratedColumn<String>(
        'mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SessionMode>($SwingSessionsTable.$convertermode);
  @override
  late final GeneratedColumnWithTypeConverter<Source, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Source>($SwingSessionsTable.$convertersource);
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ClubType?, String> clubType =
      GeneratedColumn<String>(
        'club_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<ClubType?>($SwingSessionsTable.$converterclubTypen);
  static const VerificationMeta _clubNumberMeta = const VerificationMeta(
    'clubNumber',
  );
  @override
  late final GeneratedColumn<int> clubNumber = GeneratedColumn<int>(
    'club_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CameraAngle, String> cameraAngle =
      GeneratedColumn<String>(
        'camera_angle',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CameraAngle>($SwingSessionsTable.$convertercameraAngle);
  @override
  late final GeneratedColumnWithTypeConverter<Handedness, String>
  handednessSnapshot = GeneratedColumn<String>(
    'handedness_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Handedness>($SwingSessionsTable.$converterhandednessSnapshot);
  @override
  late final GeneratedColumnWithTypeConverter<Subject, String> defaultSubject =
      GeneratedColumn<String>(
        'default_subject',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Subject>($SwingSessionsTable.$converterdefaultSubject);
  static const VerificationMeta _plannedSwingCountMeta = const VerificationMeta(
    'plannedSwingCount',
  );
  @override
  late final GeneratedColumn<int> plannedSwingCount = GeneratedColumn<int>(
    'planned_swing_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FeedbackTiming, String>
  feedbackTiming = GeneratedColumn<String>(
    'feedback_timing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<FeedbackTiming>($SwingSessionsTable.$converterfeedbackTiming);
  static const VerificationMeta _feedbackDisplaySecondsMeta =
      const VerificationMeta('feedbackDisplaySeconds');
  @override
  late final GeneratedColumn<int> feedbackDisplaySeconds = GeneratedColumn<int>(
    'feedback_display_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timerSecondsMeta = const VerificationMeta(
    'timerSeconds',
  );
  @override
  late final GeneratedColumn<int> timerSeconds = GeneratedColumn<int>(
    'timer_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requestedFpsMeta = const VerificationMeta(
    'requestedFps',
  );
  @override
  late final GeneratedColumn<int> requestedFps = GeneratedColumn<int>(
    'requested_fps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SessionStatus>($SwingSessionsTable.$converterstatus);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    mode,
    source,
    startedAt,
    endedAt,
    clubType,
    clubNumber,
    cameraAngle,
    handednessSnapshot,
    defaultSubject,
    plannedSwingCount,
    feedbackTiming,
    feedbackDisplaySeconds,
    timerSeconds,
    requestedFps,
    status,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'swing_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SwingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('club_number')) {
      context.handle(
        _clubNumberMeta,
        clubNumber.isAcceptableOrUnknown(data['club_number']!, _clubNumberMeta),
      );
    }
    if (data.containsKey('planned_swing_count')) {
      context.handle(
        _plannedSwingCountMeta,
        plannedSwingCount.isAcceptableOrUnknown(
          data['planned_swing_count']!,
          _plannedSwingCountMeta,
        ),
      );
    }
    if (data.containsKey('feedback_display_seconds')) {
      context.handle(
        _feedbackDisplaySecondsMeta,
        feedbackDisplaySeconds.isAcceptableOrUnknown(
          data['feedback_display_seconds']!,
          _feedbackDisplaySecondsMeta,
        ),
      );
    }
    if (data.containsKey('timer_seconds')) {
      context.handle(
        _timerSecondsMeta,
        timerSeconds.isAcceptableOrUnknown(
          data['timer_seconds']!,
          _timerSecondsMeta,
        ),
      );
    }
    if (data.containsKey('requested_fps')) {
      context.handle(
        _requestedFpsMeta,
        requestedFps.isAcceptableOrUnknown(
          data['requested_fps']!,
          _requestedFpsMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SwingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SwingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      mode: $SwingSessionsTable.$convertermode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}mode'],
        )!,
      ),
      source: $SwingSessionsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      clubType: $SwingSessionsTable.$converterclubTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}club_type'],
        ),
      ),
      clubNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}club_number'],
      ),
      cameraAngle: $SwingSessionsTable.$convertercameraAngle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}camera_angle'],
        )!,
      ),
      handednessSnapshot: $SwingSessionsTable.$converterhandednessSnapshot
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}handedness_snapshot'],
            )!,
          ),
      defaultSubject: $SwingSessionsTable.$converterdefaultSubject.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}default_subject'],
        )!,
      ),
      plannedSwingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_swing_count'],
      ),
      feedbackTiming: $SwingSessionsTable.$converterfeedbackTiming.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}feedback_timing'],
        )!,
      ),
      feedbackDisplaySeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}feedback_display_seconds'],
      ),
      timerSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timer_seconds'],
      ),
      requestedFps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}requested_fps'],
      ),
      status: $SwingSessionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SwingSessionsTable createAlias(String alias) {
    return $SwingSessionsTable(attachedDatabase, alias);
  }

  static TypeConverter<SessionMode, String> $convertermode =
      const WireConverter(SessionMode.values);
  static TypeConverter<Source, String> $convertersource = const WireConverter(
    Source.values,
  );
  static TypeConverter<ClubType, String> $converterclubType =
      const WireConverter(ClubType.values);
  static TypeConverter<ClubType?, String?> $converterclubTypen =
      NullAwareTypeConverter.wrap($converterclubType);
  static TypeConverter<CameraAngle, String> $convertercameraAngle =
      const WireConverter(CameraAngle.values);
  static TypeConverter<Handedness, String> $converterhandednessSnapshot =
      const WireConverter(Handedness.values);
  static TypeConverter<Subject, String> $converterdefaultSubject =
      const WireConverter(Subject.values);
  static TypeConverter<FeedbackTiming, String> $converterfeedbackTiming =
      const WireConverter(FeedbackTiming.values);
  static TypeConverter<SessionStatus, String> $converterstatus =
      const WireConverter(SessionStatus.values);
}

class SwingSession extends DataClass implements Insertable<SwingSession> {
  final String id;
  final String userId;
  final SessionMode mode;
  final Source source;
  final DateTime startedAt;
  final DateTime? endedAt;
  final ClubType? clubType;
  final int? clubNumber;
  final CameraAngle cameraAngle;
  final Handedness handednessSnapshot;
  final Subject defaultSubject;
  final int? plannedSwingCount;
  final FeedbackTiming feedbackTiming;
  final int? feedbackDisplaySeconds;
  final int? timerSeconds;
  final int? requestedFps;
  final SessionStatus status;
  final String? note;
  const SwingSession({
    required this.id,
    required this.userId,
    required this.mode,
    required this.source,
    required this.startedAt,
    this.endedAt,
    this.clubType,
    this.clubNumber,
    required this.cameraAngle,
    required this.handednessSnapshot,
    required this.defaultSubject,
    this.plannedSwingCount,
    required this.feedbackTiming,
    this.feedbackDisplaySeconds,
    this.timerSeconds,
    this.requestedFps,
    required this.status,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    {
      map['mode'] = Variable<String>(
        $SwingSessionsTable.$convertermode.toSql(mode),
      );
    }
    {
      map['source'] = Variable<String>(
        $SwingSessionsTable.$convertersource.toSql(source),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || clubType != null) {
      map['club_type'] = Variable<String>(
        $SwingSessionsTable.$converterclubTypen.toSql(clubType),
      );
    }
    if (!nullToAbsent || clubNumber != null) {
      map['club_number'] = Variable<int>(clubNumber);
    }
    {
      map['camera_angle'] = Variable<String>(
        $SwingSessionsTable.$convertercameraAngle.toSql(cameraAngle),
      );
    }
    {
      map['handedness_snapshot'] = Variable<String>(
        $SwingSessionsTable.$converterhandednessSnapshot.toSql(
          handednessSnapshot,
        ),
      );
    }
    {
      map['default_subject'] = Variable<String>(
        $SwingSessionsTable.$converterdefaultSubject.toSql(defaultSubject),
      );
    }
    if (!nullToAbsent || plannedSwingCount != null) {
      map['planned_swing_count'] = Variable<int>(plannedSwingCount);
    }
    {
      map['feedback_timing'] = Variable<String>(
        $SwingSessionsTable.$converterfeedbackTiming.toSql(feedbackTiming),
      );
    }
    if (!nullToAbsent || feedbackDisplaySeconds != null) {
      map['feedback_display_seconds'] = Variable<int>(feedbackDisplaySeconds);
    }
    if (!nullToAbsent || timerSeconds != null) {
      map['timer_seconds'] = Variable<int>(timerSeconds);
    }
    if (!nullToAbsent || requestedFps != null) {
      map['requested_fps'] = Variable<int>(requestedFps);
    }
    {
      map['status'] = Variable<String>(
        $SwingSessionsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SwingSessionsCompanion toCompanion(bool nullToAbsent) {
    return SwingSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      mode: Value(mode),
      source: Value(source),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      clubType: clubType == null && nullToAbsent
          ? const Value.absent()
          : Value(clubType),
      clubNumber: clubNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(clubNumber),
      cameraAngle: Value(cameraAngle),
      handednessSnapshot: Value(handednessSnapshot),
      defaultSubject: Value(defaultSubject),
      plannedSwingCount: plannedSwingCount == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedSwingCount),
      feedbackTiming: Value(feedbackTiming),
      feedbackDisplaySeconds: feedbackDisplaySeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(feedbackDisplaySeconds),
      timerSeconds: timerSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(timerSeconds),
      requestedFps: requestedFps == null && nullToAbsent
          ? const Value.absent()
          : Value(requestedFps),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SwingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SwingSession(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      mode: serializer.fromJson<SessionMode>(json['mode']),
      source: serializer.fromJson<Source>(json['source']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      clubType: serializer.fromJson<ClubType?>(json['clubType']),
      clubNumber: serializer.fromJson<int?>(json['clubNumber']),
      cameraAngle: serializer.fromJson<CameraAngle>(json['cameraAngle']),
      handednessSnapshot: serializer.fromJson<Handedness>(
        json['handednessSnapshot'],
      ),
      defaultSubject: serializer.fromJson<Subject>(json['defaultSubject']),
      plannedSwingCount: serializer.fromJson<int?>(json['plannedSwingCount']),
      feedbackTiming: serializer.fromJson<FeedbackTiming>(
        json['feedbackTiming'],
      ),
      feedbackDisplaySeconds: serializer.fromJson<int?>(
        json['feedbackDisplaySeconds'],
      ),
      timerSeconds: serializer.fromJson<int?>(json['timerSeconds']),
      requestedFps: serializer.fromJson<int?>(json['requestedFps']),
      status: serializer.fromJson<SessionStatus>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'mode': serializer.toJson<SessionMode>(mode),
      'source': serializer.toJson<Source>(source),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'clubType': serializer.toJson<ClubType?>(clubType),
      'clubNumber': serializer.toJson<int?>(clubNumber),
      'cameraAngle': serializer.toJson<CameraAngle>(cameraAngle),
      'handednessSnapshot': serializer.toJson<Handedness>(handednessSnapshot),
      'defaultSubject': serializer.toJson<Subject>(defaultSubject),
      'plannedSwingCount': serializer.toJson<int?>(plannedSwingCount),
      'feedbackTiming': serializer.toJson<FeedbackTiming>(feedbackTiming),
      'feedbackDisplaySeconds': serializer.toJson<int?>(feedbackDisplaySeconds),
      'timerSeconds': serializer.toJson<int?>(timerSeconds),
      'requestedFps': serializer.toJson<int?>(requestedFps),
      'status': serializer.toJson<SessionStatus>(status),
      'note': serializer.toJson<String?>(note),
    };
  }

  SwingSession copyWith({
    String? id,
    String? userId,
    SessionMode? mode,
    Source? source,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<ClubType?> clubType = const Value.absent(),
    Value<int?> clubNumber = const Value.absent(),
    CameraAngle? cameraAngle,
    Handedness? handednessSnapshot,
    Subject? defaultSubject,
    Value<int?> plannedSwingCount = const Value.absent(),
    FeedbackTiming? feedbackTiming,
    Value<int?> feedbackDisplaySeconds = const Value.absent(),
    Value<int?> timerSeconds = const Value.absent(),
    Value<int?> requestedFps = const Value.absent(),
    SessionStatus? status,
    Value<String?> note = const Value.absent(),
  }) => SwingSession(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    mode: mode ?? this.mode,
    source: source ?? this.source,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    clubType: clubType.present ? clubType.value : this.clubType,
    clubNumber: clubNumber.present ? clubNumber.value : this.clubNumber,
    cameraAngle: cameraAngle ?? this.cameraAngle,
    handednessSnapshot: handednessSnapshot ?? this.handednessSnapshot,
    defaultSubject: defaultSubject ?? this.defaultSubject,
    plannedSwingCount: plannedSwingCount.present
        ? plannedSwingCount.value
        : this.plannedSwingCount,
    feedbackTiming: feedbackTiming ?? this.feedbackTiming,
    feedbackDisplaySeconds: feedbackDisplaySeconds.present
        ? feedbackDisplaySeconds.value
        : this.feedbackDisplaySeconds,
    timerSeconds: timerSeconds.present ? timerSeconds.value : this.timerSeconds,
    requestedFps: requestedFps.present ? requestedFps.value : this.requestedFps,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
  );
  SwingSession copyWithCompanion(SwingSessionsCompanion data) {
    return SwingSession(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      mode: data.mode.present ? data.mode.value : this.mode,
      source: data.source.present ? data.source.value : this.source,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      clubType: data.clubType.present ? data.clubType.value : this.clubType,
      clubNumber: data.clubNumber.present
          ? data.clubNumber.value
          : this.clubNumber,
      cameraAngle: data.cameraAngle.present
          ? data.cameraAngle.value
          : this.cameraAngle,
      handednessSnapshot: data.handednessSnapshot.present
          ? data.handednessSnapshot.value
          : this.handednessSnapshot,
      defaultSubject: data.defaultSubject.present
          ? data.defaultSubject.value
          : this.defaultSubject,
      plannedSwingCount: data.plannedSwingCount.present
          ? data.plannedSwingCount.value
          : this.plannedSwingCount,
      feedbackTiming: data.feedbackTiming.present
          ? data.feedbackTiming.value
          : this.feedbackTiming,
      feedbackDisplaySeconds: data.feedbackDisplaySeconds.present
          ? data.feedbackDisplaySeconds.value
          : this.feedbackDisplaySeconds,
      timerSeconds: data.timerSeconds.present
          ? data.timerSeconds.value
          : this.timerSeconds,
      requestedFps: data.requestedFps.present
          ? data.requestedFps.value
          : this.requestedFps,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SwingSession(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('mode: $mode, ')
          ..write('source: $source, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('clubType: $clubType, ')
          ..write('clubNumber: $clubNumber, ')
          ..write('cameraAngle: $cameraAngle, ')
          ..write('handednessSnapshot: $handednessSnapshot, ')
          ..write('defaultSubject: $defaultSubject, ')
          ..write('plannedSwingCount: $plannedSwingCount, ')
          ..write('feedbackTiming: $feedbackTiming, ')
          ..write('feedbackDisplaySeconds: $feedbackDisplaySeconds, ')
          ..write('timerSeconds: $timerSeconds, ')
          ..write('requestedFps: $requestedFps, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    mode,
    source,
    startedAt,
    endedAt,
    clubType,
    clubNumber,
    cameraAngle,
    handednessSnapshot,
    defaultSubject,
    plannedSwingCount,
    feedbackTiming,
    feedbackDisplaySeconds,
    timerSeconds,
    requestedFps,
    status,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SwingSession &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.mode == this.mode &&
          other.source == this.source &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.clubType == this.clubType &&
          other.clubNumber == this.clubNumber &&
          other.cameraAngle == this.cameraAngle &&
          other.handednessSnapshot == this.handednessSnapshot &&
          other.defaultSubject == this.defaultSubject &&
          other.plannedSwingCount == this.plannedSwingCount &&
          other.feedbackTiming == this.feedbackTiming &&
          other.feedbackDisplaySeconds == this.feedbackDisplaySeconds &&
          other.timerSeconds == this.timerSeconds &&
          other.requestedFps == this.requestedFps &&
          other.status == this.status &&
          other.note == this.note);
}

class SwingSessionsCompanion extends UpdateCompanion<SwingSession> {
  final Value<String> id;
  final Value<String> userId;
  final Value<SessionMode> mode;
  final Value<Source> source;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<ClubType?> clubType;
  final Value<int?> clubNumber;
  final Value<CameraAngle> cameraAngle;
  final Value<Handedness> handednessSnapshot;
  final Value<Subject> defaultSubject;
  final Value<int?> plannedSwingCount;
  final Value<FeedbackTiming> feedbackTiming;
  final Value<int?> feedbackDisplaySeconds;
  final Value<int?> timerSeconds;
  final Value<int?> requestedFps;
  final Value<SessionStatus> status;
  final Value<String?> note;
  final Value<int> rowid;
  const SwingSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.mode = const Value.absent(),
    this.source = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.clubType = const Value.absent(),
    this.clubNumber = const Value.absent(),
    this.cameraAngle = const Value.absent(),
    this.handednessSnapshot = const Value.absent(),
    this.defaultSubject = const Value.absent(),
    this.plannedSwingCount = const Value.absent(),
    this.feedbackTiming = const Value.absent(),
    this.feedbackDisplaySeconds = const Value.absent(),
    this.timerSeconds = const Value.absent(),
    this.requestedFps = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SwingSessionsCompanion.insert({
    required String id,
    required String userId,
    required SessionMode mode,
    required Source source,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.clubType = const Value.absent(),
    this.clubNumber = const Value.absent(),
    required CameraAngle cameraAngle,
    required Handedness handednessSnapshot,
    required Subject defaultSubject,
    this.plannedSwingCount = const Value.absent(),
    required FeedbackTiming feedbackTiming,
    this.feedbackDisplaySeconds = const Value.absent(),
    this.timerSeconds = const Value.absent(),
    this.requestedFps = const Value.absent(),
    required SessionStatus status,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       mode = Value(mode),
       source = Value(source),
       startedAt = Value(startedAt),
       cameraAngle = Value(cameraAngle),
       handednessSnapshot = Value(handednessSnapshot),
       defaultSubject = Value(defaultSubject),
       feedbackTiming = Value(feedbackTiming),
       status = Value(status);
  static Insertable<SwingSession> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? mode,
    Expression<String>? source,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? clubType,
    Expression<int>? clubNumber,
    Expression<String>? cameraAngle,
    Expression<String>? handednessSnapshot,
    Expression<String>? defaultSubject,
    Expression<int>? plannedSwingCount,
    Expression<String>? feedbackTiming,
    Expression<int>? feedbackDisplaySeconds,
    Expression<int>? timerSeconds,
    Expression<int>? requestedFps,
    Expression<String>? status,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (mode != null) 'mode': mode,
      if (source != null) 'source': source,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (clubType != null) 'club_type': clubType,
      if (clubNumber != null) 'club_number': clubNumber,
      if (cameraAngle != null) 'camera_angle': cameraAngle,
      if (handednessSnapshot != null) 'handedness_snapshot': handednessSnapshot,
      if (defaultSubject != null) 'default_subject': defaultSubject,
      if (plannedSwingCount != null) 'planned_swing_count': plannedSwingCount,
      if (feedbackTiming != null) 'feedback_timing': feedbackTiming,
      if (feedbackDisplaySeconds != null)
        'feedback_display_seconds': feedbackDisplaySeconds,
      if (timerSeconds != null) 'timer_seconds': timerSeconds,
      if (requestedFps != null) 'requested_fps': requestedFps,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SwingSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<SessionMode>? mode,
    Value<Source>? source,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<ClubType?>? clubType,
    Value<int?>? clubNumber,
    Value<CameraAngle>? cameraAngle,
    Value<Handedness>? handednessSnapshot,
    Value<Subject>? defaultSubject,
    Value<int?>? plannedSwingCount,
    Value<FeedbackTiming>? feedbackTiming,
    Value<int?>? feedbackDisplaySeconds,
    Value<int?>? timerSeconds,
    Value<int?>? requestedFps,
    Value<SessionStatus>? status,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return SwingSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mode: mode ?? this.mode,
      source: source ?? this.source,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      clubType: clubType ?? this.clubType,
      clubNumber: clubNumber ?? this.clubNumber,
      cameraAngle: cameraAngle ?? this.cameraAngle,
      handednessSnapshot: handednessSnapshot ?? this.handednessSnapshot,
      defaultSubject: defaultSubject ?? this.defaultSubject,
      plannedSwingCount: plannedSwingCount ?? this.plannedSwingCount,
      feedbackTiming: feedbackTiming ?? this.feedbackTiming,
      feedbackDisplaySeconds:
          feedbackDisplaySeconds ?? this.feedbackDisplaySeconds,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      requestedFps: requestedFps ?? this.requestedFps,
      status: status ?? this.status,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(
        $SwingSessionsTable.$convertermode.toSql(mode.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $SwingSessionsTable.$convertersource.toSql(source.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (clubType.present) {
      map['club_type'] = Variable<String>(
        $SwingSessionsTable.$converterclubTypen.toSql(clubType.value),
      );
    }
    if (clubNumber.present) {
      map['club_number'] = Variable<int>(clubNumber.value);
    }
    if (cameraAngle.present) {
      map['camera_angle'] = Variable<String>(
        $SwingSessionsTable.$convertercameraAngle.toSql(cameraAngle.value),
      );
    }
    if (handednessSnapshot.present) {
      map['handedness_snapshot'] = Variable<String>(
        $SwingSessionsTable.$converterhandednessSnapshot.toSql(
          handednessSnapshot.value,
        ),
      );
    }
    if (defaultSubject.present) {
      map['default_subject'] = Variable<String>(
        $SwingSessionsTable.$converterdefaultSubject.toSql(
          defaultSubject.value,
        ),
      );
    }
    if (plannedSwingCount.present) {
      map['planned_swing_count'] = Variable<int>(plannedSwingCount.value);
    }
    if (feedbackTiming.present) {
      map['feedback_timing'] = Variable<String>(
        $SwingSessionsTable.$converterfeedbackTiming.toSql(
          feedbackTiming.value,
        ),
      );
    }
    if (feedbackDisplaySeconds.present) {
      map['feedback_display_seconds'] = Variable<int>(
        feedbackDisplaySeconds.value,
      );
    }
    if (timerSeconds.present) {
      map['timer_seconds'] = Variable<int>(timerSeconds.value);
    }
    if (requestedFps.present) {
      map['requested_fps'] = Variable<int>(requestedFps.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SwingSessionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SwingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('mode: $mode, ')
          ..write('source: $source, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('clubType: $clubType, ')
          ..write('clubNumber: $clubNumber, ')
          ..write('cameraAngle: $cameraAngle, ')
          ..write('handednessSnapshot: $handednessSnapshot, ')
          ..write('defaultSubject: $defaultSubject, ')
          ..write('plannedSwingCount: $plannedSwingCount, ')
          ..write('feedbackTiming: $feedbackTiming, ')
          ..write('feedbackDisplaySeconds: $feedbackDisplaySeconds, ')
          ..write('timerSeconds: $timerSeconds, ')
          ..write('requestedFps: $requestedFps, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SwingsTable extends Swings with TableInfo<$SwingsTable, Swing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SwingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES swing_sessions (id)',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Subject, String> subject =
      GeneratedColumn<String>(
        'subject',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Subject>($SwingsTable.$convertersubject);
  static const VerificationMeta _includeInStatsMeta = const VerificationMeta(
    'includeInStats',
  );
  @override
  late final GeneratedColumn<bool> includeInStats = GeneratedColumn<bool>(
    'include_in_stats',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("include_in_stats" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppPlatform, String> platform =
      GeneratedColumn<String>(
        'platform',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AppPlatform>($SwingsTable.$converterplatform);
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceAssetIdMeta = const VerificationMeta(
    'sourceAssetId',
  );
  @override
  late final GeneratedColumn<String> sourceAssetId = GeneratedColumn<String>(
    'source_asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualFpsMeta = const VerificationMeta(
    'actualFps',
  );
  @override
  late final GeneratedColumn<double> actualFps = GeneratedColumn<double>(
    'actual_fps',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotationDegreesMeta = const VerificationMeta(
    'rotationDegrees',
  );
  @override
  late final GeneratedColumn<int> rotationDegrees = GeneratedColumn<int>(
    'rotation_degrees',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QualityLevel?, String>
  qualityLevel = GeneratedColumn<String>(
    'quality_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<QualityLevel?>($SwingsTable.$converterqualityLeveln);
  @override
  late final GeneratedColumnWithTypeConverter<List<QualityIssue>, String>
  qualityIssues = GeneratedColumn<String>(
    'quality_issues',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<QualityIssue>>($SwingsTable.$converterqualityIssues);
  static const VerificationMeta _uploadStatusMeta = const VerificationMeta(
    'uploadStatus',
  );
  @override
  late final GeneratedColumn<String> uploadStatus = GeneratedColumn<String>(
    'upload_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local_only'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    orderIndex,
    subject,
    includeInStats,
    isFavorite,
    note,
    platform,
    localFilePath,
    sourceAssetId,
    thumbnailPath,
    durationMs,
    width,
    height,
    fileSizeBytes,
    actualFps,
    rotationDegrees,
    qualityLevel,
    qualityIssues,
    uploadStatus,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'swings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Swing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('include_in_stats')) {
      context.handle(
        _includeInStatsMeta,
        includeInStats.isAcceptableOrUnknown(
          data['include_in_stats']!,
          _includeInStatsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_includeInStatsMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localFilePathMeta);
    }
    if (data.containsKey('source_asset_id')) {
      context.handle(
        _sourceAssetIdMeta,
        sourceAssetId.isAcceptableOrUnknown(
          data['source_asset_id']!,
          _sourceAssetIdMeta,
        ),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fileSizeBytesMeta);
    }
    if (data.containsKey('actual_fps')) {
      context.handle(
        _actualFpsMeta,
        actualFps.isAcceptableOrUnknown(data['actual_fps']!, _actualFpsMeta),
      );
    } else if (isInserting) {
      context.missing(_actualFpsMeta);
    }
    if (data.containsKey('rotation_degrees')) {
      context.handle(
        _rotationDegreesMeta,
        rotationDegrees.isAcceptableOrUnknown(
          data['rotation_degrees']!,
          _rotationDegreesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rotationDegreesMeta);
    }
    if (data.containsKey('upload_status')) {
      context.handle(
        _uploadStatusMeta,
        uploadStatus.isAcceptableOrUnknown(
          data['upload_status']!,
          _uploadStatusMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Swing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Swing(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      subject: $SwingsTable.$convertersubject.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}subject'],
        )!,
      ),
      includeInStats: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}include_in_stats'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      platform: $SwingsTable.$converterplatform.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}platform'],
        )!,
      ),
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      )!,
      sourceAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_asset_id'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      )!,
      actualFps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_fps'],
      )!,
      rotationDegrees: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rotation_degrees'],
      )!,
      qualityLevel: $SwingsTable.$converterqualityLeveln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}quality_level'],
        ),
      ),
      qualityIssues: $SwingsTable.$converterqualityIssues.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}quality_issues'],
        )!,
      ),
      uploadStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upload_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SwingsTable createAlias(String alias) {
    return $SwingsTable(attachedDatabase, alias);
  }

  static TypeConverter<Subject, String> $convertersubject = const WireConverter(
    Subject.values,
  );
  static TypeConverter<AppPlatform, String> $converterplatform =
      const WireConverter(AppPlatform.values);
  static TypeConverter<QualityLevel, String> $converterqualityLevel =
      const WireConverter(QualityLevel.values);
  static TypeConverter<QualityLevel?, String?> $converterqualityLeveln =
      NullAwareTypeConverter.wrap($converterqualityLevel);
  static TypeConverter<List<QualityIssue>, String> $converterqualityIssues =
      const WireListConverter(QualityIssue.values);
}

class Swing extends DataClass implements Insertable<Swing> {
  final String id;
  final String sessionId;
  final int orderIndex;
  final Subject subject;
  final bool includeInStats;
  final bool isFavorite;
  final String? note;
  final AppPlatform platform;

  /// Relative to the app documents directory.
  final String localFilePath;
  final String? sourceAssetId;
  final String? thumbnailPath;
  final int durationMs;
  final int width;
  final int height;
  final int fileSizeBytes;
  final double actualFps;
  final int rotationDegrees;
  final QualityLevel? qualityLevel;
  final List<QualityIssue> qualityIssues;
  final String uploadStatus;
  final DateTime createdAt;
  const Swing({
    required this.id,
    required this.sessionId,
    required this.orderIndex,
    required this.subject,
    required this.includeInStats,
    required this.isFavorite,
    this.note,
    required this.platform,
    required this.localFilePath,
    this.sourceAssetId,
    this.thumbnailPath,
    required this.durationMs,
    required this.width,
    required this.height,
    required this.fileSizeBytes,
    required this.actualFps,
    required this.rotationDegrees,
    this.qualityLevel,
    required this.qualityIssues,
    required this.uploadStatus,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['order_index'] = Variable<int>(orderIndex);
    {
      map['subject'] = Variable<String>(
        $SwingsTable.$convertersubject.toSql(subject),
      );
    }
    map['include_in_stats'] = Variable<bool>(includeInStats);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['platform'] = Variable<String>(
        $SwingsTable.$converterplatform.toSql(platform),
      );
    }
    map['local_file_path'] = Variable<String>(localFilePath);
    if (!nullToAbsent || sourceAssetId != null) {
      map['source_asset_id'] = Variable<String>(sourceAssetId);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    map['duration_ms'] = Variable<int>(durationMs);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    map['actual_fps'] = Variable<double>(actualFps);
    map['rotation_degrees'] = Variable<int>(rotationDegrees);
    if (!nullToAbsent || qualityLevel != null) {
      map['quality_level'] = Variable<String>(
        $SwingsTable.$converterqualityLeveln.toSql(qualityLevel),
      );
    }
    {
      map['quality_issues'] = Variable<String>(
        $SwingsTable.$converterqualityIssues.toSql(qualityIssues),
      );
    }
    map['upload_status'] = Variable<String>(uploadStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SwingsCompanion toCompanion(bool nullToAbsent) {
    return SwingsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      orderIndex: Value(orderIndex),
      subject: Value(subject),
      includeInStats: Value(includeInStats),
      isFavorite: Value(isFavorite),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      platform: Value(platform),
      localFilePath: Value(localFilePath),
      sourceAssetId: sourceAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceAssetId),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      durationMs: Value(durationMs),
      width: Value(width),
      height: Value(height),
      fileSizeBytes: Value(fileSizeBytes),
      actualFps: Value(actualFps),
      rotationDegrees: Value(rotationDegrees),
      qualityLevel: qualityLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(qualityLevel),
      qualityIssues: Value(qualityIssues),
      uploadStatus: Value(uploadStatus),
      createdAt: Value(createdAt),
    );
  }

  factory Swing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Swing(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      subject: serializer.fromJson<Subject>(json['subject']),
      includeInStats: serializer.fromJson<bool>(json['includeInStats']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      note: serializer.fromJson<String?>(json['note']),
      platform: serializer.fromJson<AppPlatform>(json['platform']),
      localFilePath: serializer.fromJson<String>(json['localFilePath']),
      sourceAssetId: serializer.fromJson<String?>(json['sourceAssetId']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      fileSizeBytes: serializer.fromJson<int>(json['fileSizeBytes']),
      actualFps: serializer.fromJson<double>(json['actualFps']),
      rotationDegrees: serializer.fromJson<int>(json['rotationDegrees']),
      qualityLevel: serializer.fromJson<QualityLevel?>(json['qualityLevel']),
      qualityIssues: serializer.fromJson<List<QualityIssue>>(
        json['qualityIssues'],
      ),
      uploadStatus: serializer.fromJson<String>(json['uploadStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'subject': serializer.toJson<Subject>(subject),
      'includeInStats': serializer.toJson<bool>(includeInStats),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'note': serializer.toJson<String?>(note),
      'platform': serializer.toJson<AppPlatform>(platform),
      'localFilePath': serializer.toJson<String>(localFilePath),
      'sourceAssetId': serializer.toJson<String?>(sourceAssetId),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'durationMs': serializer.toJson<int>(durationMs),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'fileSizeBytes': serializer.toJson<int>(fileSizeBytes),
      'actualFps': serializer.toJson<double>(actualFps),
      'rotationDegrees': serializer.toJson<int>(rotationDegrees),
      'qualityLevel': serializer.toJson<QualityLevel?>(qualityLevel),
      'qualityIssues': serializer.toJson<List<QualityIssue>>(qualityIssues),
      'uploadStatus': serializer.toJson<String>(uploadStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Swing copyWith({
    String? id,
    String? sessionId,
    int? orderIndex,
    Subject? subject,
    bool? includeInStats,
    bool? isFavorite,
    Value<String?> note = const Value.absent(),
    AppPlatform? platform,
    String? localFilePath,
    Value<String?> sourceAssetId = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    int? durationMs,
    int? width,
    int? height,
    int? fileSizeBytes,
    double? actualFps,
    int? rotationDegrees,
    Value<QualityLevel?> qualityLevel = const Value.absent(),
    List<QualityIssue>? qualityIssues,
    String? uploadStatus,
    DateTime? createdAt,
  }) => Swing(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    orderIndex: orderIndex ?? this.orderIndex,
    subject: subject ?? this.subject,
    includeInStats: includeInStats ?? this.includeInStats,
    isFavorite: isFavorite ?? this.isFavorite,
    note: note.present ? note.value : this.note,
    platform: platform ?? this.platform,
    localFilePath: localFilePath ?? this.localFilePath,
    sourceAssetId: sourceAssetId.present
        ? sourceAssetId.value
        : this.sourceAssetId,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    durationMs: durationMs ?? this.durationMs,
    width: width ?? this.width,
    height: height ?? this.height,
    fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    actualFps: actualFps ?? this.actualFps,
    rotationDegrees: rotationDegrees ?? this.rotationDegrees,
    qualityLevel: qualityLevel.present ? qualityLevel.value : this.qualityLevel,
    qualityIssues: qualityIssues ?? this.qualityIssues,
    uploadStatus: uploadStatus ?? this.uploadStatus,
    createdAt: createdAt ?? this.createdAt,
  );
  Swing copyWithCompanion(SwingsCompanion data) {
    return Swing(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      subject: data.subject.present ? data.subject.value : this.subject,
      includeInStats: data.includeInStats.present
          ? data.includeInStats.value
          : this.includeInStats,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      note: data.note.present ? data.note.value : this.note,
      platform: data.platform.present ? data.platform.value : this.platform,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      sourceAssetId: data.sourceAssetId.present
          ? data.sourceAssetId.value
          : this.sourceAssetId,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      actualFps: data.actualFps.present ? data.actualFps.value : this.actualFps,
      rotationDegrees: data.rotationDegrees.present
          ? data.rotationDegrees.value
          : this.rotationDegrees,
      qualityLevel: data.qualityLevel.present
          ? data.qualityLevel.value
          : this.qualityLevel,
      qualityIssues: data.qualityIssues.present
          ? data.qualityIssues.value
          : this.qualityIssues,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Swing(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('subject: $subject, ')
          ..write('includeInStats: $includeInStats, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('note: $note, ')
          ..write('platform: $platform, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('sourceAssetId: $sourceAssetId, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('actualFps: $actualFps, ')
          ..write('rotationDegrees: $rotationDegrees, ')
          ..write('qualityLevel: $qualityLevel, ')
          ..write('qualityIssues: $qualityIssues, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    sessionId,
    orderIndex,
    subject,
    includeInStats,
    isFavorite,
    note,
    platform,
    localFilePath,
    sourceAssetId,
    thumbnailPath,
    durationMs,
    width,
    height,
    fileSizeBytes,
    actualFps,
    rotationDegrees,
    qualityLevel,
    qualityIssues,
    uploadStatus,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Swing &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.orderIndex == this.orderIndex &&
          other.subject == this.subject &&
          other.includeInStats == this.includeInStats &&
          other.isFavorite == this.isFavorite &&
          other.note == this.note &&
          other.platform == this.platform &&
          other.localFilePath == this.localFilePath &&
          other.sourceAssetId == this.sourceAssetId &&
          other.thumbnailPath == this.thumbnailPath &&
          other.durationMs == this.durationMs &&
          other.width == this.width &&
          other.height == this.height &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.actualFps == this.actualFps &&
          other.rotationDegrees == this.rotationDegrees &&
          other.qualityLevel == this.qualityLevel &&
          other.qualityIssues == this.qualityIssues &&
          other.uploadStatus == this.uploadStatus &&
          other.createdAt == this.createdAt);
}

class SwingsCompanion extends UpdateCompanion<Swing> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<int> orderIndex;
  final Value<Subject> subject;
  final Value<bool> includeInStats;
  final Value<bool> isFavorite;
  final Value<String?> note;
  final Value<AppPlatform> platform;
  final Value<String> localFilePath;
  final Value<String?> sourceAssetId;
  final Value<String?> thumbnailPath;
  final Value<int> durationMs;
  final Value<int> width;
  final Value<int> height;
  final Value<int> fileSizeBytes;
  final Value<double> actualFps;
  final Value<int> rotationDegrees;
  final Value<QualityLevel?> qualityLevel;
  final Value<List<QualityIssue>> qualityIssues;
  final Value<String> uploadStatus;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SwingsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.subject = const Value.absent(),
    this.includeInStats = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.note = const Value.absent(),
    this.platform = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.sourceAssetId = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.actualFps = const Value.absent(),
    this.rotationDegrees = const Value.absent(),
    this.qualityLevel = const Value.absent(),
    this.qualityIssues = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SwingsCompanion.insert({
    required String id,
    required String sessionId,
    required int orderIndex,
    required Subject subject,
    required bool includeInStats,
    this.isFavorite = const Value.absent(),
    this.note = const Value.absent(),
    required AppPlatform platform,
    required String localFilePath,
    this.sourceAssetId = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    required int durationMs,
    required int width,
    required int height,
    required int fileSizeBytes,
    required double actualFps,
    required int rotationDegrees,
    this.qualityLevel = const Value.absent(),
    required List<QualityIssue> qualityIssues,
    this.uploadStatus = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       orderIndex = Value(orderIndex),
       subject = Value(subject),
       includeInStats = Value(includeInStats),
       platform = Value(platform),
       localFilePath = Value(localFilePath),
       durationMs = Value(durationMs),
       width = Value(width),
       height = Value(height),
       fileSizeBytes = Value(fileSizeBytes),
       actualFps = Value(actualFps),
       rotationDegrees = Value(rotationDegrees),
       qualityIssues = Value(qualityIssues),
       createdAt = Value(createdAt);
  static Insertable<Swing> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? orderIndex,
    Expression<String>? subject,
    Expression<bool>? includeInStats,
    Expression<bool>? isFavorite,
    Expression<String>? note,
    Expression<String>? platform,
    Expression<String>? localFilePath,
    Expression<String>? sourceAssetId,
    Expression<String>? thumbnailPath,
    Expression<int>? durationMs,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? fileSizeBytes,
    Expression<double>? actualFps,
    Expression<int>? rotationDegrees,
    Expression<String>? qualityLevel,
    Expression<String>? qualityIssues,
    Expression<String>? uploadStatus,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (subject != null) 'subject': subject,
      if (includeInStats != null) 'include_in_stats': includeInStats,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (note != null) 'note': note,
      if (platform != null) 'platform': platform,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (sourceAssetId != null) 'source_asset_id': sourceAssetId,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (actualFps != null) 'actual_fps': actualFps,
      if (rotationDegrees != null) 'rotation_degrees': rotationDegrees,
      if (qualityLevel != null) 'quality_level': qualityLevel,
      if (qualityIssues != null) 'quality_issues': qualityIssues,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SwingsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<int>? orderIndex,
    Value<Subject>? subject,
    Value<bool>? includeInStats,
    Value<bool>? isFavorite,
    Value<String?>? note,
    Value<AppPlatform>? platform,
    Value<String>? localFilePath,
    Value<String?>? sourceAssetId,
    Value<String?>? thumbnailPath,
    Value<int>? durationMs,
    Value<int>? width,
    Value<int>? height,
    Value<int>? fileSizeBytes,
    Value<double>? actualFps,
    Value<int>? rotationDegrees,
    Value<QualityLevel?>? qualityLevel,
    Value<List<QualityIssue>>? qualityIssues,
    Value<String>? uploadStatus,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SwingsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      orderIndex: orderIndex ?? this.orderIndex,
      subject: subject ?? this.subject,
      includeInStats: includeInStats ?? this.includeInStats,
      isFavorite: isFavorite ?? this.isFavorite,
      note: note ?? this.note,
      platform: platform ?? this.platform,
      localFilePath: localFilePath ?? this.localFilePath,
      sourceAssetId: sourceAssetId ?? this.sourceAssetId,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      durationMs: durationMs ?? this.durationMs,
      width: width ?? this.width,
      height: height ?? this.height,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      actualFps: actualFps ?? this.actualFps,
      rotationDegrees: rotationDegrees ?? this.rotationDegrees,
      qualityLevel: qualityLevel ?? this.qualityLevel,
      qualityIssues: qualityIssues ?? this.qualityIssues,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(
        $SwingsTable.$convertersubject.toSql(subject.value),
      );
    }
    if (includeInStats.present) {
      map['include_in_stats'] = Variable<bool>(includeInStats.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(
        $SwingsTable.$converterplatform.toSql(platform.value),
      );
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (sourceAssetId.present) {
      map['source_asset_id'] = Variable<String>(sourceAssetId.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (actualFps.present) {
      map['actual_fps'] = Variable<double>(actualFps.value);
    }
    if (rotationDegrees.present) {
      map['rotation_degrees'] = Variable<int>(rotationDegrees.value);
    }
    if (qualityLevel.present) {
      map['quality_level'] = Variable<String>(
        $SwingsTable.$converterqualityLeveln.toSql(qualityLevel.value),
      );
    }
    if (qualityIssues.present) {
      map['quality_issues'] = Variable<String>(
        $SwingsTable.$converterqualityIssues.toSql(qualityIssues.value),
      );
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(uploadStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SwingsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('subject: $subject, ')
          ..write('includeInStats: $includeInStats, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('note: $note, ')
          ..write('platform: $platform, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('sourceAssetId: $sourceAssetId, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('actualFps: $actualFps, ')
          ..write('rotationDegrees: $rotationDegrees, ')
          ..write('qualityLevel: $qualityLevel, ')
          ..write('qualityIssues: $qualityIssues, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SwingAnalysesTable extends SwingAnalyses
    with TableInfo<$SwingAnalysesTable, SwingAnalysis> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SwingAnalysesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _swingIdMeta = const VerificationMeta(
    'swingId',
  );
  @override
  late final GeneratedColumn<String> swingId = GeneratedColumn<String>(
    'swing_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES swings (id)',
    ),
  );
  static const VerificationMeta _modelVersionMeta = const VerificationMeta(
    'modelVersion',
  );
  @override
  late final GeneratedColumn<String> modelVersion = GeneratedColumn<String>(
    'model_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<String> schemaVersion = GeneratedColumn<String>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AnalysisStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AnalysisStatus>($SwingAnalysesTable.$converterstatus);
  static const VerificationMeta _isCurrentMeta = const VerificationMeta(
    'isCurrent',
  );
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
    'is_current',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_current" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mirroredMeta = const VerificationMeta(
    'mirrored',
  );
  @override
  late final GeneratedColumn<bool> mirrored = GeneratedColumn<bool>(
    'mirrored',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mirrored" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _keypointsFilePathMeta = const VerificationMeta(
    'keypointsFilePath',
  );
  @override
  late final GeneratedColumn<String> keypointsFilePath =
      GeneratedColumn<String>(
        'keypoints_file_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _phasesJsonMeta = const VerificationMeta(
    'phasesJson',
  );
  @override
  late final GeneratedColumn<String> phasesJson = GeneratedColumn<String>(
    'phases_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempoJsonMeta = const VerificationMeta(
    'tempoJson',
  );
  @override
  late final GeneratedColumn<String> tempoJson = GeneratedColumn<String>(
    'tempo_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _limitationKeysMeta = const VerificationMeta(
    'limitationKeys',
  );
  @override
  late final GeneratedColumn<String> limitationKeys = GeneratedColumn<String>(
    'limitation_keys',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    swingId,
    modelVersion,
    schemaVersion,
    status,
    isCurrent,
    mirrored,
    keypointsFilePath,
    phasesJson,
    tempoJson,
    limitationKeys,
    errorCode,
    createdAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'swing_analyses';
  @override
  VerificationContext validateIntegrity(
    Insertable<SwingAnalysis> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('swing_id')) {
      context.handle(
        _swingIdMeta,
        swingId.isAcceptableOrUnknown(data['swing_id']!, _swingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_swingIdMeta);
    }
    if (data.containsKey('model_version')) {
      context.handle(
        _modelVersionMeta,
        modelVersion.isAcceptableOrUnknown(
          data['model_version']!,
          _modelVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelVersionMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('is_current')) {
      context.handle(
        _isCurrentMeta,
        isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta),
      );
    }
    if (data.containsKey('mirrored')) {
      context.handle(
        _mirroredMeta,
        mirrored.isAcceptableOrUnknown(data['mirrored']!, _mirroredMeta),
      );
    }
    if (data.containsKey('keypoints_file_path')) {
      context.handle(
        _keypointsFilePathMeta,
        keypointsFilePath.isAcceptableOrUnknown(
          data['keypoints_file_path']!,
          _keypointsFilePathMeta,
        ),
      );
    }
    if (data.containsKey('phases_json')) {
      context.handle(
        _phasesJsonMeta,
        phasesJson.isAcceptableOrUnknown(data['phases_json']!, _phasesJsonMeta),
      );
    }
    if (data.containsKey('tempo_json')) {
      context.handle(
        _tempoJsonMeta,
        tempoJson.isAcceptableOrUnknown(data['tempo_json']!, _tempoJsonMeta),
      );
    }
    if (data.containsKey('limitation_keys')) {
      context.handle(
        _limitationKeysMeta,
        limitationKeys.isAcceptableOrUnknown(
          data['limitation_keys']!,
          _limitationKeysMeta,
        ),
      );
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SwingAnalysis map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SwingAnalysis(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      swingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}swing_id'],
      )!,
      modelVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_version'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schema_version'],
      )!,
      status: $SwingAnalysesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      isCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_current'],
      )!,
      mirrored: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mirrored'],
      )!,
      keypointsFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keypoints_file_path'],
      ),
      phasesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phases_json'],
      ),
      tempoJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tempo_json'],
      ),
      limitationKeys: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}limitation_keys'],
      )!,
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $SwingAnalysesTable createAlias(String alias) {
    return $SwingAnalysesTable(attachedDatabase, alias);
  }

  static TypeConverter<AnalysisStatus, String> $converterstatus =
      const WireConverter(AnalysisStatus.values);
}

class SwingAnalysis extends DataClass implements Insertable<SwingAnalysis> {
  final String id;
  final String swingId;
  final String modelVersion;
  final String schemaVersion;
  final AnalysisStatus status;
  final bool isCurrent;

  /// True when keypoints were mirrored for a left-handed golfer before rules.
  final bool mirrored;

  /// Relative to the app documents directory (derived file, DATABASE_SCHEMA §12).
  final String? keypointsFilePath;

  /// JSON array of PhaseMark (snake_case fields).
  final String? phasesJson;

  /// JSON object of Tempo, absent when not measurable.
  final String? tempoJson;
  final String limitationKeys;
  final String? errorCode;
  final DateTime createdAt;
  final DateTime? completedAt;
  const SwingAnalysis({
    required this.id,
    required this.swingId,
    required this.modelVersion,
    required this.schemaVersion,
    required this.status,
    required this.isCurrent,
    required this.mirrored,
    this.keypointsFilePath,
    this.phasesJson,
    this.tempoJson,
    required this.limitationKeys,
    this.errorCode,
    required this.createdAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['swing_id'] = Variable<String>(swingId);
    map['model_version'] = Variable<String>(modelVersion);
    map['schema_version'] = Variable<String>(schemaVersion);
    {
      map['status'] = Variable<String>(
        $SwingAnalysesTable.$converterstatus.toSql(status),
      );
    }
    map['is_current'] = Variable<bool>(isCurrent);
    map['mirrored'] = Variable<bool>(mirrored);
    if (!nullToAbsent || keypointsFilePath != null) {
      map['keypoints_file_path'] = Variable<String>(keypointsFilePath);
    }
    if (!nullToAbsent || phasesJson != null) {
      map['phases_json'] = Variable<String>(phasesJson);
    }
    if (!nullToAbsent || tempoJson != null) {
      map['tempo_json'] = Variable<String>(tempoJson);
    }
    map['limitation_keys'] = Variable<String>(limitationKeys);
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  SwingAnalysesCompanion toCompanion(bool nullToAbsent) {
    return SwingAnalysesCompanion(
      id: Value(id),
      swingId: Value(swingId),
      modelVersion: Value(modelVersion),
      schemaVersion: Value(schemaVersion),
      status: Value(status),
      isCurrent: Value(isCurrent),
      mirrored: Value(mirrored),
      keypointsFilePath: keypointsFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(keypointsFilePath),
      phasesJson: phasesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(phasesJson),
      tempoJson: tempoJson == null && nullToAbsent
          ? const Value.absent()
          : Value(tempoJson),
      limitationKeys: Value(limitationKeys),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory SwingAnalysis.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SwingAnalysis(
      id: serializer.fromJson<String>(json['id']),
      swingId: serializer.fromJson<String>(json['swingId']),
      modelVersion: serializer.fromJson<String>(json['modelVersion']),
      schemaVersion: serializer.fromJson<String>(json['schemaVersion']),
      status: serializer.fromJson<AnalysisStatus>(json['status']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
      mirrored: serializer.fromJson<bool>(json['mirrored']),
      keypointsFilePath: serializer.fromJson<String?>(
        json['keypointsFilePath'],
      ),
      phasesJson: serializer.fromJson<String?>(json['phasesJson']),
      tempoJson: serializer.fromJson<String?>(json['tempoJson']),
      limitationKeys: serializer.fromJson<String>(json['limitationKeys']),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'swingId': serializer.toJson<String>(swingId),
      'modelVersion': serializer.toJson<String>(modelVersion),
      'schemaVersion': serializer.toJson<String>(schemaVersion),
      'status': serializer.toJson<AnalysisStatus>(status),
      'isCurrent': serializer.toJson<bool>(isCurrent),
      'mirrored': serializer.toJson<bool>(mirrored),
      'keypointsFilePath': serializer.toJson<String?>(keypointsFilePath),
      'phasesJson': serializer.toJson<String?>(phasesJson),
      'tempoJson': serializer.toJson<String?>(tempoJson),
      'limitationKeys': serializer.toJson<String>(limitationKeys),
      'errorCode': serializer.toJson<String?>(errorCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  SwingAnalysis copyWith({
    String? id,
    String? swingId,
    String? modelVersion,
    String? schemaVersion,
    AnalysisStatus? status,
    bool? isCurrent,
    bool? mirrored,
    Value<String?> keypointsFilePath = const Value.absent(),
    Value<String?> phasesJson = const Value.absent(),
    Value<String?> tempoJson = const Value.absent(),
    String? limitationKeys,
    Value<String?> errorCode = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => SwingAnalysis(
    id: id ?? this.id,
    swingId: swingId ?? this.swingId,
    modelVersion: modelVersion ?? this.modelVersion,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    status: status ?? this.status,
    isCurrent: isCurrent ?? this.isCurrent,
    mirrored: mirrored ?? this.mirrored,
    keypointsFilePath: keypointsFilePath.present
        ? keypointsFilePath.value
        : this.keypointsFilePath,
    phasesJson: phasesJson.present ? phasesJson.value : this.phasesJson,
    tempoJson: tempoJson.present ? tempoJson.value : this.tempoJson,
    limitationKeys: limitationKeys ?? this.limitationKeys,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  SwingAnalysis copyWithCompanion(SwingAnalysesCompanion data) {
    return SwingAnalysis(
      id: data.id.present ? data.id.value : this.id,
      swingId: data.swingId.present ? data.swingId.value : this.swingId,
      modelVersion: data.modelVersion.present
          ? data.modelVersion.value
          : this.modelVersion,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      status: data.status.present ? data.status.value : this.status,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
      mirrored: data.mirrored.present ? data.mirrored.value : this.mirrored,
      keypointsFilePath: data.keypointsFilePath.present
          ? data.keypointsFilePath.value
          : this.keypointsFilePath,
      phasesJson: data.phasesJson.present
          ? data.phasesJson.value
          : this.phasesJson,
      tempoJson: data.tempoJson.present ? data.tempoJson.value : this.tempoJson,
      limitationKeys: data.limitationKeys.present
          ? data.limitationKeys.value
          : this.limitationKeys,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SwingAnalysis(')
          ..write('id: $id, ')
          ..write('swingId: $swingId, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('status: $status, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('mirrored: $mirrored, ')
          ..write('keypointsFilePath: $keypointsFilePath, ')
          ..write('phasesJson: $phasesJson, ')
          ..write('tempoJson: $tempoJson, ')
          ..write('limitationKeys: $limitationKeys, ')
          ..write('errorCode: $errorCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    swingId,
    modelVersion,
    schemaVersion,
    status,
    isCurrent,
    mirrored,
    keypointsFilePath,
    phasesJson,
    tempoJson,
    limitationKeys,
    errorCode,
    createdAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SwingAnalysis &&
          other.id == this.id &&
          other.swingId == this.swingId &&
          other.modelVersion == this.modelVersion &&
          other.schemaVersion == this.schemaVersion &&
          other.status == this.status &&
          other.isCurrent == this.isCurrent &&
          other.mirrored == this.mirrored &&
          other.keypointsFilePath == this.keypointsFilePath &&
          other.phasesJson == this.phasesJson &&
          other.tempoJson == this.tempoJson &&
          other.limitationKeys == this.limitationKeys &&
          other.errorCode == this.errorCode &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class SwingAnalysesCompanion extends UpdateCompanion<SwingAnalysis> {
  final Value<String> id;
  final Value<String> swingId;
  final Value<String> modelVersion;
  final Value<String> schemaVersion;
  final Value<AnalysisStatus> status;
  final Value<bool> isCurrent;
  final Value<bool> mirrored;
  final Value<String?> keypointsFilePath;
  final Value<String?> phasesJson;
  final Value<String?> tempoJson;
  final Value<String> limitationKeys;
  final Value<String?> errorCode;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const SwingAnalysesCompanion({
    this.id = const Value.absent(),
    this.swingId = const Value.absent(),
    this.modelVersion = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.mirrored = const Value.absent(),
    this.keypointsFilePath = const Value.absent(),
    this.phasesJson = const Value.absent(),
    this.tempoJson = const Value.absent(),
    this.limitationKeys = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SwingAnalysesCompanion.insert({
    required String id,
    required String swingId,
    required String modelVersion,
    required String schemaVersion,
    required AnalysisStatus status,
    this.isCurrent = const Value.absent(),
    this.mirrored = const Value.absent(),
    this.keypointsFilePath = const Value.absent(),
    this.phasesJson = const Value.absent(),
    this.tempoJson = const Value.absent(),
    this.limitationKeys = const Value.absent(),
    this.errorCode = const Value.absent(),
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       swingId = Value(swingId),
       modelVersion = Value(modelVersion),
       schemaVersion = Value(schemaVersion),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<SwingAnalysis> custom({
    Expression<String>? id,
    Expression<String>? swingId,
    Expression<String>? modelVersion,
    Expression<String>? schemaVersion,
    Expression<String>? status,
    Expression<bool>? isCurrent,
    Expression<bool>? mirrored,
    Expression<String>? keypointsFilePath,
    Expression<String>? phasesJson,
    Expression<String>? tempoJson,
    Expression<String>? limitationKeys,
    Expression<String>? errorCode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (swingId != null) 'swing_id': swingId,
      if (modelVersion != null) 'model_version': modelVersion,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (status != null) 'status': status,
      if (isCurrent != null) 'is_current': isCurrent,
      if (mirrored != null) 'mirrored': mirrored,
      if (keypointsFilePath != null) 'keypoints_file_path': keypointsFilePath,
      if (phasesJson != null) 'phases_json': phasesJson,
      if (tempoJson != null) 'tempo_json': tempoJson,
      if (limitationKeys != null) 'limitation_keys': limitationKeys,
      if (errorCode != null) 'error_code': errorCode,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SwingAnalysesCompanion copyWith({
    Value<String>? id,
    Value<String>? swingId,
    Value<String>? modelVersion,
    Value<String>? schemaVersion,
    Value<AnalysisStatus>? status,
    Value<bool>? isCurrent,
    Value<bool>? mirrored,
    Value<String?>? keypointsFilePath,
    Value<String?>? phasesJson,
    Value<String?>? tempoJson,
    Value<String>? limitationKeys,
    Value<String?>? errorCode,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return SwingAnalysesCompanion(
      id: id ?? this.id,
      swingId: swingId ?? this.swingId,
      modelVersion: modelVersion ?? this.modelVersion,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      status: status ?? this.status,
      isCurrent: isCurrent ?? this.isCurrent,
      mirrored: mirrored ?? this.mirrored,
      keypointsFilePath: keypointsFilePath ?? this.keypointsFilePath,
      phasesJson: phasesJson ?? this.phasesJson,
      tempoJson: tempoJson ?? this.tempoJson,
      limitationKeys: limitationKeys ?? this.limitationKeys,
      errorCode: errorCode ?? this.errorCode,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (swingId.present) {
      map['swing_id'] = Variable<String>(swingId.value);
    }
    if (modelVersion.present) {
      map['model_version'] = Variable<String>(modelVersion.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<String>(schemaVersion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SwingAnalysesTable.$converterstatus.toSql(status.value),
      );
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (mirrored.present) {
      map['mirrored'] = Variable<bool>(mirrored.value);
    }
    if (keypointsFilePath.present) {
      map['keypoints_file_path'] = Variable<String>(keypointsFilePath.value);
    }
    if (phasesJson.present) {
      map['phases_json'] = Variable<String>(phasesJson.value);
    }
    if (tempoJson.present) {
      map['tempo_json'] = Variable<String>(tempoJson.value);
    }
    if (limitationKeys.present) {
      map['limitation_keys'] = Variable<String>(limitationKeys.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SwingAnalysesCompanion(')
          ..write('id: $id, ')
          ..write('swingId: $swingId, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('status: $status, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('mirrored: $mirrored, ')
          ..write('keypointsFilePath: $keypointsFilePath, ')
          ..write('phasesJson: $phasesJson, ')
          ..write('tempoJson: $tempoJson, ')
          ..write('limitationKeys: $limitationKeys, ')
          ..write('errorCode: $errorCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $SwingSessionsTable swingSessions = $SwingSessionsTable(this);
  late final $SwingsTable swings = $SwingsTable(this);
  late final $SwingAnalysesTable swingAnalyses = $SwingAnalysesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    swingSessions,
    swings,
    swingAnalyses,
  ];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      Value<String?> preferredLocale,
      required Handedness handedness,
      Value<SkillLevel?> skillLevel,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String?> preferredLocale,
      Value<Handedness> handedness,
      Value<SkillLevel?> skillLevel,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$UserProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile> {
  $$UserProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SwingSessionsTable, List<SwingSession>>
  _swingSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.swingSessions,
    aliasName: 'user_profiles__id__swing_sessions__user_id',
  );

  $$SwingSessionsTableProcessedTableManager get swingSessionsRefs {
    final manager = $$SwingSessionsTableTableManager(
      $_db,
      $_db.swingSessions,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_swingSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredLocale => $composableBuilder(
    column: $table.preferredLocale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Handedness, Handedness, String>
  get handedness => $composableBuilder(
    column: $table.handedness,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<SkillLevel?, SkillLevel, String>
  get skillLevel => $composableBuilder(
    column: $table.skillLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> swingSessionsRefs(
    Expression<bool> Function($$SwingSessionsTableFilterComposer f) f,
  ) {
    final $$SwingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.swingSessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.swingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredLocale => $composableBuilder(
    column: $table.preferredLocale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get handedness => $composableBuilder(
    column: $table.handedness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skillLevel => $composableBuilder(
    column: $table.skillLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get preferredLocale => $composableBuilder(
    column: $table.preferredLocale,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Handedness, String> get handedness =>
      $composableBuilder(
        column: $table.handedness,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SkillLevel?, String> get skillLevel =>
      $composableBuilder(
        column: $table.skillLevel,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> swingSessionsRefs<T extends Object>(
    Expression<T> Function($$SwingSessionsTableAnnotationComposer a) f,
  ) {
    final $$SwingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.swingSessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.swingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (UserProfile, $$UserProfilesTableReferences),
          UserProfile,
          PrefetchHooks Function({bool swingSessionsRefs})
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> preferredLocale = const Value.absent(),
                Value<Handedness> handedness = const Value.absent(),
                Value<SkillLevel?> skillLevel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                preferredLocale: preferredLocale,
                handedness: handedness,
                skillLevel: skillLevel,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> preferredLocale = const Value.absent(),
                required Handedness handedness,
                Value<SkillLevel?> skillLevel = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                preferredLocale: preferredLocale,
                handedness: handedness,
                skillLevel: skillLevel,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  $$UserProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({swingSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (swingSessionsRefs) db.swingSessions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (swingSessionsRefs)
                    await $_getPrefetchedDataByColumns<
                      UserProfile,
                      $UserProfilesTable,
                      SwingSession,
                      $SwingSessionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$UserProfilesTableReferences
                          ._swingSessionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UserProfilesTableReferences(
                            db,
                            table,
                            p0,
                          ).swingSessionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'user_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (UserProfile, $$UserProfilesTableReferences),
      UserProfile,
      PrefetchHooks Function({bool swingSessionsRefs})
    >;
typedef $$SwingSessionsTableCreateCompanionBuilder =
    SwingSessionsCompanion Function({
      required String id,
      required String userId,
      required SessionMode mode,
      required Source source,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<ClubType?> clubType,
      Value<int?> clubNumber,
      required CameraAngle cameraAngle,
      required Handedness handednessSnapshot,
      required Subject defaultSubject,
      Value<int?> plannedSwingCount,
      required FeedbackTiming feedbackTiming,
      Value<int?> feedbackDisplaySeconds,
      Value<int?> timerSeconds,
      Value<int?> requestedFps,
      required SessionStatus status,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$SwingSessionsTableUpdateCompanionBuilder =
    SwingSessionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<SessionMode> mode,
      Value<Source> source,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<ClubType?> clubType,
      Value<int?> clubNumber,
      Value<CameraAngle> cameraAngle,
      Value<Handedness> handednessSnapshot,
      Value<Subject> defaultSubject,
      Value<int?> plannedSwingCount,
      Value<FeedbackTiming> feedbackTiming,
      Value<int?> feedbackDisplaySeconds,
      Value<int?> timerSeconds,
      Value<int?> requestedFps,
      Value<SessionStatus> status,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$SwingSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SwingSessionsTable, SwingSession> {
  $$SwingSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserProfilesTable _userIdTable(_$AppDatabase db) =>
      db.userProfiles.createAlias('swing_sessions__user_id__user_profiles__id');

  $$UserProfilesTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UserProfilesTableTableManager(
      $_db,
      $_db.userProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SwingsTable, List<Swing>> _swingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.swings,
    aliasName: 'swing_sessions__id__swings__session_id',
  );

  $$SwingsTableProcessedTableManager get swingsRefs {
    final manager = $$SwingsTableTableManager(
      $_db,
      $_db.swings,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_swingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SwingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SwingSessionsTable> {
  $$SwingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionMode, SessionMode, String> get mode =>
      $composableBuilder(
        column: $table.mode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Source, Source, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ClubType?, ClubType, String> get clubType =>
      $composableBuilder(
        column: $table.clubType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get clubNumber => $composableBuilder(
    column: $table.clubNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CameraAngle, CameraAngle, String>
  get cameraAngle => $composableBuilder(
    column: $table.cameraAngle,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Handedness, Handedness, String>
  get handednessSnapshot => $composableBuilder(
    column: $table.handednessSnapshot,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Subject, Subject, String> get defaultSubject =>
      $composableBuilder(
        column: $table.defaultSubject,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get plannedSwingCount => $composableBuilder(
    column: $table.plannedSwingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FeedbackTiming, FeedbackTiming, String>
  get feedbackTiming => $composableBuilder(
    column: $table.feedbackTiming,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get feedbackDisplaySeconds => $composableBuilder(
    column: $table.feedbackDisplaySeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get requestedFps => $composableBuilder(
    column: $table.requestedFps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionStatus, SessionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$UserProfilesTableFilterComposer get userId {
    final $$UserProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableFilterComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> swingsRefs(
    Expression<bool> Function($$SwingsTableFilterComposer f) f,
  ) {
    final $$SwingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.swings,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingsTableFilterComposer(
            $db: $db,
            $table: $db.swings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SwingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SwingSessionsTable> {
  $$SwingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clubType => $composableBuilder(
    column: $table.clubType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clubNumber => $composableBuilder(
    column: $table.clubNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cameraAngle => $composableBuilder(
    column: $table.cameraAngle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get handednessSnapshot => $composableBuilder(
    column: $table.handednessSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultSubject => $composableBuilder(
    column: $table.defaultSubject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSwingCount => $composableBuilder(
    column: $table.plannedSwingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedbackTiming => $composableBuilder(
    column: $table.feedbackTiming,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get feedbackDisplaySeconds => $composableBuilder(
    column: $table.feedbackDisplaySeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get requestedFps => $composableBuilder(
    column: $table.requestedFps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserProfilesTableOrderingComposer get userId {
    final $$UserProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SwingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SwingSessionsTable> {
  $$SwingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionMode, String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Source, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ClubType?, String> get clubType =>
      $composableBuilder(column: $table.clubType, builder: (column) => column);

  GeneratedColumn<int> get clubNumber => $composableBuilder(
    column: $table.clubNumber,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CameraAngle, String> get cameraAngle =>
      $composableBuilder(
        column: $table.cameraAngle,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Handedness, String> get handednessSnapshot =>
      $composableBuilder(
        column: $table.handednessSnapshot,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Subject, String> get defaultSubject =>
      $composableBuilder(
        column: $table.defaultSubject,
        builder: (column) => column,
      );

  GeneratedColumn<int> get plannedSwingCount => $composableBuilder(
    column: $table.plannedSwingCount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FeedbackTiming, String> get feedbackTiming =>
      $composableBuilder(
        column: $table.feedbackTiming,
        builder: (column) => column,
      );

  GeneratedColumn<int> get feedbackDisplaySeconds => $composableBuilder(
    column: $table.feedbackDisplaySeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get requestedFps => $composableBuilder(
    column: $table.requestedFps,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SessionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$UserProfilesTableAnnotationComposer get userId {
    final $$UserProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> swingsRefs<T extends Object>(
    Expression<T> Function($$SwingsTableAnnotationComposer a) f,
  ) {
    final $$SwingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.swings,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingsTableAnnotationComposer(
            $db: $db,
            $table: $db.swings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SwingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SwingSessionsTable,
          SwingSession,
          $$SwingSessionsTableFilterComposer,
          $$SwingSessionsTableOrderingComposer,
          $$SwingSessionsTableAnnotationComposer,
          $$SwingSessionsTableCreateCompanionBuilder,
          $$SwingSessionsTableUpdateCompanionBuilder,
          (SwingSession, $$SwingSessionsTableReferences),
          SwingSession,
          PrefetchHooks Function({bool userId, bool swingsRefs})
        > {
  $$SwingSessionsTableTableManager(_$AppDatabase db, $SwingSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SwingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SwingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SwingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<SessionMode> mode = const Value.absent(),
                Value<Source> source = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<ClubType?> clubType = const Value.absent(),
                Value<int?> clubNumber = const Value.absent(),
                Value<CameraAngle> cameraAngle = const Value.absent(),
                Value<Handedness> handednessSnapshot = const Value.absent(),
                Value<Subject> defaultSubject = const Value.absent(),
                Value<int?> plannedSwingCount = const Value.absent(),
                Value<FeedbackTiming> feedbackTiming = const Value.absent(),
                Value<int?> feedbackDisplaySeconds = const Value.absent(),
                Value<int?> timerSeconds = const Value.absent(),
                Value<int?> requestedFps = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SwingSessionsCompanion(
                id: id,
                userId: userId,
                mode: mode,
                source: source,
                startedAt: startedAt,
                endedAt: endedAt,
                clubType: clubType,
                clubNumber: clubNumber,
                cameraAngle: cameraAngle,
                handednessSnapshot: handednessSnapshot,
                defaultSubject: defaultSubject,
                plannedSwingCount: plannedSwingCount,
                feedbackTiming: feedbackTiming,
                feedbackDisplaySeconds: feedbackDisplaySeconds,
                timerSeconds: timerSeconds,
                requestedFps: requestedFps,
                status: status,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required SessionMode mode,
                required Source source,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<ClubType?> clubType = const Value.absent(),
                Value<int?> clubNumber = const Value.absent(),
                required CameraAngle cameraAngle,
                required Handedness handednessSnapshot,
                required Subject defaultSubject,
                Value<int?> plannedSwingCount = const Value.absent(),
                required FeedbackTiming feedbackTiming,
                Value<int?> feedbackDisplaySeconds = const Value.absent(),
                Value<int?> timerSeconds = const Value.absent(),
                Value<int?> requestedFps = const Value.absent(),
                required SessionStatus status,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SwingSessionsCompanion.insert(
                id: id,
                userId: userId,
                mode: mode,
                source: source,
                startedAt: startedAt,
                endedAt: endedAt,
                clubType: clubType,
                clubNumber: clubNumber,
                cameraAngle: cameraAngle,
                handednessSnapshot: handednessSnapshot,
                defaultSubject: defaultSubject,
                plannedSwingCount: plannedSwingCount,
                feedbackTiming: feedbackTiming,
                feedbackDisplaySeconds: feedbackDisplaySeconds,
                timerSeconds: timerSeconds,
                requestedFps: requestedFps,
                status: status,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SwingSessionsTable, SwingSession>(table),
                  $$SwingSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, swingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (swingsRefs) db.swings],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$SwingSessionsTableReferences
                            ._userIdTable(db),
                        referencedColumn: $$SwingSessionsTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (swingsRefs)
                    await $_getPrefetchedDataByColumns<
                      SwingSession,
                      $SwingSessionsTable,
                      Swing,
                      $SwingsTable
                    >(
                      currentTable: table,
                      referencedTable: $$SwingSessionsTableReferences
                          ._swingsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SwingSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).swingsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'session_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SwingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SwingSessionsTable,
      SwingSession,
      $$SwingSessionsTableFilterComposer,
      $$SwingSessionsTableOrderingComposer,
      $$SwingSessionsTableAnnotationComposer,
      $$SwingSessionsTableCreateCompanionBuilder,
      $$SwingSessionsTableUpdateCompanionBuilder,
      (SwingSession, $$SwingSessionsTableReferences),
      SwingSession,
      PrefetchHooks Function({bool userId, bool swingsRefs})
    >;
typedef $$SwingsTableCreateCompanionBuilder = SwingsCompanion Function({
  required String id,
  required String sessionId,
  required int orderIndex,
  required Subject subject,
  required bool includeInStats,
  Value<bool> isFavorite,
  Value<String?> note,
  required AppPlatform platform,
  required String localFilePath,
  Value<String?> sourceAssetId,
  Value<String?> thumbnailPath,
  required int durationMs,
  required int width,
  required int height,
  required int fileSizeBytes,
  required double actualFps,
  required int rotationDegrees,
  Value<QualityLevel?> qualityLevel,
  required List<QualityIssue> qualityIssues,
  Value<String> uploadStatus,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SwingsTableUpdateCompanionBuilder = SwingsCompanion Function({
  Value<String> id,
  Value<String> sessionId,
  Value<int> orderIndex,
  Value<Subject> subject,
  Value<bool> includeInStats,
  Value<bool> isFavorite,
  Value<String?> note,
  Value<AppPlatform> platform,
  Value<String> localFilePath,
  Value<String?> sourceAssetId,
  Value<String?> thumbnailPath,
  Value<int> durationMs,
  Value<int> width,
  Value<int> height,
  Value<int> fileSizeBytes,
  Value<double> actualFps,
  Value<int> rotationDegrees,
  Value<QualityLevel?> qualityLevel,
  Value<List<QualityIssue>> qualityIssues,
  Value<String> uploadStatus,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$SwingsTableReferences
    extends BaseReferences<_$AppDatabase, $SwingsTable, Swing> {
  $$SwingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SwingSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.swingSessions.createAlias('swings__session_id__swing_sessions__id');

  $$SwingSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SwingSessionsTableTableManager(
      $_db,
      $_db.swingSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SwingAnalysesTable, List<SwingAnalysis>>
  _swingAnalysesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.swingAnalyses,
    aliasName: 'swings__id__swing_analyses__swing_id',
  );

  $$SwingAnalysesTableProcessedTableManager get swingAnalysesRefs {
    final manager = $$SwingAnalysesTableTableManager(
      $_db,
      $_db.swingAnalyses,
    ).filter((f) => f.swingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_swingAnalysesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SwingsTableFilterComposer
    extends Composer<_$AppDatabase, $SwingsTable> {
  $$SwingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Subject, Subject, String> get subject =>
      $composableBuilder(
        column: $table.subject,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get includeInStats => $composableBuilder(
    column: $table.includeInStats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppPlatform, AppPlatform, String>
  get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceAssetId => $composableBuilder(
    column: $table.sourceAssetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualFps => $composableBuilder(
    column: $table.actualFps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rotationDegrees => $composableBuilder(
    column: $table.rotationDegrees,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QualityLevel?, QualityLevel, String>
  get qualityLevel => $composableBuilder(
    column: $table.qualityLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<QualityIssue>, List<QualityIssue>, String>
  get qualityIssues => $composableBuilder(
    column: $table.qualityIssues,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SwingSessionsTableFilterComposer get sessionId {
    final $$SwingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.swingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.swingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> swingAnalysesRefs(
    Expression<bool> Function($$SwingAnalysesTableFilterComposer f) f,
  ) {
    final $$SwingAnalysesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.swingAnalyses,
      getReferencedColumn: (t) => t.swingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingAnalysesTableFilterComposer(
            $db: $db,
            $table: $db.swingAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SwingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SwingsTable> {
  $$SwingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get includeInStats => $composableBuilder(
    column: $table.includeInStats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceAssetId => $composableBuilder(
    column: $table.sourceAssetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualFps => $composableBuilder(
    column: $table.actualFps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rotationDegrees => $composableBuilder(
    column: $table.rotationDegrees,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualityLevel => $composableBuilder(
    column: $table.qualityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualityIssues => $composableBuilder(
    column: $table.qualityIssues,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SwingSessionsTableOrderingComposer get sessionId {
    final $$SwingSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.swingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.swingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SwingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SwingsTable> {
  $$SwingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Subject, String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<bool> get includeInStats => $composableBuilder(
    column: $table.includeInStats,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppPlatform, String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceAssetId => $composableBuilder(
    column: $table.sourceAssetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get actualFps =>
      $composableBuilder(column: $table.actualFps, builder: (column) => column);

  GeneratedColumn<int> get rotationDegrees => $composableBuilder(
    column: $table.rotationDegrees,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QualityLevel?, String> get qualityLevel =>
      $composableBuilder(
        column: $table.qualityLevel,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<QualityIssue>, String>
  get qualityIssues => $composableBuilder(
    column: $table.qualityIssues,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SwingSessionsTableAnnotationComposer get sessionId {
    final $$SwingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.swingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.swingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> swingAnalysesRefs<T extends Object>(
    Expression<T> Function($$SwingAnalysesTableAnnotationComposer a) f,
  ) {
    final $$SwingAnalysesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.swingAnalyses,
      getReferencedColumn: (t) => t.swingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingAnalysesTableAnnotationComposer(
            $db: $db,
            $table: $db.swingAnalyses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SwingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SwingsTable,
          Swing,
          $$SwingsTableFilterComposer,
          $$SwingsTableOrderingComposer,
          $$SwingsTableAnnotationComposer,
          $$SwingsTableCreateCompanionBuilder,
          $$SwingsTableUpdateCompanionBuilder,
          (Swing, $$SwingsTableReferences),
          Swing,
          PrefetchHooks Function({bool sessionId, bool swingAnalysesRefs})
        > {
  $$SwingsTableTableManager(_$AppDatabase db, $SwingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SwingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SwingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SwingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<Subject> subject = const Value.absent(),
                Value<bool> includeInStats = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<AppPlatform> platform = const Value.absent(),
                Value<String> localFilePath = const Value.absent(),
                Value<String?> sourceAssetId = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<double> actualFps = const Value.absent(),
                Value<int> rotationDegrees = const Value.absent(),
                Value<QualityLevel?> qualityLevel = const Value.absent(),
                Value<List<QualityIssue>> qualityIssues = const Value.absent(),
                Value<String> uploadStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SwingsCompanion(
                id: id,
                sessionId: sessionId,
                orderIndex: orderIndex,
                subject: subject,
                includeInStats: includeInStats,
                isFavorite: isFavorite,
                note: note,
                platform: platform,
                localFilePath: localFilePath,
                sourceAssetId: sourceAssetId,
                thumbnailPath: thumbnailPath,
                durationMs: durationMs,
                width: width,
                height: height,
                fileSizeBytes: fileSizeBytes,
                actualFps: actualFps,
                rotationDegrees: rotationDegrees,
                qualityLevel: qualityLevel,
                qualityIssues: qualityIssues,
                uploadStatus: uploadStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required int orderIndex,
                required Subject subject,
                required bool includeInStats,
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required AppPlatform platform,
                required String localFilePath,
                Value<String?> sourceAssetId = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                required int durationMs,
                required int width,
                required int height,
                required int fileSizeBytes,
                required double actualFps,
                required int rotationDegrees,
                Value<QualityLevel?> qualityLevel = const Value.absent(),
                required List<QualityIssue> qualityIssues,
                Value<String> uploadStatus = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SwingsCompanion.insert(
                id: id,
                sessionId: sessionId,
                orderIndex: orderIndex,
                subject: subject,
                includeInStats: includeInStats,
                isFavorite: isFavorite,
                note: note,
                platform: platform,
                localFilePath: localFilePath,
                sourceAssetId: sourceAssetId,
                thumbnailPath: thumbnailPath,
                durationMs: durationMs,
                width: width,
                height: height,
                fileSizeBytes: fileSizeBytes,
                actualFps: actualFps,
                rotationDegrees: rotationDegrees,
                qualityLevel: qualityLevel,
                qualityIssues: qualityIssues,
                uploadStatus: uploadStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SwingsTable, Swing>(table),
                  $$SwingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, swingAnalysesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (swingAnalysesRefs) db.swingAnalyses,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$SwingsTableReferences
                                ._sessionIdTable(db),
                            referencedColumn: $$SwingsTableReferences
                                ._sessionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (swingAnalysesRefs)
                        await $_getPrefetchedDataByColumns<
                          Swing,
                          $SwingsTable,
                          SwingAnalysis,
                          $SwingAnalysesTable
                        >(
                          currentTable: table,
                          referencedTable: $$SwingsTableReferences
                              ._swingAnalysesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SwingsTableReferences(
                                db,
                                table,
                                p0,
                              ).swingAnalysesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'swing_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SwingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SwingsTable,
      Swing,
      $$SwingsTableFilterComposer,
      $$SwingsTableOrderingComposer,
      $$SwingsTableAnnotationComposer,
      $$SwingsTableCreateCompanionBuilder,
      $$SwingsTableUpdateCompanionBuilder,
      (Swing, $$SwingsTableReferences),
      Swing,
      PrefetchHooks Function({bool sessionId, bool swingAnalysesRefs})
    >;
typedef $$SwingAnalysesTableCreateCompanionBuilder =
    SwingAnalysesCompanion Function({
      required String id,
      required String swingId,
      required String modelVersion,
      required String schemaVersion,
      required AnalysisStatus status,
      Value<bool> isCurrent,
      Value<bool> mirrored,
      Value<String?> keypointsFilePath,
      Value<String?> phasesJson,
      Value<String?> tempoJson,
      Value<String> limitationKeys,
      Value<String?> errorCode,
      required DateTime createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$SwingAnalysesTableUpdateCompanionBuilder =
    SwingAnalysesCompanion Function({
      Value<String> id,
      Value<String> swingId,
      Value<String> modelVersion,
      Value<String> schemaVersion,
      Value<AnalysisStatus> status,
      Value<bool> isCurrent,
      Value<bool> mirrored,
      Value<String?> keypointsFilePath,
      Value<String?> phasesJson,
      Value<String?> tempoJson,
      Value<String> limitationKeys,
      Value<String?> errorCode,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

final class $$SwingAnalysesTableReferences
    extends BaseReferences<_$AppDatabase, $SwingAnalysesTable, SwingAnalysis> {
  $$SwingAnalysesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SwingsTable _swingIdTable(_$AppDatabase db) =>
      db.swings.createAlias('swing_analyses__swing_id__swings__id');

  $$SwingsTableProcessedTableManager get swingId {
    final $_column = $_itemColumn<String>('swing_id')!;

    final manager = $$SwingsTableTableManager(
      $_db,
      $_db.swings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_swingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SwingAnalysesTableFilterComposer
    extends Composer<_$AppDatabase, $SwingAnalysesTable> {
  $$SwingAnalysesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AnalysisStatus, AnalysisStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mirrored => $composableBuilder(
    column: $table.mirrored,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keypointsFilePath => $composableBuilder(
    column: $table.keypointsFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phasesJson => $composableBuilder(
    column: $table.phasesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempoJson => $composableBuilder(
    column: $table.tempoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get limitationKeys => $composableBuilder(
    column: $table.limitationKeys,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SwingsTableFilterComposer get swingId {
    final $$SwingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.swingId,
      referencedTable: $db.swings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingsTableFilterComposer(
            $db: $db,
            $table: $db.swings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SwingAnalysesTableOrderingComposer
    extends Composer<_$AppDatabase, $SwingAnalysesTable> {
  $$SwingAnalysesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mirrored => $composableBuilder(
    column: $table.mirrored,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keypointsFilePath => $composableBuilder(
    column: $table.keypointsFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phasesJson => $composableBuilder(
    column: $table.phasesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempoJson => $composableBuilder(
    column: $table.tempoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get limitationKeys => $composableBuilder(
    column: $table.limitationKeys,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SwingsTableOrderingComposer get swingId {
    final $$SwingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.swingId,
      referencedTable: $db.swings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingsTableOrderingComposer(
            $db: $db,
            $table: $db.swings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SwingAnalysesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SwingAnalysesTable> {
  $$SwingAnalysesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AnalysisStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isCurrent =>
      $composableBuilder(column: $table.isCurrent, builder: (column) => column);

  GeneratedColumn<bool> get mirrored =>
      $composableBuilder(column: $table.mirrored, builder: (column) => column);

  GeneratedColumn<String> get keypointsFilePath => $composableBuilder(
    column: $table.keypointsFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phasesJson => $composableBuilder(
    column: $table.phasesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tempoJson =>
      $composableBuilder(column: $table.tempoJson, builder: (column) => column);

  GeneratedColumn<String> get limitationKeys => $composableBuilder(
    column: $table.limitationKeys,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$SwingsTableAnnotationComposer get swingId {
    final $$SwingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.swingId,
      referencedTable: $db.swings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SwingsTableAnnotationComposer(
            $db: $db,
            $table: $db.swings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SwingAnalysesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SwingAnalysesTable,
          SwingAnalysis,
          $$SwingAnalysesTableFilterComposer,
          $$SwingAnalysesTableOrderingComposer,
          $$SwingAnalysesTableAnnotationComposer,
          $$SwingAnalysesTableCreateCompanionBuilder,
          $$SwingAnalysesTableUpdateCompanionBuilder,
          (SwingAnalysis, $$SwingAnalysesTableReferences),
          SwingAnalysis,
          PrefetchHooks Function({bool swingId})
        > {
  $$SwingAnalysesTableTableManager(_$AppDatabase db, $SwingAnalysesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SwingAnalysesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SwingAnalysesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SwingAnalysesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> swingId = const Value.absent(),
                Value<String> modelVersion = const Value.absent(),
                Value<String> schemaVersion = const Value.absent(),
                Value<AnalysisStatus> status = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<bool> mirrored = const Value.absent(),
                Value<String?> keypointsFilePath = const Value.absent(),
                Value<String?> phasesJson = const Value.absent(),
                Value<String?> tempoJson = const Value.absent(),
                Value<String> limitationKeys = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SwingAnalysesCompanion(
                id: id,
                swingId: swingId,
                modelVersion: modelVersion,
                schemaVersion: schemaVersion,
                status: status,
                isCurrent: isCurrent,
                mirrored: mirrored,
                keypointsFilePath: keypointsFilePath,
                phasesJson: phasesJson,
                tempoJson: tempoJson,
                limitationKeys: limitationKeys,
                errorCode: errorCode,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String swingId,
                required String modelVersion,
                required String schemaVersion,
                required AnalysisStatus status,
                Value<bool> isCurrent = const Value.absent(),
                Value<bool> mirrored = const Value.absent(),
                Value<String?> keypointsFilePath = const Value.absent(),
                Value<String?> phasesJson = const Value.absent(),
                Value<String?> tempoJson = const Value.absent(),
                Value<String> limitationKeys = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SwingAnalysesCompanion.insert(
                id: id,
                swingId: swingId,
                modelVersion: modelVersion,
                schemaVersion: schemaVersion,
                status: status,
                isCurrent: isCurrent,
                mirrored: mirrored,
                keypointsFilePath: keypointsFilePath,
                phasesJson: phasesJson,
                tempoJson: tempoJson,
                limitationKeys: limitationKeys,
                errorCode: errorCode,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SwingAnalysesTable, SwingAnalysis>(table),
                  $$SwingAnalysesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({swingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (swingId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.swingId,
                        referencedTable: $$SwingAnalysesTableReferences
                            ._swingIdTable(db),
                        referencedColumn: $$SwingAnalysesTableReferences
                            ._swingIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SwingAnalysesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SwingAnalysesTable,
      SwingAnalysis,
      $$SwingAnalysesTableFilterComposer,
      $$SwingAnalysesTableOrderingComposer,
      $$SwingAnalysesTableAnnotationComposer,
      $$SwingAnalysesTableCreateCompanionBuilder,
      $$SwingAnalysesTableUpdateCompanionBuilder,
      (SwingAnalysis, $$SwingAnalysesTableReferences),
      SwingAnalysis,
      PrefetchHooks Function({bool swingId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$SwingSessionsTableTableManager get swingSessions =>
      $$SwingSessionsTableTableManager(_db, _db.swingSessions);
  $$SwingsTableTableManager get swings =>
      $$SwingsTableTableManager(_db, _db.swings);
  $$SwingAnalysesTableTableManager get swingAnalyses =>
      $$SwingAnalysesTableTableManager(_db, _db.swingAnalyses);
}
