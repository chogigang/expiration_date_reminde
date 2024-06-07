import 'dart:typed_data';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class CameraService {
  CameraController? _cameraController;
  String imageUrl = ''; // 이미지 url

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(FlashMode.off);
    }
  }

  CameraController? get cameraController => _cameraController;

  Future<void> handlePermission(Permission permission) async {
    await permission.request();
  }

  Future<void> takePicture(Function(Uint8List?, String?) callback) async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final XFile file = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String? formattedDate = _formatDate(recognizedText.text);

      Uint8List imageData = await file.readAsBytes();
      callback(imageData, formattedDate);

      textRecognizer.close();
    }
  }

  String? _formatDate(String text) {
    RegExp dateRegex = RegExp(r'\b(\d{2}|\d{4})[.](\d{1,2})[.](\d{1,2})\b');
    Iterable<RegExpMatch> matches = dateRegex.allMatches(text);

    if (matches.isNotEmpty) {
      var match = matches.first;
      String year = match.group(1)!;
      String month = match.group(2)!;
      String day = match.group(3)!;

      if (year.length == 2) {
        year = '20$year';
      }

      return '$year-$month-$day';
    }
    return null;
  }

  Future<void> getProduct(
      String barcode, TextEditingController productNameController) async {
    var apiKey = '08250c6f4a19422781f0';
    var url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/I2570/json/1/5/BRCD_NO=$barcode');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var productName = jsonResponse['I2570']['row'][0]['PRDT_NM'];
      productNameController.text = productName;
      await fetchGoogleImages(productName);
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
          .where((src) => src != null && src!.startsWith('http'))
          .toList();
      if (urls.isNotEmpty) {
        imageUrl = urls.first!;
      }
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<void> startCameraPreview(
      BuildContext context, Function(Uint8List?, String?) callback) async {
    await handlePermission(Permission.camera);
    await handlePermission(Permission.microphone);
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
                        await takePicture(callback);
                        Navigator.pop(context); // 촬영 후 뒤로 돌아가기
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

  Widget buildCircle(Alignment alignment, double size, Color color,
      Function onPressed, String? imageUrl) {
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
            image: imageUrl != null && imageUrl.isNotEmpty
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

  void dispose() {
    _cameraController?.dispose();
  }
}
