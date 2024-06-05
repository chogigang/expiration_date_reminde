import 'package:drift/drift.dart';

class Fooddb extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get type => text()();

  DateTimeColumn get expiry_date => dateTime()();

  IntColumn get alarm_cycle => integer().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(Constant(DateTime.now()))();

  BlobColumn get image_data => blob().nullable()(); // 이미지 바이너리 데이터

  TextColumn get image_url => text().nullable()(); // 이미지 URL

  // @override
  // Set<Column> get primaryKey => {id};
}

/*

 Id              고유 id 
 Name            이름
 Type            종류 ex) 야채,채소,유제품,과일 등등 
 Expiry_date     유통기한
 Alarm cycle     알람 주기 
  
*/

// abstract class FooddbView extends View {
//   Fooddb get fooddb;

//   @override
//   Query as() => select([fooddb.id]).from(fooddb);
// }

// // 싱글톤 패턴을 사용하여 Database 클래스의 인스턴스를 한 번만 생성
// @DriftDatabase(tables: [Fooddb], views: [FooddbView])
// class Database extends _$Database {
//   static final Database _instance = Database._internal();

//   Database._internal() : super(_openConnection());

//   factory Database() {
//     return _instance;
//   }

// //쿼리 구현 CRUD

// // 조회
//   Stream<List<FooddbData>> watchSchedules(DateTime date) =>
//       (select(fooddb)..where((tbl) => tbl.expiry_date.equals(date)))
//           .watch(); // 데이터를 조회하고 변화를 감지
//   //작성 insert 문
//   Future<int> createFooddb(FooddbCompanion data) => into(fooddb).insert(data);

//   // 업데이트
//   Future<bool> updateFooddb(FooddbCompanion data) =>
//       update(fooddb).replace(data);

// // delete문
//   Future<int> removeSchedule(int id) =>
//       (delete(fooddb)..where((tbl) => tbl.id.equals(id))).go();

//   //테이블 변화 감지를 위한 필수 지정
//   @override
//   int get schemaVersion => 1;

//   getAllFooddb() {}
// }

// // 데이터베이스 파일 저장할 폴더
// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'db.sqlite'));
//     return NativeDatabase(file);
//   });
//}

// //flutter pub run build_runner build
// //flutter packages pub run build_runner build
