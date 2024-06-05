import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final Map recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['RCP_NM']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                recipe['RCP_NM'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '조리법: ${recipe['RCP_WAY2']}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                '재료: ${recipe['RCP_PARTS_DTLS']}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              const Text(
                '조리 방법:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._buildCookingSteps(recipe),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCookingSteps(Map recipe) {
    List<Widget> steps = [];
    for (int stepNumber = 1; stepNumber <= 20; stepNumber++) {
      String stepKey =
          'MANUAL' + (stepNumber < 10 ? '0' : '') + stepNumber.toString();
      String imgKey =
          'MANUAL_IMG' + (stepNumber < 10 ? '0' : '') + stepNumber.toString();
      String? stepText = recipe[stepKey];
      String? stepImgUrl = recipe[imgKey];
      if (stepText != null && stepText.isNotEmpty) {
        steps.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step $stepNumber: $stepText',
                  style: const TextStyle(fontSize: 16),
                ),
                if (stepImgUrl != null && stepImgUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.network(stepImgUrl),
                  ),
              ],
            ),
          ),
        );
      }
    }
    return steps;
  }
}
