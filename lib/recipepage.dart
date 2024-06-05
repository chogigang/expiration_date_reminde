import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:expiration_date/recipedetailpage.dart';

class RecipePage extends StatefulWidget {
  final List initialRecipes;
  final String initialSearchQuery;

  const RecipePage(
      {Key? key,
      required this.initialRecipes,
      required this.initialSearchQuery})
      : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final _searchController = TextEditingController();
  List _recipes = [];
  bool _isLoading = false;
  String _message = '검색어를 입력하고 검색 버튼을 눌러주세요.';

  @override
  void initState() {
    super.initState();
    _recipes = widget.initialRecipes;
    _searchController.text = widget.initialSearchQuery;
  }

  Future<void> _showRecipes() async {
    final searchQuery = _searchController.text;
    if (searchQuery.isEmpty) {
      setState(() {
        _message = '검색어를 입력하세요';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    final apiKey = '856346fdbba3479482aa';
    final url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/COOKRCP01/json/1/5/RCP_NM=$searchQuery');
    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('JSON Response: $jsonResponse'); // 응답 출력

        final recipes = jsonResponse['COOKRCP01']?['row'];

        setState(() {
          _isLoading = false;
          if (recipes != null && recipes is List && recipes.isNotEmpty) {
            _recipes = recipes;
            _message = '';
          } else {
            _recipes = [];
            _message = 'No recipes found';
          }
        });
      } else {
        setState(() {
          _isLoading = false;
          _message = 'Failed to load recipes';
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        _isLoading = false;
        _message = 'An error occurred while fetching recipes';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('레시피 목록'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: '레시피 검색',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _showRecipes,
                  child: const Text('검색'),
                ),
              ],
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : _recipes.isEmpty
                  ? Center(child: Text(_message))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _recipes[index];
                          return Card(
                            child: ListTile(
                              title: Text(recipe['RCP_NM']),
                              subtitle: Text(recipe['RCP_WAY2']),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipeDetailPage(recipe: recipe),
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
