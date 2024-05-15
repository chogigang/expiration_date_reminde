import 'package:expiration_date/data/database.dart';
import 'package:expiration_date/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart' as kakao;
import 'firebase_options.dart';
import 'package:get_it/get_it.dart';

void main() async {
  // 드리프트 초기화
  final mydatabase = MyDatabase(); //데이터 베이스 생성

  //GetIt에 데이터베이스 주입
  GetIt.I.registerSingleton<MyDatabase>(mydatabase);

  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Kakao SDK 초기화
  kakao.KakaoSdk.init(nativeAppKey: 'f97d27c81aa369408064bb7c68f9fd1e');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
