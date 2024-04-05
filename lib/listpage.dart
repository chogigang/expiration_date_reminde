import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ListPage> {
  // 검색어를 저장하는 TextEditingController
  final TextEditingController _searchController = TextEditingController();

  // 리스트 항목 목록
  List<String> _items =
      List<String>.generate(50, (index) => '가로줄 박스 ${index + 1}');

  // 검색 결과를 저장하는 리스트
  List<String> _filteredItems =
      List<String>.generate(50, (index) => '가로줄 박스 ${index + 1}');

  @override
  void initState() {
    super.initState();

    // 검색어 변경 시 필터링된 리스트 업데이트
    _searchController.addListener(() {
      setState(() {
        _filteredItems = _items
            .where((item) => item.contains(_searchController.text))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Container(
              height: 50,
              margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.green[400],
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: '검색',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ), //검색
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.red[400],
                    child: const Center(
                      child: Text(
                        '정렬',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ), //정렬
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 50,
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.blue[400],
                      child: Center(
                        child: Text(
                          _filteredItems[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    onTapDown: (TapDownDetails details) {
                      setState(() {
                        _filteredItems[index] = _filteredItems[index];
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      setState(() {
                        _filteredItems[index] = _filteredItems[index];
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _filteredItems[index] = _filteredItems[index];
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
