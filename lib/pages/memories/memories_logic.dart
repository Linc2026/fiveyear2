import 'package:get/get.dart';
import '../../db_five_year_diary/db_five_year_diary_entity.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';
import '../diary/diary_logic.dart';
import '../main_shell/main_shell_logic.dart';

class MemoriesLogic extends GetxController {
  final randomEntry = Rxn<DiaryEntry>();
  final photoEntries = <DiaryEntry>[].obs;
  final loading = false.obs;

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    randomEntry.value = await DbFiveYearDiaryHelper.instance.getRandomEntry();
    photoEntries.value =
        await DbFiveYearDiaryHelper.instance.getEntriesWithPhotos();
    loading.value = false;
  }

  Future<void> refreshRandom() async {
    randomEntry.value = await DbFiveYearDiaryHelper.instance.getRandomEntry();
  }

  int get photoCount => photoEntries.length;

  bool get hasData =>
      randomEntry.value != null || photoEntries.isNotEmpty;

  String formatDate(DiaryEntry entry) {
    final m = entry.month.toString().padLeft(2, '0');
    final d = entry.day.toString().padLeft(2, '0');
    return '${entry.year}-$m-$d';
  }

  int yearsFromNow(DiaryEntry entry) {
    return DateTime.now().year - entry.year;
  }

  void openPhoto(String path) {
    Get.toNamed('/five_photo_view', arguments: {'path': path});
  }

  void goWriteDiary() {
    Get.find<MainShellLogic>().changeTab(0);
  }

  void openEntryInDiary(DiaryEntry entry) {
    try {
      Get.find<DiaryLogic>().setDate(entry.month, entry.day);
      Get.find<MainShellLogic>().changeTab(0);
    } catch (_) {}
  }
}
