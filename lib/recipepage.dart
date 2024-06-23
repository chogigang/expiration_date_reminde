import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:expiration_date/recipedetailpage.dart';

// RecipePage 클래스 정의, StatefulWidget을 상속받음
class RecipePage extends StatefulWidget {
  final List initialRecipes; // 초기 레시피 목록
  final String initialSearchQuery; // 초기 검색어

  // 생성자에서 초기 레시피 목록과 검색어를 받아옴
  const RecipePage(
      {Key? key,
      required this.initialRecipes,
      required this.initialSearchQuery})
      : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

// RecipePage의 상태를 관리하는 _RecipePageState 클래스
class _RecipePageState extends State<RecipePage> {
  final _searchController = TextEditingController(); // 검색어 입력 필드 컨트롤러
  List _recipes = []; // 레시피 목록을 저장하는 리스트
  bool _isLoading = false; // 로딩 상태를 나타내는 변수
  String _message = '검색어를 입력하고 검색 버튼을 눌러주세요.'; // 메시지를 저장하는 변수

  @override
  void initState() {
    super.initState();
    _recipes = widget.initialRecipes; // 초기 레시피 목록 설정
    _searchController.text = widget.initialSearchQuery; // 초기 검색어 설정
  }

  // 레시피를 검색하는 메서드
  Future<void> _showRecipes() async {
    final searchQuery = _searchController.text; // 검색어 가져오기
    if (searchQuery.isEmpty) {
      setState(() {
        _message = '검색어를 입력하세요'; // 검색어가 비어있을 때 메시지 설정
      });
      return;
    }

    setState(() {
      _isLoading = true; // 로딩 상태로 설정
      _message = ''; // 메시지 초기화
    });

    final apiKey = '856346fdbba3479482aa'; // API 키
    final url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/COOKRCP01/json/1/5/RCP_NM=$searchQuery'); // API 요청 URL
    try {
      final response = await http.get(url); // HTTP GET 요청

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body); // JSON 응답 디코딩
        print('JSON Response: $jsonResponse');

        final recipes = jsonResponse['COOKRCP01']?['row']; // 레시피 데이터 추출

        setState(() {
          _isLoading = false; // 로딩 상태 해제
          if (recipes != null && recipes is List && recipes.isNotEmpty) {
            _recipes = recipes; // 레시피 목록 설정
            _message = ''; // 메시지 초기화
          } else {
            _recipes = []; // 레시피 목록 초기화
            _message = 'No recipes found'; // 레시피를 찾을 수 없을 때 메시지 설정
          }
        });
      } else {
        setState(() {
          _isLoading = false; // 로딩 상태 해제
          _message = 'Failed to load recipes'; // 요청 실패 시 메시지 설정
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        _isLoading = false; // 로딩 상태 해제
        _message = 'An error occurred while fetching recipes'; // 에러 발생 시 메시지 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('레시피 목록'), // 앱바 제목 설정
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0), // 패딩 추가
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _searchController, // 검색어 입력 필드 컨트롤러 설정
                    decoration: const InputDecoration(
                      labelText: '레시피 검색', // 입력 필드 라벨 텍스트
                    ),
                  ),
                ),
                const SizedBox(width: 10), // 간격 추가
                ElevatedButton(
                  onPressed: _showRecipes, // 버튼 클릭 시 레시피 검색
                  child: const Text('검색'), // 버튼 텍스트
                ),
              ],
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator() // 로딩 중일 때 로딩 인디케이터 표시
              : _recipes.isEmpty
                  ? Center(child: Text(_message)) // 레시피가 없을 때 메시지 표시
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _recipes.length, // 레시피 개수 설정
                        itemBuilder: (context, index) {
                          final recipe = _recipes[index]; // 레시피 데이터 가져오기
                          return Card(
                            child: ListTile(
                              title: Text(recipe['RCP_NM']), // 레시피 이름 표시
                              subtitle: Text(recipe['RCP_WAY2']), // 조리법 표시
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailPage(
                                        recipe: recipe), // 레시피 상세 페이지로 이동
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
