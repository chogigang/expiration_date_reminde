import 'package:expiration_date/listpage.dart';
import 'package:expiration_date/writepage.dart';
import 'package:flutter/material.dart';
import 'package:expiration_date/firstpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구성'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            //맨위쪽 Row
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼을 양쪽 끝에 배치
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListPage()), //화면 전환
                    );
                  },
                  child: const Text("모아보기"),
                ),
              ),
              Padding(
                //임시 첫번째 페이지

                padding: const EdgeInsets.only(left: 0, right: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FristPage()), //화면 전환
                    );
                  },
                  child: const Text("임시 첫번째 페이지"),
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
          ), //1번째 Row 끝
          const Row(
            //2번째 Row 좌우 화살표 버튼, 식품 아이콘
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼을 양쪽 끝에 배치
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30, left: 20.0, right: 0),
                child: IconButton(
                  // 왼쪽 화살표
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_left,
                    size: 50,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                ),
                child: Icon(
                  //나중에 교체
                  Icons.abc,
                  size: 200,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 0, right: 20.0),
                child: IconButton(
                  //오른쪽 화살표
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_right,
                    size: 50,
                  ),
                ),
              ),
            ],
          ), // 2번째 Row 끝
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '식품 이름',
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '유통기한',
              ),
            ),
          ),
          Row(
            // 레시피,음식물 페기방법,정보수정
            children: <Widget>[
              const Center(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 5),
                child: Container(
                  width: 120, // 버튼의 너비를 지정합니다.
                  height: 60, // 버튼의 높이를 지정합니다.
                  child: const ElevatedButton(
                    onPressed: null,
                    child: Text("레시피 추천"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 5),
                child: Container(
                  width: 120, // 버튼의 너비를 지정합니다.
                  height: 60, // 버튼의 높이를 지정합니다.
                  child: const ElevatedButton(
                    onPressed: null,
                    child: Text("음식물 페기방법"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 0),
                child: Container(
                  width: 120, // 버튼의 너비를 지정합니다.
                  height: 60, // 버튼의 높이를 지정합니다.
                  child: const ElevatedButton(
                    onPressed: null,
                    child: Text("정보 수정"),
                  ),
                ),
              ),
            ],
          ), // 레시피,음식물 페기방법,정보수정
        ],
      ),
    );
  }
}




//홈화면 구성

/*
 StatefulWidget  은 무조건    State<HomePage> createState() {
    return _같은 클래스 이름(); 
  }
을 만든후   @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return

    이후 return 안에 코딩을 한다 이거 크게 햇갈릴수가 있다 .
    2024 03 22 
    크게 Column 으로 세로로 큰 박스를 만들고 가로로 화면을 체우는 식을 알아채기 까지 3시간 걸림 

 */
