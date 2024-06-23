import 'dart:typed_data'; // 바이너리 데이터 처리를 위해 사용
import 'dart:convert'; // JSON 데이터 처리를 위해 사용
import 'package:camera/camera.dart'; // 카메라 기능을 사용하기 위해 필요한 패키지
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // 텍스트 인식 기능을 사용하기 위한 패키지
import 'package:permission_handler/permission_handler.dart'; // 권한 요청을 처리하기 위한 패키지
import 'package:flutter/material.dart'; // Flutter의 기본 UI 구성 요소
import 'package:http/http.dart' as http; // HTTP 요청을 보내기 위한 패키지
import 'package:html/parser.dart' as parser; // HTML 파싱을 위한 패키지

class CameraService {
  CameraController? _cameraController; // 카메라 컨트롤러 인스턴스
  String imageUrl = ''; // 이미지 URL을 저장할 변수

  // 카메라 초기화 메서드
  Future<void> initCamera() async {
    final cameras = await availableCameras(); // 사용 가능한 카메라 목록 가져오기
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[0], // 첫 번째 카메라 선택
        ResolutionPreset.medium, // 해상도 설정
        enableAudio: false, // 오디오 비활성화
      );
      await _cameraController!.initialize(); // 카메라 초기화
      await _cameraController!.setFlashMode(FlashMode.off); // 플래시 비활성화
    }
  }

  // 카메라 컨트롤러를 반환하는 getter
  CameraController? get cameraController => _cameraController;

  // 특정 권한을 요청하는 메서드
  Future<void> handlePermission(Permission permission) async {
    await permission.request(); // 권한 요청
  }

  // 사진을 촬영하고 텍스트 인식을 수행하는 메서드
  Future<void> takePicture(Function(Uint8List?, String?) callback) async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture(); // 사진 촬영
        final imagePath = image.path; // 사진 경로
        final imageData = await image.readAsBytes(); // 이미지 데이터를 바이트 배열로 읽기

        final inputImage = InputImage.fromFilePath(imagePath); // 입력 이미지 생성

        final textRecognizer =
            TextRecognizer(script: TextRecognitionScript.latin); // 텍스트 인식기 생성
        final recognizedText =
            await textRecognizer.processImage(inputImage); // 이미지에서 텍스트 인식
        String? formattedDate =
            _formatDate(recognizedText.text); // 인식된 텍스트에서 날짜 추출

        callback(imageData, formattedDate); // 콜백 호출

        textRecognizer.close(); // 텍스트 인식기 닫기
      } catch (e) {
        print('Error capturing image: $e'); // 오류 출력
        callback(null, null); // 콜백 호출
      }
    }
  }

  // 인식된 텍스트에서 날짜를 추출하는 메서드
  String? _formatDate(String text) {
    RegExp dateRegex =
        RegExp(r'\b(\d{2}|\d{4})[.](\d{1,2})[.](\d{1,2})\b'); // 날짜 정규식 패턴
    Iterable<RegExpMatch> matches = dateRegex.allMatches(text); // 정규식 매칭

    if (matches.isNotEmpty) {
      RegExpMatch? selectedMatch;

      for (var match in matches) {
        String year = match.group(1)!;
        if (year.length == 2) {
          year = '20$year'; // 연도를 4자리로 변환
        }

        if (selectedMatch == null) {
          selectedMatch = match;
        } else {
          String selectedYear = selectedMatch.group(1)!;
          if (selectedYear.length == 2) {
            selectedYear = '20$selectedYear'; // 연도를 4자리로 변환
          }

          if (int.parse(year) > int.parse(selectedYear)) {
            selectedMatch = match;
          } else if (int.parse(year) == int.parse(selectedYear)) {
            String month = match.group(2)!;
            String selectedMonth = selectedMatch.group(2)!;

            if (int.parse(month) > int.parse(selectedMonth)) {
              selectedMatch = match;
            } else if (int.parse(month) == int.parse(selectedMonth)) {
              String day = match.group(3)!;
              String selectedDay = selectedMatch.group(3)!;

              if (int.parse(day) > int.parse(selectedDay)) {
                selectedMatch = match;
              }
            }
          }
        }
      }

      if (selectedMatch != null) {
        String year = selectedMatch.group(1)!;
        String month = selectedMatch.group(2)!;
        String day = selectedMatch.group(3)!;

        if (year.length == 2) {
          year = '20$year'; // 연도를 4자리로 변환
        }

        return '$year-$month-$day'; // 날짜 형식으로 반환
      }
    }
    return null; // 날짜가 없는 경우 null 반환
  }

  // 바코드로 제품 정보를 가져오는 메서드
  Future<void> getProduct(
      String barcode,
      TextEditingController productNameController,
      Function(String) updateImageUrl) async {
    var apiKey = '08250c6f4a19422781f0'; // API 키
    var url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/I2570/json/1/5/BRCD_NO=$barcode'); // API URL
    var response = await http.get(url); // HTTP GET 요청

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body); // JSON 응답 파싱
      var productName = jsonResponse['I2570']['row'][0]['PRDT_NM']; // 제품명 추출
      productNameController.text = productName; // 제품명 입력 필드에 설정
      await fetchGoogleImages(productName, updateImageUrl); // 구글 이미지 검색
    } else {
      print('Request failed with status: ${response.statusCode}.'); // 오류 출력
    }
  }

  // 구글 이미지 검색을 통해 이미지 URL을 가져오는 메서드
  Future<void> fetchGoogleImages(
      String keyword, Function(String) updateImageUrl) async {
    final response = await http.get(Uri.parse(
        'https://www.google.com/search?q=$keyword&tbm=isch')); // 구글 이미지 검색 요청
    if (response.statusCode == 200) {
      final document = parser.parse(response.body); // HTML 응답 파싱
      final elements = document.getElementsByTagName('img'); // img 태그 요소 추출
      final urls = elements
          .map((element) => element.attributes['src']) // src 속성 추출
          .where((src) => src != null && src!.startsWith('http')) // 유효한 URL 필터링
          .toList();
      if (urls.isNotEmpty) {
        imageUrl = urls.first!; // 첫 번째 이미지 URL 설정
        updateImageUrl(imageUrl); // 콜백을 통해 이미지 URL 업데이트
      }
    } else {
      throw Exception('Failed to load images'); // 오류 발생 시 예외 던지기
    }
  }

  // 카메라 미리보기를 시작하는 메서드
  Future<void> startCameraPreview(
      BuildContext context, Function(Uint8List?, String?) callback) async {
    await handlePermission(Permission.camera); // 카메라 권한 요청
    await handlePermission(Permission.microphone); // 마이크 권한 요청
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Camera')), // 앱 바 설정
            body: Stack(
              children: [
                CameraPreview(_cameraController!), // 카메라 미리보기
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        await takePicture(callback); // 사진 촬영
                        Navigator.pop(context); // 촬영 후 뒤로 돌아가기
                      },
                      child: const Icon(Icons.camera), // 카메라 아이콘
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

  // 원형 버튼을 생성하는 메서드
  Widget buildCircle(Alignment alignment, double size, Color color,
      Function onPressed, String? imageUrl) {
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () {
          onPressed(); // 버튼 클릭 시 호출할 콜백 함수
        },
        child: Container(
          width: size, // 원의 너비 설정
          height: size, // 원의 높이 설정
          decoration: BoxDecoration(
            shape: BoxShape.circle, // 원형 모양 설정
            color: color, // 배경 색상 설정
            image: imageUrl != null && imageUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(imageUrl), // 이미지 설정
                    fit: BoxFit.cover, // 이미지 맞춤 설정
                  )
                : null,
          ),
        ),
      ),
    );
  }

  // 카메라 컨트롤러 리소스를 해제하는 메서드
  void dispose() {
    _cameraController?.dispose(); // 카메라 컨트롤러 해제
  }
}
