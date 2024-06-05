// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

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
  final Uint8List? image_data;
  final String? image_url;
  FooddbData(
      {required this.id,
      required this.name,
      required this.type,
      required this.expiry_date,
      this.alarm_cycle,
      required this.createdAt,
      this.image_data,
      this.image_url});
  factory FooddbData.fromData(Map<String, dynamic> data, {String? prefix}) {
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
      image_data: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image_data']),
      image_url: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image_url']),
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
    if (!nullToAbsent || image_data != null) {
      map['image_data'] = Variable<Uint8List?>(image_data);
    }
    if (!nullToAbsent || image_url != null) {
      map['image_url'] = Variable<String?>(image_url);
    }
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
      image_data: image_data == null && nullToAbsent
          ? const Value.absent()
          : Value(image_data),
      image_url: image_url == null && nullToAbsent
          ? const Value.absent()
          : Value(image_url),
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
      image_data: serializer.fromJson<Uint8List?>(json['image_data']),
      image_url: serializer.fromJson<String?>(json['image_url']),
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
      'image_data': serializer.toJson<Uint8List?>(image_data),
      'image_url': serializer.toJson<String?>(image_url),
    };
  }

  FooddbData copyWith(
          {int? id,
          String? name,
          String? type,
          DateTime? expiry_date,
          int? alarm_cycle,
          DateTime? createdAt,
          Uint8List? image_data,
          String? image_url}) =>
      FooddbData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        expiry_date: expiry_date ?? this.expiry_date,
        alarm_cycle: alarm_cycle ?? this.alarm_cycle,
        createdAt: createdAt ?? this.createdAt,
        image_data: image_data ?? this.image_data,
        image_url: image_url ?? this.image_url,
      );
  @override
  String toString() {
    return (StringBuffer('FooddbData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('expiry_date: $expiry_date, ')
          ..write('alarm_cycle: $alarm_cycle, ')
          ..write('createdAt: $createdAt, ')
          ..write('image_data: $image_data, ')
          ..write('image_url: $image_url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, expiry_date, alarm_cycle,
      createdAt, image_data, image_url);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FooddbData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.expiry_date == this.expiry_date &&
          other.alarm_cycle == this.alarm_cycle &&
          other.createdAt == this.createdAt &&
          other.image_data == this.image_data &&
          other.image_url == this.image_url);
}

class FooddbCompanion extends UpdateCompanion<FooddbData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<DateTime> expiry_date;
  final Value<int?> alarm_cycle;
  final Value<DateTime> createdAt;
  final Value<Uint8List?> image_data;
  final Value<String?> image_url;
  const FooddbCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.expiry_date = const Value.absent(),
    this.alarm_cycle = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.image_data = const Value.absent(),
    this.image_url = const Value.absent(),
  });
  FooddbCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required DateTime expiry_date,
    this.alarm_cycle = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.image_data = const Value.absent(),
    this.image_url = const Value.absent(),
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
    Expression<Uint8List?>? image_data,
    Expression<String?>? image_url,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (expiry_date != null) 'expiry_date': expiry_date,
      if (alarm_cycle != null) 'alarm_cycle': alarm_cycle,
      if (createdAt != null) 'created_at': createdAt,
      if (image_data != null) 'image_data': image_data,
      if (image_url != null) 'image_url': image_url,
    });
  }

  FooddbCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<DateTime>? expiry_date,
      Value<int?>? alarm_cycle,
      Value<DateTime>? createdAt,
      Value<Uint8List?>? image_data,
      Value<String?>? image_url}) {
    return FooddbCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      expiry_date: expiry_date ?? this.expiry_date,
      alarm_cycle: alarm_cycle ?? this.alarm_cycle,
      createdAt: createdAt ?? this.createdAt,
      image_data: image_data ?? this.image_data,
      image_url: image_url ?? this.image_url,
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
    if (image_data.present) {
      map['image_data'] = Variable<Uint8List?>(image_data.value);
    }
    if (image_url.present) {
      map['image_url'] = Variable<String?>(image_url.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('image_data: $image_data, ')
          ..write('image_url: $image_url')
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
  final VerificationMeta _image_dataMeta = const VerificationMeta('image_data');
  @override
  late final GeneratedColumn<Uint8List?> image_data =
      GeneratedColumn<Uint8List?>('image_data', aliasedName, true,
          type: const BlobType(), requiredDuringInsert: false);
  final VerificationMeta _image_urlMeta = const VerificationMeta('image_url');
  @override
  late final GeneratedColumn<String?> image_url = GeneratedColumn<String?>(
      'image_url', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        expiry_date,
        alarm_cycle,
        createdAt,
        image_data,
        image_url
      ];
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
    if (data.containsKey('image_data')) {
      context.handle(
          _image_dataMeta,
          image_data.isAcceptableOrUnknown(
              data['image_data']!, _image_dataMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_image_urlMeta,
          image_url.isAcceptableOrUnknown(data['image_url']!, _image_urlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FooddbData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FooddbData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FooddbTable createAlias(String alias) {
    return $FooddbTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $FooddbTable fooddb = $FooddbTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [fooddb];
}
