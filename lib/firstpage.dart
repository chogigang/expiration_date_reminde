import 'package:expiration_date/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:expiration_date/writepage.dart';

class FristPage extends StatelessWidget {
  const FristPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            // 최상단 버튼
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                //로그인 버튼
                padding: const EdgeInsets.only(left: 10, top: 30.0, right: 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()), //화면 전환
                    );
                  },
                  child: const Text("로그인"),
                ),
              ),
              Padding(
                //음식 등록 가기 버튼
                padding: const EdgeInsets.only(left: 0, right: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WritePage()), //화면 전환
                    );
                  },
                  child: const Text("등록"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
