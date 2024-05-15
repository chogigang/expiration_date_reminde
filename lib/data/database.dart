import 'package:drift/native.dart';
import 'package:expiration_date/data/fooddb.dart'; // Ensure this file contains the Fooddb table definition
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'dart:io';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Fooddb])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

//CRUD 작성
  //create
  Future<int> addFooddb(FooddbCompanion entry) {
    return into(fooddb).insert(entry);
  }

  // List
  Future<List<FooddbData>> get allFooddbEntries => select(fooddb).get();

  //Update
  Future<bool> updateFooddb(FooddbCompanion data) =>
      update(fooddb).replace(data);

  // delete
  Future<int> deleteFooddb(FooddbData data) {
    return delete(fooddb).delete(data);
  }

  @override
  int get schemaVersion => 1;

  getAllFooddb() {}
}
