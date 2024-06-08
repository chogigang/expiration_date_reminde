import 'dart:convert';
import 'package:expiration_date/data/database.dart';
import 'package:expiration_date/homepage.dart';
import 'package:expiration_date/module/notification.dart';
import 'package:expiration_date/module/push_notification_initializer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart' as kakao;
import 'module/firebase_options.dart';
import 'package:get_it/get_it.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // 드리프트 초기화
  final mydatabase = MyDatabase(); // 데이터 베이스 생성

  // GetIt에 데이터베이스 주입
  GetIt.I.registerSingleton<MyDatabase>(mydatabase);

  WidgetsFlutterBinding.ensureInitialized();

  // Kakao SDK 초기화
  kakao.KakaoSdk.init(nativeAppKey: 'f97d27c81aa369408064bb7c68f9fd1e');

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 알림 초기화
  final pushNotificationInitializer = PushNotificationInitializer(navigatorKey);
  await pushNotificationInitializer.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 초기화
    FlutterLocalNotification.init();
    // 3초 후 권한 요청
    Future.delayed(const Duration(seconds: 3), () {
      FlutterLocalNotification.requestNotificationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const HomePage(),
    );
  }
}
