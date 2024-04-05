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
            //임시 로고
            padding: EdgeInsets.only(top: 30, left: 0, right: 20.0),
            child: Icon(
              Icons.abc,
              size: 200,
            ), //로고 들어갈 자리
          ),
          Image.network(
            //카톡 프로필 불러오기
            viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? '',
            width: 200, height: 200,
          ),
          Text('${viewModel.isLogined}'),
          Padding(
            padding: EdgeInsets.only(top: 100, right: 0.0),
            child: viewModel.isLogined
                ? ElevatedButton(
                    onPressed: () async {
                      await viewModel.logout();
                      setState(() {});
                    },
                    child: const Text("카카오 로그아웃"),
                  )
                : ElevatedButton(
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
