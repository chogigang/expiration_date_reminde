import 'package:flutter/material.dart';
import 'package:expiration_date/data/database.dart';
import 'package:expiration_date/detailpage.dart';
import 'package:expiration_date/writepage.dart'; // WritePage import
import 'dart:math';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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
          case 'type':
            return a.type.compareTo(b.type);
          default:
            return 0;
        }
      });
    });
  }

  Color _getGradientColor(DateTime expiryDate) {
    final now = DateTime.now();
    final remainingDays = max(0, expiryDate.difference(now).inDays);

    if (remainingDays <= 7) {
      return Colors.red;
    } else if (remainingDays <= 14) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  void _showDetailBottomSheet(BuildContext context, FooddbData foodItem) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (_, scrollController) {
            return DetailPage(initialFoodItem: foodItem);
          },
        );
      },
    );
    _loadFoodItems(); // 리스트 새로고침
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
                        ListTile(
                          title: const Text('종류순'),
                          onTap: () {
                            _sortFoodItems('type');
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
                final bgColor = _getGradientColor(foodItem.expiry_date);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        stops: [0, 20],
                        colors: [bgColor, Color.fromARGB(0, 255, 255, 255)],
                      ),
                    ),
                    child: ListTile(
                      leading: foodItem.image_data != null
                          ? Image.memory(
                              foodItem.image_data!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : foodItem.image_url != null &&
                                  foodItem.image_url!.isNotEmpty
                              ? Image.network(
                                  foodItem.image_url!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  child: Text(foodItem.name[0].toUpperCase()),
                                ),
                      title: Text(foodItem.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '유통기한: ${foodItem.expiry_date.toIso8601String().split('T')[0]}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            '종류: ${foodItem.type}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () async {
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('삭제 확인'),
                              content: Text('"${foodItem.name}" 항목을 삭제하시겠습니까?'),
                              actions: [
                                TextButton(
                                  child: const Text('취소'),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
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
                            setState(() {
                              _foodItems.remove(foodItem); // 삭제 후 목록 갱신
                            });
                          }
                        },
                      ),
                      onTap: () {
                        _showDetailBottomSheet(context, foodItem);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WritePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
