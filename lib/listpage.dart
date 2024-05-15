import 'package:expiration_date/data/database.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("모아보기")),
      body: FutureBuilder<List<FooddbData>>(
        future: MyDatabase().allFooddbEntries, // 데이터베이스에서 모든 식품 정보를 가져옴
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터를 기다리는 동안 로딩 인디케이터를 표시
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final foodItems = snapshot.data ?? []; // 데이터 null 처리
            return ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (_, index) {
                final foodItem = foodItems[index];
                return Card(
                  child: ListTile(
                    title: Text(foodItem.name), // 제목
                    subtitle: Text(
                        '유통기한: ${foodItem.expiry_date.toIso8601String()}'), // 유통기한 내용 (YYYY-MM-DD 형식)
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // 삭제 확인 다이얼로그 추가 (선택사항)
                        final confirmDelete = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('삭제 확인'),
                            content: Text('"${foodItem.name}" 항목을 삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                child: const Text('취소'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: const Text('삭제'),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );
                        if (confirmDelete ?? false) {
                          // 사용자가 삭제 확인 시 데이터베이스에서 삭제
                          await MyDatabase().deleteFooddb(foodItem);
                          // UI 갱신
                          setState(() {});
                        }
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            // 데이터가 없을 경우 메시지 표시
            return const Center(child: Text('저장된 식품 정보가 없습니다.'));
          }
        },
      ),
    );
  }
}
