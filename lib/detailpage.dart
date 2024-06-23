import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 라이브러리
import 'dart:typed_data'; // 바이트 데이터 처리를 위한 라이브러리

import 'package:flutter/material.dart'; // Flutter의 주요 UI 라이브러리
import 'package:expiration_date/data/database.dart'; // 데이터베이스 관련 클래스 임포트
import 'package:http/http.dart' as http; // HTTP 요청을 위한 라이브러리
import 'package:html/parser.dart' as parser; // HTML 파싱을 위한 라이브러리
import 'package:expiration_date/module/local_push_notification.dart'; // 로컬 푸시 알림 모듈 임포트
import 'package:expiration_date/module/notification.dart'; // 알림 관련 모듈 임포트
import 'package:expiration_date/recipepage.dart'; // 레시피 페이지 관련 클래스 임포트

// DetailPage 클래스 정의, StatefulWidget을 상속받음
class DetailPage extends StatefulWidget {
  final FooddbData foodItem; // foodItem을 DetailPage 생성자에서 받음

  const DetailPage({Key? key, required this.foodItem}) : super(key: key);

  @override
  _DetailPageState createState() =>
      _DetailPageState(); // _DetailPageState 클래스 생성
}

// _DetailPageState 클래스 정의
class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    listenNotifications(); // 알림 리스너 설정
    super.initState(); // 부모 클래스의 initState 호출
  }

  // 알림 수신 리스너 설정
  void listenNotifications() {
    LocalPushNotifications.notificationStream.stream.listen((String? payload) {
      if (payload != null) {
        print('Received payload: $payload'); // 수신된 페이로드 출력
        Navigator.pushNamed(context, '/message',
            arguments: payload); // 특정 경로로 네비게이트
      }
    });
  }

  // 레시피 정보를 가져와서 화면에 표시하는 메서드
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

  // 위젯 빌드 메서드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodItem.name), // 앱바에 음식 이름 표시
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 알림 버튼
            TextButton(
              onPressed: () => FlutterLocalNotification.showNotification(),
              child: const Text("알람버튼"),
            ),
            // 알람 버튼 2
            ElevatedButton(
              onPressed: () {
                LocalPushNotifications.showSimpleNotification(
                    title: "유통기한 알람",
                    body: "유통기한 임박!",
                    payload: "Regular Notification Data");
              },
              child: const Text('알람 버튼 2'),
            ),
            // 이미지가 있으면 표시
            if (widget.foodItem.image_data != null)
              Image.memory(widget.foodItem.image_data!),
            if (widget.foodItem.image_url != null &&
                widget.foodItem.image_url!.isNotEmpty)
              Image.network(widget.foodItem.image_url!),
            const SizedBox(height: 10),
            // 음식 이름 표시
            Text(
              '이름 : ${widget.foodItem.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // 유통기한 표시
            Text(
              '날짜 : ${widget.foodItem.expiry_date.toIso8601String().split('T')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // 음식 종류 표시
            Text(
              '종류 : ${widget.foodItem.type}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // 알람 주기 표시
            Text(
              '알람 주기 : ${widget.foodItem.alarm_cycle ?? 'Not set'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // 생성 날짜 표시
            Text(
              '유통기한 날짜 : ${widget.foodItem.createdAt.toIso8601String().split('T')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // 레시피 보기 버튼
            ElevatedButton(
              onPressed: () => _showRecipes(context, widget.foodItem.name),
              child: const Text('레시피 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
