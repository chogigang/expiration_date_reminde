import 'dart:typed_data';
import 'package:drift/drift.dart' as drift;
import 'package:expiration_date/data/database.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;

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
  String imageUrl = ''; //이미지 url
  Uint8List? imageData; // 이미지 바이너리 데이터
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(FlashMode.off);
      setState(() {}); // 카메라 초기화 후 상태 갱신
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

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

  Future<void> _takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final XFile file = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String? formattedDate = _formatDate(recognizedText.text);

      // 이미지 파일을 바이너리 데이터로 읽기
      Uint8List imageData = await file.readAsBytes();

      setState(() {
        expiryDateController.text = formattedDate ?? "Date not found";
        this.imageData = imageData; // 이미지 데이터를 설정
      });

      textRecognizer.close();
    } else {
      print('No camera selected or camera not initialized');
    }
  }

  String? _formatDate(String text) {
    RegExp dateRegex = RegExp(r'\b(\d{2}|\d{4})[.](\d{1,2})[.](\d{1,2})\b');
    Iterable<RegExpMatch> matches = dateRegex.allMatches(text);

    if (matches.isNotEmpty) {
      // Assuming the first matched date is the relevant one
      var match = matches.first;
      String year = match.group(1)!;
      String month = match.group(2)!;
      String day = match.group(3)!;

      // Normalize year to four digits
      if (year.length == 2) {
        year = '20$year';
      }

      // Return date in yyyy-mm-dd format
      return '$year-$month-$day';
    }
    return null; // No valid date found
  }

  Future<void> _startCameraPreview(BuildContext context) async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Camera')),
            body: Stack(
              children: [
                CameraPreview(_cameraController!),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        await _takePicture();
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.camera),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
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
            alignment: const Alignment(0, 0.65),
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
                    controller: typeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '종류',
                    ),
                  ),
                ),
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
                        onPressed: () => _startCameraPreview(context),
                      ),
                    ],
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
                  // 추가 버튼
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
                      typeController.clear();
                    },
                    child: const Text("등록하기"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    '인식한 문자: ${expiryDateController.text}',
                    style: const TextStyle(fontSize: 20),
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
