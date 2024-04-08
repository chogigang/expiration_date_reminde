import 'package:expiration_date/login/kakao_login.dart';
import 'package:expiration_date/login/login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final viewModel = LoginViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Padding(
            // 로고
            padding: EdgeInsets.only(top: 30, left: 0, right: 20.0),
            child: Icon(
              Icons.abc,
              size: 200,
            ), // 로고 들어갈 자리
          ),
          if (viewModel.isLogined &&
              viewModel.user != null) // 로그인되었고 사용자 정보가 있는 경우에만 프로필 이미지 표시
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 0, right: 20.0),
              child: Image.network(
                viewModel.user!.kakaoAccount!.profile!.profileImageUrl ?? '',
                width: 200,
                height: 200,
              ),
            ),
          if (viewModel.isLogined) // 로그인된 경우에만 로그아웃 버튼 표시
            Padding(
              padding: const EdgeInsets.only(top: 100, right: 0.0),
              child: ElevatedButton(
                onPressed: () async {
                  await viewModel.logout();
                  setState(() {});
                },
                child: const Text("카카오 로그아웃"),
              ),
            ),
          if (!viewModel.isLogined) // 로그인되지 않은 경우에만 로그인 버튼 표시
            Padding(
              padding: const EdgeInsets.only(top: 100, right: 0.0),
              child: ElevatedButton(
                onPressed: () async {
                  await viewModel.login();
                  setState(() {});
                },
                child: const Text("카카오 로그인"),
              ),
            ),
        ],
      ),
    );
  }
}
