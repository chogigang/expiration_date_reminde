import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
part 'fooddb.g.dart';

class Fooddb extends Table {
  IntColumn get id => integer().autoIncrement()(); //.call() 써서 끝나는걸 보여준다.

  TextColumn get name =>
      text()(); //carvar()대신 text() 사용 .withLength 사용해서 최소 최대 설정 가능

  TextColumn get type => text()(); //종류

  DateTimeColumn get expiry_date => dateTime()(); //유통기한

  IntColumn get alarm_cycle => integer().nullable()(); //알람주기   null 허용

  DateTimeColumn get createdAt =>
      dateTime().withDefault(Constant(DateTime.now()))(); //현제 시간 기록
}

/*

 Id              고유 id 
 Name            이름
 Type            종류 ex) 야채,채소,유제품,과일 등등 
 Expiry_date     유통기한
 Alarm cycle     알람 주기 
  
*/

abstract class FooddbView extends View {
  Fooddb get fooddb;

  @override
  Query as() => select([fooddb.id]).from(fooddb);
}

@DriftDatabase(tables: [Fooddb], views: [FooddbView])
class Database extends _$Database {
  //
  Database() : super(_openConnection()); //LazyDatabase 객체 입력받기

// 쿼리 구현 CRUD

// 조회
  Stream<List<FooddbData>> watchSchedules(DateTime date) =>
      (select(fooddb)..where((tbl) => tbl.expiry_date.equals(date)))
          .watch(); // 데이터를 조회하고 변화를 감지
  //작성 insert 문
  Future<int> createFooddb(FooddbCompanion data) => into(fooddb).insert(data);

  // 업데이트
  Future<bool> updateFooddb(FooddbCompanion data) =>
      update(fooddb).replace(data);

// delete문
  Future<int> removeSchedule(int id) =>
      (delete(fooddb)..where((tbl) => tbl.id.equals(id))).go();

  //테이블 변화 감지를 위한 필수 지정
  @override
  int get schemaVersion => 1;
}

// 데이터베이스 파일 저장할 폴더
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

//flutter pub run build_runner build
//flutter packages pub run build_runner build
