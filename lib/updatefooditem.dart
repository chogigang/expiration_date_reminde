import 'dart:typed_data';
import 'package:expiration_date/data/database.dart';
import 'package:flutter/material.dart';
import 'package:expiration_date/service/cameraservice.dart';
import 'package:drift/drift.dart' as drift;

class UpdateFoodItem extends StatefulWidget {
  final FooddbData foodItem;

  const UpdateFoodItem({Key? key, required this.foodItem}) : super(key: key);

  @override
  _UpdateFoodItemState createState() => _UpdateFoodItemState();
}

class _UpdateFoodItemState extends State<UpdateFoodItem> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController alarmCycleController;
  late TextEditingController expiryDateController;
  Uint8List? imageData;
  final CameraService _cameraService = CameraService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.foodItem.name);
    typeController = TextEditingController(text: widget.foodItem.type);
    alarmCycleController = TextEditingController(
        text: widget.foodItem.alarm_cycle?.toString() ?? '');
    expiryDateController = TextEditingController(
        text: widget.foodItem.expiry_date
            .toLocal()
            .toIso8601String()
            .split('T')[0]);
    imageData = widget.foodItem.image_data;
    _cameraService.initCamera();
  }

  Future<void> updateItem() async {
    final db = MyDatabase();
    final updatedItem = FooddbCompanion(
      id: drift.Value(widget.foodItem.id),
      name: drift.Value(nameController.text),
      type: drift.Value(typeController.text),
      expiry_date: drift.Value(DateTime.parse(expiryDateController.text)),
      alarm_cycle: drift.Value(int.tryParse(alarmCycleController.text)),
      createdAt: drift.Value(widget.foodItem.createdAt),
      image_data: drift.Value(imageData),
    );

    await db.updateFooddb(updatedItem);
    Navigator.of(context).pop(updatedItem); // 업데이트된 항목을 반환
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(expiryDateController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null &&
        pickedDate != DateTime.parse(expiryDateController.text)) {
      setState(() {
        expiryDateController.text =
            pickedDate.toLocal().toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> startCameraPreview(BuildContext context) async {
    await _cameraService.startCameraPreview(context,
        (Uint8List? imageData, String? formattedDate) {
      setState(() {
        this.imageData = imageData;
        if (formattedDate != null) {
          expiryDateController.text = formattedDate;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('수정 화면')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  image: imageData != null
                      ? DecorationImage(
                          image: MemoryImage(imageData!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              ElevatedButton(
                onPressed: () => startCameraPreview(context),
                child: const Text('사진 변경'),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '이름'),
                validator: (value) => value!.isEmpty ? '이름을 입력해주세요' : null,
              ),
              TextFormField(
                controller: typeController,
                decoration: const InputDecoration(labelText: '종류'),
                validator: (value) => value!.isEmpty ? '종류를 입력해주세요' : null,
              ),
              TextFormField(
                controller: expiryDateController,
                decoration: const InputDecoration(labelText: '유통기한'),
                readOnly: true,
                onTap: () => _selectExpiryDate(context),
                validator: (value) => value!.isEmpty ? '유통기한을 입력해주세요' : null,
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateItem();
                    Navigator.of(context).pop(true); // 수정 완료 후 true 반환
                  }
                },
                child: const Text('수정'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
