import 'package:get/get.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';
import '../../lang/lang.dart';
import '../diary/diary_logic.dart';
import '../main_shell/main_shell_logic.dart';

class CalendarLogic extends GetxController {
  final displayYear = DateTime.now().year.obs;
  final displayMonth = DateTime.now().month.obs;
  final markedDays = <int>{}.obs;
  final loading = false.obs;

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    final entries = await DbFiveYearDiaryHelper.instance.getEntriesForMonth(
      displayYear.value,
      displayMonth.value,
    );
    markedDays.clear();
    markedDays.addAll(
      entries.where((e) => e.hasContent).map((e) => e.day),
    );
    loading.value = false;
  }

  int get markedCount => markedDays.length;

  bool get isCurrentMonth {
    final now = DateTime.now();
    return displayYear.value == now.year && displayMonth.value == now.month;
  }

  String get monthDisplay => Lang.monthYear(displayYear.value, displayMonth.value);

  void prevMonth() {
    if (displayMonth.value == 1) {
      displayMonth.value = 12;
      displayYear.value--;
    } else {
      displayMonth.value--;
    }
    loadData();
  }

  void nextMonth() {
    if (displayMonth.value == 12) {
      displayMonth.value = 1;
      displayYear.value++;
    } else {
      displayMonth.value++;
    }
    loadData();
  }

  void goToCurrentMonth() {
    final now = DateTime.now();
    displayYear.value = now.year;
    displayMonth.value = now.month;
    loadData();
  }

  void selectDay(int day) {
    try {
      final diary = Get.find<DiaryLogic>();
      diary.setDate(displayMonth.value, day);
      Get.find<MainShellLogic>().changeTab(0);
    } catch (_) {}
  }

  int get daysInMonth =>
      DateTime(displayYear.value, displayMonth.value + 1, 0).day;

  int get firstWeekday =>
      DateTime(displayYear.value, displayMonth.value, 1).weekday;
}
