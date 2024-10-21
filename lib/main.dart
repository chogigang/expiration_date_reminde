import 'package:expiration_date/data/database.dart';
import 'package:expiration_date/homepage.dart';
import 'package:expiration_date/listpage.dart';
import 'package:expiration_date/service/notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart' as kakao;
import 'service/firebase_options.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'service/local_push_notification.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  Gemini.init(apiKey: 'AIzaSyAHeCeNvPxjzls-jt2ZrQkGxUjdcU91K-Y');
  runApp(const MyApp());
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

  final navigatorKey = GlobalKey<NavigatorState>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    //로컬 푸시 알림 초기화
    await LocalPushNotifications.init();

    //앱이 종료된 상태에서 푸시 알림을 탭할 때
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      Future.delayed(const Duration(seconds: 1), () {
        navigatorKey.currentState!.pushNamed('/message',
            arguments:
                notificationAppLaunchDetails?.notificationResponse?.payload);
      });
    }
    runApp(const MyApp());
  }

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
      home: const ListPage(),
    );
  }
}
