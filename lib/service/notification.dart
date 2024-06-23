import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 알람
class FlutterLocalNotification {
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    // 안드로이드 셋팅
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings(
            'mipmap/ic_launcher'); //안드로이드 아이콘 설정

// ios  설정
    DarwinInitializationSettings iosInitializationSettings =
        //허용 알림 설정 하시겠습니까? 설정
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    //안드로이드 ,ios 통합 작업
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 권한 요청
  static requestNotificationPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // 메시지 푸쉬 알림을 보여주는 내용 아이디, 이름,아이콘 등등
  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.max,
            showWhen: false);

    //안드로이드는 바로 위에있는 showNotification 위에 설정한걸 사용하고 iossms Darwin을 그냥 바로 사용
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: DarwinNotificationDetails(badgeNumber: 1));

// 알람 내용
    await flutterLocalNotificationsPlugin.show(
        0, '유통기한 알림이', '유통기한이 임박했습니다! ', notificationDetails);
  }
}
