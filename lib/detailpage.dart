import 'package:expiration_date/recipepage.dart';
import 'package:flutter/material.dart';
import 'package:expiration_date/data/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'module/notification.dart';

class DetailPage extends StatelessWidget {
  final FooddbData foodItem;

  const DetailPage({Key? key, required this.foodItem}) : super(key: key);

  Future<void> _showRecipes(BuildContext context, String searchQuery) async {
    final apiKey = '856346fdbba3479482aa';
    final url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/COOKRCP01/json/1/5/RCP_NM=$searchQuery');
    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('JSON Response: $jsonResponse'); // 응답 출력

        final recipes = jsonResponse['COOKRCP01']?['row'];

        if (recipes != null && recipes is List) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipePage(
                  initialRecipes: recipes, initialSearchQuery: searchQuery),
            ),
          );
        } else {
          print('No recipes found');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No recipes found')),
          );
        }
      } else {
        print('Failed to load recipes');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load recipes')),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while fetching recipes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodItem.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 알람 임시 테스트
            TextButton(
              onPressed: () => FlutterLocalNotification.showNotification(),
              child: const Text("알림 보내기"),
            ),
            if (foodItem.image_data != null) Image.memory(foodItem.image_data!),
            if (foodItem.image_url != null && foodItem.image_url!.isNotEmpty)
              Image.network(foodItem.image_url!),
            const SizedBox(height: 10),
            Text(
              '식품 이름: ${foodItem.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '유통기한: ${foodItem.expiry_date.toIso8601String().split('T')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '종류: ${foodItem.type}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '알람 주기: ${foodItem.alarm_cycle ?? '설정되지 않음'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '등록일: ${foodItem.createdAt.toIso8601String().split('T')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showRecipes(context, foodItem.name),
              child: const Text('레시피 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
