// detail_page.dart
import 'package:expiration_date/recipepage.dart';
import 'package:flutter/material.dart';
import 'package:expiration_date/data/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatelessWidget {
  final FooddbData foodItem;

  const DetailPage({Key? key, required this.foodItem}) : super(key: key);

  Future<void> _showRecipes(BuildContext context, String searchQuery) async {
    final apiKey = '856346fdbba3479482aa';
    final url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/COOKRCP01/json/1/5/RCP_NM=$searchQuery');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final recipes = jsonResponse['COOKRCP01']['row'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipePage(recipes: recipes),
        ),
      );
    } else {
      print('Failed to load recipes');
    }
  }

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
              '알람 주기: ${foodItem.alarm_cycle ?? '설정되지 않음'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '등록일: ${foodItem.createdAt.toIso8601String().split('T')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showRecipes(context, foodItem.name),
              child: Text('레시피 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
