import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';
import '../../lang/lang.dart';
import '../../utils/theme_controller.dart';

class SettingsLogic extends GetxController {
  final nicknameController = TextEditingController();
  final startYear = 0.obs;
  final darkMode = false.obs;
  final saving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final db = DbFiveYearDiaryHelper.instance;
    nicknameController.text = await db.getNickname();
    startYear.value = await db.getStartYear();
    darkMode.value = await db.isDarkMode();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode.value = value;
    if (Get.isRegistered<ThemeController>()) {
      await Get.find<ThemeController>().toggleDark(value);
    }
  }

  Future<void> save() async {
    saving.value = true;
    final db = DbFiveYearDiaryHelper.instance;
    await db.setNickname(nicknameController.text.trim());
    await db.setStartYear(startYear.value);
    saving.value = false;
    Get.back();
    Get.snackbar('', Lang.settingsSaved, snackPosition: SnackPosition.BOTTOM);
  }

  void incrementStartYear() {
    if (startYear.value < DateTime.now().year) startYear.value++;
  }

  void decrementStartYear() {
    if (startYear.value > 2000) startYear.value--;
  }

  @override
  void onClose() {
    nicknameController.dispose();
    super.onClose();
  }
}
