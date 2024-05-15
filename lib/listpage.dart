import 'package:expiration_date/data/database.dart';
import 'package:flutter/material.dart';
import 'package:expiration_date/data/fooddb.dart'; // Fooddb 테이블 정의가 포함된 파일

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<ListPage> {
  List<FooddbData> _foodItems = [];
  String _searchTerm = '';
  String _sortOrder = 'name'; // 기본 정렬 순서

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    final allItems = await MyDatabase().allFooddbEntries;
    setState(() {
      _foodItems = allItems;
    });
  }

  void _searchFoodItems(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm.toLowerCase();
    });
  }

  void _sortFoodItems(String sortOrder) {
    setState(() {
      _sortOrder = sortOrder;
      _foodItems.sort((a, b) {
        switch (_sortOrder) {
          case 'name':
            return a.name.compareTo(b.name);
          case 'expiry_date':
            return a.expiry_date.compareTo(b.expiry_date);
          default:
            return 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _foodItems.where((item) {
      return item.name.toLowerCase().contains(_searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("모아보기"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('이름순'),
                          onTap: () {
                            _sortFoodItems('name');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('유통기한순'),
                          onTap: () {
                            _sortFoodItems('expiry_date');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchFoodItems,
              decoration: const InputDecoration(
                labelText: '검색',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (_, index) {
                final foodItem = filteredItems[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(foodItem.name[0].toUpperCase()),
                    ),
                    title: Text(foodItem.name),
                    subtitle: Text(
                      '유통기한: ${foodItem.expiry_date.toIso8601String().split('T')[0]}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirmDelete = await showDialog<bool>(
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
                        if (confirmDelete == true) {
                          await MyDatabase().deleteFooddb(foodItem);
                          setState(() {});
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(foodItem: foodItem),
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

class DetailPage extends StatelessWidget {
  final FooddbData foodItem;

  const DetailPage({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodItem.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '식품 이름: ${foodItem.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '유통기한: ${foodItem.expiry_date.toIso8601String().split('T')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            // 여기에 추가적인 식품 정보를 표시할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
