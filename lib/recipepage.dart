// recipe_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:expiration_date/recipedetailpage.dart';
import 'package:expiration_date/data/database.dart';

class RecipePage extends StatefulWidget {
  final List recipes;

  const RecipePage({Key? key, required this.recipes}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final _searchController = TextEditingController();

  Future<void> _showRecipes(BuildContext context) async {
    final apiKey = '856346fdbba3479482aa';
    final url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/COOKRCP01/json/1/5/RCP_NM=${_searchController.text}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final recipes = jsonResponse['COOKRCP01']['row'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipePage(recipes: recipes),
        ),
      );
    } else {
      print('Failed to load recipes');
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
                    decoration: InputDecoration(
                      labelText: '레시피 검색',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _showRecipes(context),
                  child: Text('검색'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.recipes.length,
              itemBuilder: (context, index) {
                final recipe = widget.recipes[index];
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
