import 'db_five_year_diary_entity.dart';
import 'db_five_year_diary_helper.dart';

class DbFiveYearDiaryData {
  static Future<void> initSampleData() async {
    final db = DbFiveYearDiaryHelper.instance;
    final count = await db.countEntries();
    if (count > 0) return;

    final now = DateTime.now();
    final ts = now.millisecondsSinceEpoch;

    await db.setNickname('Diary Traveler');
    await db.setStartYear(now.year - 4);
  }
}
