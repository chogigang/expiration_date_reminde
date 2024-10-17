import 'dart:typed_data';
import 'package:expiration_date/data/database.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:expiration_date/service/cameraservice.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_gemini/flutter_gemini.dart'; // Gemini 패키지 추가

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
  String imageUrl = ''; // 이미지 url
  Uint8List? imageData; // 사진 찍기에서 찍은 이미지 바이너리 데이터

  final CameraService _cameraService = CameraService();

  @override
  void initState() {
    super.initState();
    _cameraService.initCamera().then((_) {
      setState(() {}); // 카메라 초기화 후 상태 갱신
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
        imageUrl = ''; // 사진 찍기에서 찍은 이미지가 있을 때, 이미지 URL 초기화

        // Gemini API를 호출하여 이미지에서 음식 이름을 인식
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

  void updateImageUrl(String url) {
    setState(() {
      imageUrl = url;
      imageData = null; // 이미지 URL이 업데이트되면, 이미지 바이너리 데이터 초기화
    });
  }

  // Gemini API를 사용하여 이미지에서 음식 이름을 가져오는 메서드 추가
  Future<void> getFoodNameFromGemini(Uint8List imageData) async {
    try {
      final gemini = Gemini.instance;
      final response = await gemini.textAndImage(
        text: "이 음식의 이름이 무엇인지, 단답형으로, 한글로 이름만 딱 말해줘", // 텍스트 프롬프트 (선택 사항)
        images: [imageData],
      );
      String? foodName = response?.content?.parts?.last.text;

      if (foodName != null) {
        setState(() {
          productNameController.text = foodName; // 인식된 음식 이름 설정
        });
      }
    } catch (e) {
      print('Error during food recognition: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          // 원형 이미지 표시 (이미지 URL이 있으면 사용하고, 없으면 바이너리 데이터를 사용)
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
                // 바코드 스캐너를 위한 버튼
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
          // 식품이름 입력 필드와 사진 아이콘 버튼
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
                          // 사진 찍기 기능 시작
                          await _startCameraPreview(context);
                        },
                      ),
                    ],
                  ),
                ),
                // 종류 입력 필드
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: TextField(
                    controller: typeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '종류',
                    ),
                  ),
                ),
                // 유통기한 입력 필드와 카메라 버튼
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expiryDateController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '유통기한',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => _startExpiryDateCameraPreview(context),
                      ),
                    ],
                  ),
                ),
                // 알람 주기 입력 필드
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: TextField(
                    controller: alarmCycleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '알람주기(일)',
                    ),
                  ),
                ),
                // 등록하기 버튼
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
                        image_data: drift.Value(imageData), // 이미지 바이너리 데이터 추가
                        image_url: drift.Value(imageUrl), // 이미지 URL 추가
                      );
                      int id = await db.addFooddb(newFood);

                      if (id > 0) {
                        // 데이터가 성공적으로 추가되었는지 확인
                        print('항목이 성공적으로 추가되었습니다. ID: $id');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('알림'),
                              content: const Text('항목이 성공적으로 추가되었습니다.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('확인'),
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
                      typeController.clear();
                      setState(() {
                        imageData = null; // 추가 후 이미지 바이너리 데이터 초기화
                        imageUrl = ''; // 추가 후 이미지 URL 초기화
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
