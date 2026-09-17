import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryLogic extends GetxController {
  static const guideCompletedKey = 'guide_completed';

  @override
  void onReady() {
    super.onReady();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final prefs = await SharedPreferences.getInstance();
    final guideCompleted = prefs.getBool(guideCompletedKey) ?? false;
    Get.offAllNamed(guideCompleted ? '/five_main' : '/five_guide');
  }
}
