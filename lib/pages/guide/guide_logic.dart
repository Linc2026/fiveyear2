import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entry/entry_logic.dart';

class GuideLogic extends GetxController {
  final currentPage = 0.obs;

  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
    } else {
      finishGuide();
    }
  }

  Future<void> finishGuide() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(EntryLogic.guideCompletedKey, true);
    Get.offAllNamed('/five_main');
  }
}
