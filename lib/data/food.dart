// import 'database.dart';
// import 'package:moor/moor.dart';

// part 'food.g.dart';

// //

// class Food extends Table {
//   IntColumn get id => integer()
//       .autoIncrement()(); //dart에서 .call() 을 해줘서 끝나는지 알려줘야함 call 을 생략하고 ()도 가능

//   TextColumn get name => text().withLength(
//       min: 0, max: 20)(); //carvar()대신 text() 사용 .withLength 사용해서 최소 최대 설정 가능

//   TextColumn get type => text().withLength()(); //종류

//   DateTimeColumn get expiry_date => dateTime().nullable()(); //유통기한

//   IntColumn get alarm_cycle => integer().nullable()(); //알람주기

//   DateTimeColumn get createdAt =>
//       dateTime().withDefault(Constant(DateTime.now()))(); //현제 시간 기록

    
// }

// /*

//  Id              고유 id 
//  Name            이름
//  Type            종류 ex) 야채,채소,유제품,과일 등등 
//  Expiry_date     유통기한
//  Alarm cycle     알람 주기 
  
// */

// @UseDao(tables: [Food])
// class FoodDao {

// }
