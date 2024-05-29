import 'package:expiration_date/data/database.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final FooddbData foodItem;

  const DetailPage({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodItem.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '식품 이름: ${foodItem.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '유통기한: ${foodItem.expiry_date.toIso8601String().split('T')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '종류: ${foodItem.type}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '알람 주기: ${foodItem.alarm_cycle ?? '설정되지 않음'}', // null일 경우 '설정되지 않음'을 표시
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '등록일: ${foodItem.createdAt.toIso8601String().split('T')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            // 기타 필요한 정보 추가 가능
          ],
        ),
      ),
    );
  }
}
