import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_five_year_diary/db_five_year_diary_entity.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';
import '../../lang/lang.dart';

class FutureMessageLogic extends GetxController {
  final contentController = TextEditingController();
  final message = Rxn<FutureMessage>();
  final saving = false.obs;
  final daysLeft = 0.obs;
  final unlocked = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> loadData() => _load();

  Future<void> _load() async {
    message.value = await DbFiveYearDiaryHelper.instance.getFutureMessage();
    if (message.value != null) {
      contentController.text = message.value!.content;
      final now = DateTime.now().millisecondsSinceEpoch;
      unlocked.value = now >= message.value!.unlockAt;
      daysLeft.value = unlocked.value
          ? 0
          : ((message.value!.unlockAt - now) / (86400000)).ceil();
    }
  }

  Future<void> save() async {
    saving.value = true;
    final now = DateTime.now();
    final unlock = DateTime(now.year + 5, now.month, now.day);
    final msg = FutureMessage(
      id: 1,
      content: contentController.text.trim(),
      createdAt: message.value?.createdAt ?? now.millisecondsSinceEpoch,
      unlockAt: message.value?.unlockAt ?? unlock.millisecondsSinceEpoch,
    );
    await DbFiveYearDiaryHelper.instance.saveFutureMessage(msg);
    await _load();
    saving.value = false;
    Get.snackbar('', Lang.editSaved, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }
}
