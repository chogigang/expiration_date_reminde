import 'dart:convert';
import 'dart:typed_data';
import 'package:expiration_date/UpdateFoodItem.dart';
import 'package:flutter/material.dart';
import 'package:expiration_date/data/database.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:expiration_date/service/local_push_notification.dart';
import 'package:expiration_date/service/notification.dart';
import 'package:expiration_date/recipepage.dart';

class DetailPage extends StatefulWidget {
  final FooddbData initialFoodItem;

  const DetailPage({Key? key, required this.initialFoodItem}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late FooddbData _foodItem;

  @override
  void initState() {
    super.initState();
    _foodItem = widget.initialFoodItem;
    listenNotifications();
  }

  void listenNotifications() {
    LocalPushNotifications.notificationStream.stream.listen((String? payload) {
      if (payload != null) {
        print('Received payload: $payload');
        Navigator.pushNamed(context, '/message', arguments: payload);
      }
    });
  }

  Future<void> _showRecipes(BuildContext context, String searchQuery) async {
    final apiKey = '856346fdbba3479482aa'; // API 키
    final url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/COOKRCP01/json/1/5/RCP_NM=$searchQuery'); // 레시피 검색 URL

    try {
      final response = await http.get(url); // HTTP GET 요청

      print('Response status: ${response.statusCode}'); // 응답 상태 코드 출력
      print('Response body: ${response.body}'); // 응답 본문 출력

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body); // JSON 디코딩
        print('JSON Response: $jsonResponse'); // 디코딩된 JSON 출력

        final recipes = jsonResponse['COOKRCP01']?['row']; // 레시피 데이터 추출

        if (recipes != null && recipes is List) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipePage(
                  initialRecipes: recipes,
                  initialSearchQuery: searchQuery), // 레시피 페이지로 이동
            ),
          );
        } else {
          print('해당 레시피가 없습니다.'); // 레시피가 없을 경우 출력
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('해당 레시피가 없습니다.')), // 스낵바 표시
          );
        }
      } else {
        print('요청 실패'); // 요청 실패 시 출력
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('레시피 요청 실패')), // 스낵바 표시
        );
      }
    } catch (e) {
      print('Error occurred: $e'); // 예외 발생 시 출력
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('An error occurred while fetching recipes')), // 스낵바 표시
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_foodItem.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () => FlutterLocalNotification.showNotification(),
              child: const Text("알람버튼"),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     LocalPushNotifications.showSimpleNotification(
            //         title: "유통기한 알람",
            //         body: "유통기한 임박!",
            //         payload: "Regular Notification Data");
            //   },
            //   child: const Text('알람 버튼 2'),
            // ),
            if (_foodItem.image_data != null)
              Image.memory(_foodItem.image_data!),
            if (_foodItem.image_url != null && _foodItem.image_url!.isNotEmpty)
              Image.network(_foodItem.image_url!),
            const SizedBox(height: 10),
            Text(
              '이름 : ${_foodItem.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '유통기한 날짜 : ${_foodItem.expiry_date.toIso8601String().split('T')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '종류 : ${_foodItem.type}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '알람 주기 : ${_foodItem.alarm_cycle ?? 'Not set'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '작성 날짜 : ${_foodItem.createdAt.toIso8601String().split('T')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showRecipes(context, _foodItem.name),
              child: const Text('레시피 보기'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateFoodItem(foodItem: _foodItem),
                  ),
                );
                if (result == true) {
                  // 수정이 완료되면 리스트 페이지 새로 고침
                  setState(() {
                    // UI 업데이트
                  });
                }
              },
              child: const Text('수정하기'),
            ),
          ],
        ),
      ),
    );
  }
}
