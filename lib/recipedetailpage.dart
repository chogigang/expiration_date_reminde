import 'package:flutter/material.dart';

// RecipeDetailPage 클래스 정의, StatelessWidget을 상속받음
class RecipeDetailPage extends StatelessWidget {
  final Map recipe; // 레시피 데이터를 담는 맵

  // 생성자에서 레시피 데이터를 받아옴
  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['RCP_NM']), // 앱바에 레시피 이름 표시
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 패딩 추가
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 레시피 이름 표시
              Text(
                recipe['RCP_NM'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // 조리법 표시
              Text(
                '조리법: ${recipe['RCP_WAY2']}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              // 재료 표시
              Text(
                '재료: ${recipe['RCP_PARTS_DTLS']}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              // 조리 방법 제목
              const Text(
                '조리 방법:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // 조리 단계 위젯 생성 및 추가
              ..._buildCookingSteps(recipe),
            ],
          ),
        ),
      ),
    );
  }

  // 조리 단계 위젯 리스트를 생성하는 메서드
  List<Widget> _buildCookingSteps(Map recipe) {
    List<Widget> steps = []; // 조리 단계 위젯을 담을 리스트
    for (int stepNumber = 1; stepNumber <= 20; stepNumber++) {
      String stepKey = 'MANUAL' +
          (stepNumber < 10 ? '0' : '') +
          stepNumber.toString(); // 단계 키 생성
      String imgKey = 'MANUAL_IMG' +
          (stepNumber < 10 ? '0' : '') +
          stepNumber.toString(); // 이미지 키 생성
      String? stepText = recipe[stepKey]; // 단계 텍스트
      String? stepImgUrl = recipe[imgKey]; // 단계 이미지 URL
      if (stepText != null && stepText.isNotEmpty) {
        steps.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 단계 텍스트 표시
                Text(
                  'Step $stepNumber: $stepText',
                  style: const TextStyle(fontSize: 16),
                ),
                // 단계 이미지 표시
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
    return steps; // 단계 위젯 리스트 반환
  }
}
