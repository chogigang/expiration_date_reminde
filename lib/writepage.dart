import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:expiration_date/data/fooddb.dart';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String result = '';
  final productNameController = TextEditingController();
  final expiryDateController = TextEditingController();
  final alarmCycleController = TextEditingController();
  String imageUrl = '';

  Future<void> getProduct(String barcode) async {
    var apiKey = '08250c6f4a19422781f0';
    var url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/I2570/json/1/5/BRCD_NO=$barcode');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var productName = jsonResponse['I2570']['row'][0]['PRDT_NM'];
      setState(() {
        productNameController.text = productName;
      });
      fetchGoogleImages(productName);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> fetchGoogleImages(String keyword) async {
    final response = await http
        .get(Uri.parse('https://www.google.com/search?q=$keyword&tbm=isch'));
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final elements = document.getElementsByTagName('img');
      final urls = elements
          .map((element) => element.attributes['src'])
          .where((src) => src != null && src.startsWith('http'))
          .toList();
      if (urls.isNotEmpty) {
        setState(() {
          imageUrl = urls.first!;
        });
      }
    } else {
      throw Exception('Failed to load images');
    }
  }

  Widget _buildCircle(
      Alignment alignment, double size, Color color, Function onPressed) {
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            image: imageUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleWithIcon(Alignment alignment, double size, Color color,
      Function onPressed, IconData icon) {
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          _buildCircle(Alignment(0, -0.6), 180, Colors.black, () {}),
          _buildCircleWithIcon(
            Alignment(0.3, -0.3),
            50,
            Colors.grey,
            () async {
              var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ),
              );
              setState(() {
                if (res is String) {
                  result = res;
                  getProduct(result);
                }
              });
            },
            Icons.add,
          ),
          Align(
            alignment: Alignment(0, 0.65),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(),
                  child: TextField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '식품이름',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: TextField(
                    controller: expiryDateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '유통기한',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: TextField(
                    controller: alarmCycleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '알람 주기 ',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      String productName = productNameController.text;
                      String expiryDate = expiryDateController.text;
                      String alarmCycle = alarmCycleController.text;

                      Database db = Database();
                      int? alarmCycleInt = int.tryParse(alarmCycle);
                      FooddbCompanion newFood = FooddbCompanion.insert(
                        name: productName,
                        expiry_date: DateTime.parse(expiryDate),
                        alarm_cycle: drift.Value(alarmCycleInt),
                        type: '',
                      );
                      int id = await db.createFooddb(newFood); // await 키워드 추가

                      if (id > 0) {
                        // 데이터가 성공적으로 추가되었는지 확인
                        print('항목이 성공적으로 추가되었습니다. ID: $id');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('알림'),
                              content: Text('항목이 성공적으로 추가되었습니다.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // 데이터 추가 실패
                        print('항목 추가에 실패했습니다.');
                      }

                      productNameController.clear();
                      expiryDateController.clear();
                      alarmCycleController.clear();
                    },
                    child: Text("등록하기"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
