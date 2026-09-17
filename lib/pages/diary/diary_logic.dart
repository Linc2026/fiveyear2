import 'package:get/get.dart';
import '../../db_five_year_diary/db_five_year_diary_entity.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';

class DiaryLogic extends GetxController {
  final selectedMonth = DateTime.now().month.obs;
  final selectedDay = DateTime.now().day.obs;
  final startYear = 0.obs;
  final entries = <DiaryEntry>[].obs;
  final loading = false.obs;

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    startYear.value = await DbFiveYearDiaryHelper.instance.getStartYear();
    final list = await DbFiveYearDiaryHelper.instance.getEntriesForDay(
      selectedMonth.value,
      selectedDay.value,
    );
    entries.value = list;
    loading.value = false;
  }

  List<int> get yearRange {
    final start = startYear.value;
    return List.generate(5, (i) => start + i);
  }

  int get filledCount =>
      yearRange.where((y) => entryForYear(y)?.hasContent == true).length;

  bool get isSelectedToday {
    final now = DateTime.now();
    return selectedMonth.value == now.month && selectedDay.value == now.day;
  }

  int get currentYear => DateTime.now().year;

  DiaryEntry? entryForYear(int year) {
    try {
      return entries.firstWhere((e) => e.year == year);
    } catch (_) {
      return null;
    }
  }

  void prevDay() {
    final d = DateTime(2024, selectedMonth.value, selectedDay.value)
        .subtract(const Duration(days: 1));
    selectedMonth.value = d.month;
    selectedDay.value = d.day;
    loadData();
  }

  void nextDay() {
    final d = DateTime(2024, selectedMonth.value, selectedDay.value)
        .add(const Duration(days: 1));
    selectedMonth.value = d.month;
    selectedDay.value = d.day;
    loadData();
  }

  void goToToday() {
    final now = DateTime.now();
    selectedMonth.value = now.month;
    selectedDay.value = now.day;
    loadData();
  }

  void setDate(int month, int day) {
    selectedMonth.value = month;
    selectedDay.value = day;
    loadData();
  }

  String get dateLabel {
    final m = selectedMonth.value.toString().padLeft(2, '0');
    final d = selectedDay.value.toString().padLeft(2, '0');
    return '$m-$d';
  }

  String get weekdayLabel {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final d = DateTime(2024, selectedMonth.value, selectedDay.value);
    return days[d.weekday - 1];
  }

  void openEdit(int year) {
    Get.toNamed(
      '/five_diary_edit',
      arguments: {
        'year': year,
        'month': selectedMonth.value,
        'day': selectedDay.value,
      },
    )?.then((_) => loadData());
  }

  void writeToday() {
    openEdit(currentYear);
  }

  void openSettings() {
    Get.toNamed('/five_settings')?.then((_) => loadData());
  }
}
