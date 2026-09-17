import 'package:get/get.dart';
import '../../db_five_year_diary/db_five_year_diary_entity.dart';
import '../../db_five_year_diary/db_five_year_diary_helper.dart';
import '../../lang/lang.dart';

class TrailLogic extends GetxController {
  final loading = false.obs;
  final heatmap = <HeatmapCell>[].obs;
  final weekdayCounts = <int>[].obs;
  final timeBuckets = <String, int>{}.obs;
  final moodCells = <int>[].obs;
  final badges = <TrailBadge>[].obs;
  final activeDays = 0.obs;
  final streak = 0.obs;
  final unlockedBadges = 0.obs;

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    final db = DbFiveYearDiaryHelper.instance;

    heatmap.value = await db.heatmapCells(days: 30);
    weekdayCounts.value = await db.weekdayWriteCounts();
    timeBuckets.value = await db.timeOfDayBuckets();
    moodCells.value = await db.moodMosaic();
    streak.value = await db.streakDays();

    activeDays.value = heatmap.where((c) => c.level > 0).length;

    final totalEntries = await db.countEntriesWithContent();
    final totalWords = await db.totalWordCount();
    final photoCount = await db.countPhotos();
    final coveredYears = await db.coveredYears();
    final moodEntries = (await db.getAllEntries())
        .where((e) => e.hasContent && e.mood > 0)
        .length;

    final badgeList = [
      TrailBadge(
        id: 'first',
        title: Lang.trailBadgeFirst,
        description: Lang.trailBadgeFirstDesc,
        unlocked: totalEntries >= 1,
      ),
      TrailBadge(
        id: 'streak7',
        title: Lang.trailBadgeStreak7,
        description: Lang.trailBadgeStreak7Desc,
        unlocked: streak.value >= 7,
      ),
      TrailBadge(
        id: 'streak30',
        title: Lang.trailBadgeStreak30,
        description: Lang.trailBadgeStreak30Desc,
        unlocked: streak.value >= 30,
      ),
      TrailBadge(
        id: 'entries10',
        title: Lang.trailBadgeEntries10,
        description: Lang.trailBadgeEntries10Desc,
        unlocked: totalEntries >= 10,
      ),
      TrailBadge(
        id: 'photo5',
        title: Lang.trailBadgePhoto5,
        description: Lang.trailBadgePhoto5Desc,
        unlocked: photoCount >= 5,
      ),
      TrailBadge(
        id: 'mood10',
        title: Lang.trailBadgeMood10,
        description: Lang.trailBadgeMood10Desc,
        unlocked: moodEntries >= 10,
      ),
      TrailBadge(
        id: 'words1k',
        title: Lang.trailBadgeWords1k,
        description: Lang.trailBadgeWords1kDesc,
        unlocked: totalWords >= 1000,
      ),
      TrailBadge(
        id: 'years2',
        title: Lang.trailBadgeYears2,
        description: Lang.trailBadgeYears2Desc,
        unlocked: coveredYears >= 2,
      ),
    ];
    badges.value = badgeList;
    unlockedBadges.value = badgeList.where((b) => b.unlocked).length;

    loading.value = false;
  }

  String get topWeekday {
    if (weekdayCounts.isEmpty || weekdayCounts.every((c) => c == 0)) {
      return Lang.trailRhythmEmpty;
    }
    var maxIdx = 0;
    for (var i = 1; i < weekdayCounts.length; i++) {
      if (weekdayCounts[i] > weekdayCounts[maxIdx]) maxIdx = i;
    }
    return Lang.calendarWeekdays[maxIdx];
  }

  String get topTimeBucket {
    if (timeBuckets.isEmpty) return Lang.trailRhythmEmpty;
    var topKey = 'morning';
    var topVal = 0;
    timeBuckets.forEach((k, v) {
      if (v > topVal) {
        topVal = v;
        topKey = k;
      }
    });
    if (topVal == 0) return Lang.trailRhythmEmpty;
    switch (topKey) {
      case 'morning':
        return Lang.trailTimeMorning;
      case 'afternoon':
        return Lang.trailTimeAfternoon;
      case 'evening':
        return Lang.trailTimeEvening;
      default:
        return Lang.trailTimeNight;
    }
  }
}
