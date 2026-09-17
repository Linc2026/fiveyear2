import 'package:get/get.dart';
import '../../db_five_year_diary/db_five_year_diary_entity.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';

class StatsLogic extends GetxController {
  final period = 'all'.obs;
  final loading = false.obs;

  final totalEntries = 0.obs;
  final streak = 0.obs;
  final dailyAvg = 0.0.obs;
  final totalWords = 0.obs;
  final photoCount = 0.obs;
  final coveredYears = 0.obs;
  final moodCount = 0.obs;
  final trendLabels = <String>[].obs;
  final trendValues = <int>[].obs;
  final moodStats = <MoodStat>[].obs;
  final locations = <LocationStat>[].obs;
  final weights = <WeightPoint>[].obs;
  final weatherTags = 0.obs;
  final sceneTags = 0.obs;

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    final db = DbFiveYearDiaryHelper.instance;
    final entries = await db.entriesInPeriod(period.value);

    totalEntries.value = entries.where((e) => e.hasContent).length;
    streak.value = await db.streakDays();
    totalWords.value = entries.fold(0, (s, e) => s + e.content.trim().length);
    photoCount.value = entries.where((e) => e.photoPath?.isNotEmpty == true).length;
    coveredYears.value = entries.map((e) => e.year).toSet().length;
    moodCount.value = entries.where((e) => e.mood > 0 || e.hasContent).length;

    final days = period.value == 'month'
        ? DateTime.now().day
        : period.value == 'year'
            ? DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays + 1
            : 365;
    dailyAvg.value = days > 0 ? totalEntries.value / days : 0;

    final trend = await db.last7DaysCounts();
    trendLabels.value = trend.map((e) => e.label).toList();
    trendValues.value = trend.map((e) => e.count).toList();

    moodStats.value = await db.moodStats();
    locations.value = await db.topLocations();
    weights.value = await db.weightTrend();

    weatherTags.value = entries.where((e) => e.weather.isNotEmpty).length;
    sceneTags.value = entries.where((e) => e.scene.isNotEmpty).length;

    loading.value = false;
  }

  void setPeriod(String p) {
    period.value = p;
    loadData();
  }
}
