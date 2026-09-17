import 'package:get/get.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';
import '../main_shell/main_shell_logic.dart';
import '../memories/memories_logic.dart';

class ProfileLogic extends GetxController {
  final nickname = ''.obs;
  final streak = 0.obs;
  final totalEntries = 0.obs;
  final totalWords = 0.obs;
  final monthEntries = 0.obs;
  final photoCount = 0.obs;
  final loading = false.obs;

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    final db = DbFiveYearDiaryHelper.instance;
    nickname.value = await db.getNickname();
    if (nickname.value.isEmpty) nickname.value = '';
    streak.value = await db.streakDays();
    totalEntries.value = await db.countEntriesWithContent();
    totalWords.value = await db.totalWordCount();
    final now = DateTime.now();
    monthEntries.value = await db.countEntries(year: now.year, month: now.month);
    photoCount.value = await db.countPhotos();
    loading.value = false;
  }

  String get displayName =>
      nickname.value.isEmpty ? '' : nickname.value;

  void goStats() => Get.toNamed('/five_stats')?.then((_) => loadData());
  void goSettings() => Get.toNamed('/five_settings')?.then((_) => loadData());
  void goHelp() => Get.toNamed('/five_help');
  void goAbout() => Get.toNamed('/five_about');
  void goFuture() => Get.toNamed('/five_future_message');
  void goExport() => Get.toNamed('/five_export');

  void quickWrite() {
    Get.find<MainShellLogic>().changeTab(0);
  }

  void quickMemory() {
    Get.find<MainShellLogic>().changeTab(3);
    try {
      Get.find<MemoriesLogic>().refreshRandom();
    } catch (_) {}
  }
}
