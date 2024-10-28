import 'dart:typed_data';
import 'package:expiration_date/data/database.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:expiration_date/service/cameraservice.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_gemini/flutter_gemini.dart';

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
  final typeController = TextEditingController();
  String imageUrl = '';
  Uint8List? imageData;

  final CameraService _cameraService = CameraService();

  @override
  void initState() {
    super.initState();
    _cameraService.initCamera().then((_) {
      setState(() {});
    });

    // 제품 이름이 변경될 때마다 종류를 가져오도록 리스너 추가
    productNameController.addListener(() {
      if (productNameController.text.isNotEmpty) {
        getFoodTypeFromGemini(productNameController.text);
      } else {
        typeController.clear(); // 비어있으면 종류 입력란도 비우기
      }
    });
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _startCameraPreview(BuildContext context) async {
    await _cameraService.startCameraPreview(context, (imageData, date) {
      setState(() {
        this.imageData = imageData;
        imageUrl = '';
        getFoodNameFromGemini(imageData!);
      });
    });
  }

  Future<void> _startExpiryDateCameraPreview(BuildContext context) async {
    await _cameraService.startCameraPreview(context, (imageData, date) {
      setState(() {
        expiryDateController.text = date ?? "Date not found";
      });
    });
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        expiryDateController.text =
            pickedDate.toLocal().toIso8601String().split('T')[0];
      });
    }
  }

  void updateImageUrl(String url) {
    setState(() {
      imageUrl = url;
      imageData = null;
    });
  }

  Future<void> getFoodNameFromGemini(Uint8List imageData) async {
    try {
      final gemini = Gemini.instance;
      final response = await gemini.textAndImage(
        text: "이 음식의 이름이 무엇인지, 단답형으로, 한글로 이름만 딱 말해줘",
        images: [imageData],
      );
      String? foodName = response?.content?.parts?.last.text;

      if (foodName != null) {
        setState(() {
          productNameController.text = foodName;
        });
      }
    } catch (e) {
      print('Error during food recognition: $e');
    }
  }

  Future<void> getFoodTypeFromGemini(String foodName) async {
    try {
      final gemini = Gemini.instance;
      final response = await gemini.textAndImage(
        text:
            "이 식품 '$foodName'의 종류가 무엇인지 단답형으로 대답해. 예를 들어 양파는 야채, 우유는 유제품이 되겠지?",
        images: [],
      );

      // 응답 로그 추가
      print('Gemini API Response: ${response?.content?.parts?.last.text}');

      String? foodType = response?.content?.parts?.last.text;
      if (foodType != null) {
        setState(() {
          typeController.text = foodType; // 인식된 종류 설정
        });
      }
    } catch (e) {
      print('Error during food type recognition: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, -0.6),
            child: Stack(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )
                        : imageData != null
                            ? DecorationImage(
                                image: MemoryImage(imageData!),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: InkWell(
                    onTap: () async {
                      var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SimpleBarcodeScannerPage(),
                        ),
                      );
                      setState(() {
                        if (res is String) {
                          result = res;
                          _cameraService.getProduct(
                              result, productNameController, updateImageUrl);
                        }
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.65),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: productNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '식품이름',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () async {
                          await _startCameraPreview(context);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TextField(
                    controller: typeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '종류',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expiryDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '유통기한',
                          ),
                          onTap: () => _selectExpiryDate(context),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _startExpiryDateCameraPreview(context),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TextField(
                    controller: alarmCycleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '알람주기(일)',
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
                      String type = typeController.text;

                      MyDatabase db = MyDatabase();
                      int? alarmCycleInt = int.tryParse(alarmCycle);
                      FooddbCompanion newFood = FooddbCompanion.insert(
                        name: productName,
                        expiry_date: DateTime.parse(expiryDate),
                        alarm_cycle: drift.Value(alarmCycleInt),
                        type: type,
                        image_data: drift.Value(imageData),
                        image_url: drift.Value(imageUrl),
                      );
                      int id = await db.addFooddb(newFood);

                      if (id > 0) {
                        print('항목이 성공적으로 추가되었습니다. ID: $id');
                        Navigator.of(context).pop(true);
                      } else {
                        print('항목 추가에 실패했습니다.');
                      }

                      productNameController.clear();
                      expiryDateController.clear();
                      alarmCycleController.clear();
                      typeController.clear();
                      setState(() {
                        imageData = null;
                        imageUrl = '';
                      });
                    },
                    child: const Text("등록하기"),
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
