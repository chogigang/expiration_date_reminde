// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fooddb.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class FooddbData extends DataClass implements Insertable<FooddbData> {
  final int id;
  final String name;
  final String type;
  final DateTime expiry_date;
  final int? alarm_cycle;
  final DateTime createdAt;
  FooddbData(
      {required this.id,
      required this.name,
      required this.type,
      required this.expiry_date,
      this.alarm_cycle,
      required this.createdAt});
  factory FooddbData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FooddbData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      expiry_date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}expiry_date'])!,
      alarm_cycle: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}alarm_cycle']),
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['expiry_date'] = Variable<DateTime>(expiry_date);
    if (!nullToAbsent || alarm_cycle != null) {
      map['alarm_cycle'] = Variable<int?>(alarm_cycle);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FooddbCompanion toCompanion(bool nullToAbsent) {
    return FooddbCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      expiry_date: Value(expiry_date),
      alarm_cycle: alarm_cycle == null && nullToAbsent
          ? const Value.absent()
          : Value(alarm_cycle),
      createdAt: Value(createdAt),
    );
  }

  factory FooddbData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FooddbData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      expiry_date: serializer.fromJson<DateTime>(json['expiry_date']),
      alarm_cycle: serializer.fromJson<int?>(json['alarm_cycle']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'expiry_date': serializer.toJson<DateTime>(expiry_date),
      'alarm_cycle': serializer.toJson<int?>(alarm_cycle),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FooddbData copyWith(
          {int? id,
          String? name,
          String? type,
          DateTime? expiry_date,
          int? alarm_cycle,
          DateTime? createdAt}) =>
      FooddbData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        expiry_date: expiry_date ?? this.expiry_date,
        alarm_cycle: alarm_cycle ?? this.alarm_cycle,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('FooddbData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('expiry_date: $expiry_date, ')
          ..write('alarm_cycle: $alarm_cycle, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, expiry_date, alarm_cycle, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FooddbData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.expiry_date == this.expiry_date &&
          other.alarm_cycle == this.alarm_cycle &&
          other.createdAt == this.createdAt);
}

class FooddbCompanion extends UpdateCompanion<FooddbData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<DateTime> expiry_date;
  final Value<int?> alarm_cycle;
  final Value<DateTime> createdAt;
  const FooddbCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.expiry_date = const Value.absent(),
    this.alarm_cycle = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FooddbCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required DateTime expiry_date,
    this.alarm_cycle = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        expiry_date = Value(expiry_date);
  static Insertable<FooddbData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<DateTime>? expiry_date,
    Expression<int?>? alarm_cycle,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (expiry_date != null) 'expiry_date': expiry_date,
      if (alarm_cycle != null) 'alarm_cycle': alarm_cycle,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FooddbCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<DateTime>? expiry_date,
      Value<int?>? alarm_cycle,
      Value<DateTime>? createdAt}) {
    return FooddbCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      expiry_date: expiry_date ?? this.expiry_date,
      alarm_cycle: alarm_cycle ?? this.alarm_cycle,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (expiry_date.present) {
      map['expiry_date'] = Variable<DateTime>(expiry_date.value);
    }
    if (alarm_cycle.present) {
      map['alarm_cycle'] = Variable<int?>(alarm_cycle.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FooddbCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('expiry_date: $expiry_date, ')
          ..write('alarm_cycle: $alarm_cycle, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FooddbTable extends Fooddb with TableInfo<$FooddbTable, FooddbData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FooddbTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String?> type = GeneratedColumn<String?>(
      'type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _expiry_dateMeta =
      const VerificationMeta('expiry_date');
  @override
  late final GeneratedColumn<DateTime?> expiry_date =
      GeneratedColumn<DateTime?>('expiry_date', aliasedName, false,
          type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _alarm_cycleMeta =
      const VerificationMeta('alarm_cycle');
  @override
  late final GeneratedColumn<int?> alarm_cycle = GeneratedColumn<int?>(
      'alarm_cycle', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, expiry_date, alarm_cycle, createdAt];
  @override
  String get aliasedName => _alias ?? 'fooddb';
  @override
  String get actualTableName => 'fooddb';
  @override
  VerificationContext validateIntegrity(Insertable<FooddbData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiry_dateMeta,
          expiry_date.isAcceptableOrUnknown(
              data['expiry_date']!, _expiry_dateMeta));
    } else if (isInserting) {
      context.missing(_expiry_dateMeta);
    }
    if (data.containsKey('alarm_cycle')) {
      context.handle(
          _alarm_cycleMeta,
          alarm_cycle.isAcceptableOrUnknown(
              data['alarm_cycle']!, _alarm_cycleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FooddbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FooddbData.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FooddbTable createAlias(String alias) {
    return $FooddbTable(attachedDatabase, alias);
  }
}

class FooddbViewData extends DataClass {
  final int id;
  FooddbViewData({required this.id});
  factory FooddbViewData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FooddbViewData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
    );
  }
  factory FooddbViewData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FooddbViewData(
      id: serializer.fromJson<int>(json['id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
    };
  }

  FooddbViewData copyWith({int? id}) => FooddbViewData(
        id: id ?? this.id,
      );
  @override
  String toString() {
    return (StringBuffer('FooddbViewData(')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FooddbViewData && other.id == this.id);
}

class $FooddbViewView extends ViewInfo<$FooddbViewView, FooddbViewData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$Database attachedDatabase;
  $FooddbViewView(this.attachedDatabase, [this._alias]);
  $FooddbTable get fooddb => attachedDatabase.fooddb.createAlias('t0');
  @override
  List<GeneratedColumn> get $columns => [fooddb.id];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'fooddb_view';
  @override
  String? get createViewStmt => null;
  @override
  $FooddbViewView get asDslTable => this;
  @override
  FooddbViewData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FooddbViewData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  late final GeneratedColumn<int?> id =
      GeneratedColumn<int?>('id', aliasedName, false, type: const IntType());
  @override
  $FooddbViewView createAlias(String alias) {
    return $FooddbViewView(attachedDatabase, alias);
  }

  @override
  Query? get query =>
      (attachedDatabase.selectOnly(fooddb, includeJoinedTableColumns: false)
        ..addColumns($columns));
  @override
  Set<String> get readTables => const {'fooddb'};
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $FooddbTable fooddb = $FooddbTable(this);
  late final $FooddbViewView fooddbView = $FooddbViewView(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [fooddb, fooddbView];
}
