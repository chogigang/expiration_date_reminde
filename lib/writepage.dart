import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String result = '';
  final productNameController = TextEditingController();

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
                  padding: EdgeInsets.only(),
                  child: TextField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '식품이름',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '유통기한',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '알람 주기 ',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 0),
                  child: ElevatedButton(
                    onPressed: null,
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

  Future<void> getProduct(String barcode) async {
    var apiKey = '08250c6f4a19422781f0'; // 여기에 실제 API 키를 입력하세요.
    var url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/I2570/json/1/5/BRCD_NO=$barcode');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var productName = jsonResponse['I2570']['row'][0]['PRDT_NM'];
      setState(() {
        productNameController.text = productName;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
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
}
