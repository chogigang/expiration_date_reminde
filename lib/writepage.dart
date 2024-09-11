// import 'dart:typed_data';
// import 'package:expiration_date/data/database.dart';
// import 'package:flutter/material.dart';
// import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
// import 'package:expiration_date/service/cameraservice.dart';
// import 'package:drift/drift.dart' as drift;

// class WritePage extends StatefulWidget {
//   const WritePage({Key? key}) : super(key: key);

//   @override
//   _WritePageState createState() => _WritePageState();
// }

// class _WritePageState extends State<WritePage> {
//   String result = '';
//   final productNameController = TextEditingController();
//   final expiryDateController = TextEditingController();
//   final alarmCycleController = TextEditingController();
//   final typeController = TextEditingController();
//   String imageUrl = ''; // 이미지 url
//   Uint8List? imageData; // 사진 찍기에서 찍은 이미지 바이너리 데이터

//   final CameraService _cameraService = CameraService();

//   @override
//   void initState() {
//     super.initState();
//     _cameraService.initCamera().then((_) {
//       setState(() {}); // 카메라 초기화 후 상태 갱신
//     });
//   }

//   @override
//   void dispose() {
//     _cameraService.dispose();
//     super.dispose();
//   }

//   Future<void> _startCameraPreview(BuildContext context) async {
//     await _cameraService.startCameraPreview(context, (imageData, date) {
//       setState(() {
//         this.imageData = imageData;
//         imageUrl = ''; // 사진 찍기에서 찍은 이미지가 있을 때, 이미지 URL 초기화
//       });
//     });
//   }

//   Future<void> _startExpiryDateCameraPreview(BuildContext context) async {
//     await _cameraService.startCameraPreview(context, (imageData, date) {
//       setState(() {
//         expiryDateController.text = date ?? "Date not found";
//       });
//     });
//   }

//   Widget buildCircle(
//       Alignment alignment, double size, Color color, Function onPressed,
//       {Widget? child}) {
//     return Align(
//       alignment: alignment,
//       child: InkWell(
//         onTap: () {
//           onPressed();
//         },
//         child: Container(
//           width: size,
//           height: size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: color,
//             image: imageUrl.isNotEmpty
//                 ? DecorationImage(
//                     image: NetworkImage(imageUrl),
//                     fit: BoxFit.cover,
//                   )
//                 : imageData != null
//                     ? DecorationImage(
//                         image: MemoryImage(imageData!),
//                         fit: BoxFit.cover,
//                       )
//                     : null,
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }

//   Widget buildCircleMiniIcon(
//       Alignment alignment, double size, Color color, Function onPressed,
//       {Widget? child}) {
//     return Align(
//       alignment: alignment,
//       child: InkWell(
//         onTap: () {
//           onPressed();
//         },
//         child: Container(
//           width: size,
//           height: size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: color,
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }

//   void updateImageUrl(String url) {
//     setState(() {
//       imageUrl = url;
//       imageData = null; // 이미지 URL이 업데이트되면, 이미지 바이너리 데이터 초기화
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Stack(
//         children: <Widget>[
//           buildCircle(Alignment(0, -0.6), 180, Colors.black, () {}),
//           ElevatedButton(
//             onPressed: () async {
//               // 카메라 촬영 시작
//               await _startCameraPreview(context);
//             },
//             child: const Text("사진 찍기"),
//           ),
//           buildCircleMiniIcon(
//             Alignment(0.3, -0.3),
//             50,
//             Colors.grey,
//             () async {
//               var res = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const SimpleBarcodeScannerPage(),
//                 ),
//               );
//               setState(() {
//                 if (res is String) {
//                   result = res;
//                   _cameraService.getProduct(
//                       result, productNameController, updateImageUrl);
//                 }
//               });
//             },
//             child: const Icon(Icons.add, color: Colors.white),
//           ),
//           Align(
//             alignment: const Alignment(0, 0.65),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(),
//                   child: TextField(
//                     controller: productNameController,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: '식품이름',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 5,
//                   ),
//                   child: TextField(
//                     controller: typeController,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: '종류',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 5,
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: expiryDateController,
//                           decoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: '유통기한',
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.camera_alt),
//                         onPressed: () => _startExpiryDateCameraPreview(context),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 5,
//                   ),
//                   child: TextField(
//                     controller: alarmCycleController,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: '알람주기(일)',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   // 추가 버튼
//                   padding: const EdgeInsets.only(left: 10.0, right: 0),
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       String productName = productNameController.text;
//                       String expiryDate = expiryDateController.text;
//                       String alarmCycle = alarmCycleController.text;
//                       String type = typeController.text;

//                       MyDatabase db = MyDatabase();
//                       int? alarmCycleInt = int.tryParse(alarmCycle);
//                       FooddbCompanion newFood = FooddbCompanion.insert(
//                         name: productName,
//                         expiry_date: DateTime.parse(expiryDate),
//                         alarm_cycle: drift.Value(alarmCycleInt),
//                         type: type,
//                         image_data: drift.Value(imageData), // 이미지 바이너리 데이터 추가
//                         image_url: drift.Value(imageUrl), // 이미지 URL 추가
//                       );
//                       int id = await db.addFooddb(newFood);

//                       if (id > 0) {
//                         // 데이터가 성공적으로 추가되었는지 확인
//                         print('항목이 성공적으로 추가되었습니다. ID: $id');
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text('알림'),
//                               content: const Text('항목이 성공적으로 추가되었습니다.'),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text('확인'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       } else {
//                         // 데이터 추가 실패
//                         print('항목 추가에 실패했습니다.');
//                       }

//                       productNameController.clear();
//                       expiryDateController.clear();
//                       alarmCycleController.clear();
//                       typeController.clear();
//                       setState(() {
//                         imageData = null; // 추가 후 이미지 바이너리 데이터 초기화
//                         imageUrl = ''; // 추가 후 이미지 URL 초기화
//                       });
//                     },
//                     child: const Text("등록하기"),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Text(
//                     '인식한 문자: ${expiryDateController.text}',
//                     style: const TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:expiration_date/data/database.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:expiration_date/service/cameraservice.dart';
import 'package:drift/drift.dart' as drift;

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

  Widget buildCircle(
      Alignment alignment, double size, Color color, Function onPressed,
      {Widget? child}) {
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
                : imageData != null
                    ? DecorationImage(
                        image: MemoryImage(imageData!),
                        fit: BoxFit.cover,
                      )
                    : null,
          ),
          child: child,
        ),
      ),
    );
  }

  void updateImageUrl(String url) {
    setState(() {
      imageUrl = url;
      imageData = null; // 이미지 URL이 업데이트되면, 이미지 바이너리 데이터 초기화
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          // 검은 원을 중앙에 배치
          Align(
            alignment: Alignment(0, -0.6),
            child: Stack(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  right: 10, // 원의 5시 방향을 맞추기 위해 상대적 위치 조정
                  bottom: 10, // 원의 5시 방향을 맞추기 위해 상대적 위치 조정
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
          // 사진 찍기 버튼
          ElevatedButton(
            onPressed: () async {
              // 카메라 촬영 시작
              await _startCameraPreview(context);
            },
            child: const Text("사진 찍기"),
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
                        onPressed: () => _startExpiryDateCameraPreview(context),
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
                      labelText: '알람주기(일)',
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
