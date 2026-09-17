import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../components/app_ui_kit.dart';
import '../../db_five_year_diary/db_five_year_diary_entity.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';
import '../../lang/lang.dart';

class DiaryEditLogic extends GetxController {
  late int year;
  late int month;
  late int day;

  final contentController = TextEditingController();
  final weatherController = TextEditingController();
  final sceneController = TextEditingController();
  final locationController = TextEditingController();
  final weightController = TextEditingController();

  final mood = 0.obs;
  final photoPath = RxnString();
  final saving = false.obs;
  DiaryEntry? existing;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    year = args['year'] as int;
    month = args['month'] as int;
    day = args['day'] as int;
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    existing = await DbFiveYearDiaryHelper.instance.getEntry(year, month, day);
    if (existing != null) {
      contentController.text = existing!.content;
      weatherController.text = existing!.weather;
      sceneController.text = existing!.scene;
      locationController.text = existing!.location;
      if (existing!.weight != null) {
        weightController.text = existing!.weight!.toStringAsFixed(1);
      }
      mood.value = existing!.mood;
      photoPath.value = existing!.photoPath;
    }
  }

  String get dateTitle {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final d = DateTime(year, month, day);
    final w = weekdays[d.weekday - 1];
    final m = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');
    return '$year-$m-$dd $w.';
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(dir.path, 'photos'));
    if (!await photosDir.exists()) await photosDir.create(recursive: true);
    final name = '${year}_${month}_${day}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await File(file.path).copy(p.join(photosDir.path, name));
    photoPath.value = saved.path;
  }

  void removePhoto() {
    photoPath.value = null;
  }

  Future<void> save() async {
    saving.value = true;
    final now = DateTime.now().millisecondsSinceEpoch;
    double? weight;
    if (weightController.text.trim().isNotEmpty) {
      weight = double.tryParse(weightController.text.trim());
    }

    final entry = DiaryEntry(
      id: existing?.id,
      year: year,
      month: month,
      day: day,
      content: contentController.text.trim(),
      mood: mood.value,
      weather: weatherController.text.trim(),
      scene: sceneController.text.trim(),
      location: locationController.text.trim(),
      weight: weight,
      photoPath: photoPath.value,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    if (existing == null) {
      await DbFiveYearDiaryHelper.instance.insertEntry(entry);
    } else {
      await DbFiveYearDiaryHelper.instance.updateEntry(entry.copyWith(id: existing!.id));
    }

    saving.value = false;
    Get.back();
    Get.snackbar('', Lang.editSaved, snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> deleteEntry() async {
    if (existing == null) return;
    final ok = await AppUi.confirm(
      title: Lang.deleteConfirmTitle,
      message: Lang.deleteConfirmMessage,
    );
    if (ok != true) return;
    await DbFiveYearDiaryHelper.instance.deleteEntry(existing!.id!);
    Get.back();
  }

  @override
  void onClose() {
    contentController.dispose();
    weatherController.dispose();
    sceneController.dispose();
    locationController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
