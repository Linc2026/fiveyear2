import 'package:get/get.dart';
import '../db_five_year_diary/db_five_year_diary_helper.dart';
import '../utils/app_theme.dart';

class ThemeController extends GetxController {
  final isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isDark.value = await DbFiveYearDiaryHelper.instance.isDarkMode();
    Get.changeTheme(isDark.value ? AppTheme.dark() : AppTheme.light());
  }

  Future<void> toggleDark(bool value) async {
    isDark.value = value;
    await DbFiveYearDiaryHelper.instance.setDarkMode(value);
    Get.changeTheme(value ? AppTheme.dark() : AppTheme.light());
  }
}
