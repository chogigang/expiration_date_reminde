import 'package:drift/native.dart';
import 'package:expiration_date/data/fooddb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'dart:io';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file,
        logStatements: true); // Enable logging for debugging
  });
}

@DriftDatabase(tables: [Fooddb])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  // Singleton pattern
  static final MyDatabase _instance = MyDatabase._internal();
  factory MyDatabase.getInstance() => _instance;
  MyDatabase._internal() : super(_openConnection());

  //CRUD operations

  //Create
  Future<int> addFooddb(FooddbCompanion entry) {
    return transaction(() async {
      return await into(fooddb).insert(entry);
    });
  }

  // Read
  Future<List<FooddbData>> get allFooddbEntries => select(fooddb).get();

  //Update
  Future<bool> updateFooddb(FooddbCompanion data) {
    return transaction(() async {
      return await update(fooddb).replace(data);
    });
  }

  // Delete
  Future<int> deleteFooddb(FooddbData data) {
    return transaction(() async {
      return await delete(fooddb).delete(data);
    });
  }

  @override
  int get schemaVersion => 1;

  Future<List<FooddbData>> getAllFooddb() async {
    return await select(fooddb).get();
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}

// Database provider
class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;
  DatabaseProvider._internal();

  MyDatabase? _database;

  Future<MyDatabase> get database async {
    if (_database != null) return _database!;
    _database = MyDatabase.getInstance();
    return _database!;
  }
}
