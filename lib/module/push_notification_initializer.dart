import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'pushnotification.dart'; // 기존 PushNotification 클래스 가져오기
import 'notification.dart'; // FlutterLocalNotifications 가져오기

class PushNotificationInitializer {
  final GlobalKey<NavigatorState> navigatorKey;

  PushNotificationInitializer(this.navigatorKey);

  Future<void> init() async {
    // FCM 초기화
    await PushNotification.init();
    await PushNotification.localNotiInit();

    // 백그라운드 메시지 핸들러 설정
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 포그라운드 메시지 핸들러 설정
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String payloadData = jsonEncode(message.data);
      print('Got a message in foreground');
      if (message.notification != null) {
        // flutter_local_notifications 패키지 사용
        PushNotification.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }
    });

    // 메시지 상호작용 함수 호출
    setupInteractedMessage();
  }

  // 백그라운드 메시지 핸들러
  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (message.notification != null) {
      print("Notification Received!");
    }
  }

  // 푸시 알림 메시지와 상호작용 정의
  Future<void> setupInteractedMessage() async {
    // 앱이 종료된 상태에서 열릴 때 getInitialMessage 호출
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    // 앱이 백그라운드 상태일 때, 푸시 알림을 탭할 때 RemoteMessage 처리
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // FCM에서 전송한 data를 처리합니다. /message 페이지로 이동하면서 해당 데이터를 화면에 보여줍니다.
  void _handleMessage(RemoteMessage message) {
    Future.delayed(const Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    });
  }
}
