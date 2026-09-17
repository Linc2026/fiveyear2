import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_five_year_diary_entity.dart';

class DbFiveYearDiaryHelper {
  DbFiveYearDiaryHelper._();
  static final DbFiveYearDiaryHelper instance = DbFiveYearDiaryHelper._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'five_year_diary.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE diary_entry (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            year INTEGER NOT NULL,
            month INTEGER NOT NULL,
            day INTEGER NOT NULL,
            content TEXT NOT NULL DEFAULT '',
            mood INTEGER NOT NULL DEFAULT 0,
            weather TEXT NOT NULL DEFAULT '',
            scene TEXT NOT NULL DEFAULT '',
            location TEXT NOT NULL DEFAULT '',
            weight REAL,
            photo_path TEXT,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL,
            UNIQUE(year, month, day)
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_diary_month_day ON diary_entry(month, day)',
        );
        await db.execute('''
          CREATE TABLE future_message (
            id INTEGER PRIMARY KEY,
            content TEXT NOT NULL DEFAULT '',
            created_at INTEGER NOT NULL,
            unlock_at INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE app_settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getStartYear() async {
    final value = await getSetting('start_year');
    if (value != null) return int.parse(value);
    final now = DateTime.now();
    return now.year - 4;
  }

  Future<void> setStartYear(int year) async {
    await setSetting('start_year', year.toString());
  }

  Future<String> getNickname() async {
    return await getSetting('nickname') ?? '';
  }

  Future<void> setNickname(String name) async {
    await setSetting('nickname', name);
  }

  Future<bool> isDarkMode() async {
    return (await getSetting('dark_mode')) == 'true';
  }

  Future<void> setDarkMode(bool value) async {
    await setSetting('dark_mode', value.toString());
  }

  Future<int> insertEntry(DiaryEntry entry) async {
    final db = await database;
    return db.insert('diary_entry', entry.toMap());
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    final db = await database;
    await db.update(
      'diary_entry',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteEntry(int id) async {
    final db = await database;
    await db.delete('diary_entry', where: 'id = ?', whereArgs: [id]);
  }

  Future<DiaryEntry?> getEntry(int year, int month, int day) async {
    final db = await database;
    final rows = await db.query(
      'diary_entry',
      where: 'year = ? AND month = ? AND day = ?',
      whereArgs: [year, month, day],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DiaryEntry.fromMap(rows.first);
  }

  Future<List<DiaryEntry>> getEntriesForDay(int month, int day) async {
    final db = await database;
    final rows = await db.query(
      'diary_entry',
      where: 'month = ? AND day = ?',
      whereArgs: [month, day],
      orderBy: 'year ASC',
    );
    return rows.map(DiaryEntry.fromMap).toList();
  }

  Future<List<DiaryEntry>> getEntriesForMonth(int year, int month) async {
    final db = await database;
    final rows = await db.query(
      'diary_entry',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
      orderBy: 'day ASC',
    );
    return rows.map(DiaryEntry.fromMap).toList();
  }

  Future<List<DiaryEntry>> getAllEntries() async {
    final db = await database;
    final rows = await db.query(
      'diary_entry',
      orderBy: 'year DESC, month DESC, day DESC',
    );
    return rows.map(DiaryEntry.fromMap).toList();
  }

  Future<DiaryEntry?> getRandomEntry() async {
    final db = await database;
    final rows = await db.rawQuery(
      "SELECT * FROM diary_entry WHERE content != '' ORDER BY RANDOM() LIMIT 1",
    );
    if (rows.isEmpty) return null;
    return DiaryEntry.fromMap(rows.first);
  }

  Future<List<DiaryEntry>> getEntriesWithPhotos() async {
    final db = await database;
    final rows = await db.query(
      'diary_entry',
      where: "photo_path IS NOT NULL AND photo_path != ''",
      orderBy: 'updated_at DESC',
    );
    return rows.map(DiaryEntry.fromMap).toList();
  }

  Future<FutureMessage?> getFutureMessage() async {
    final db = await database;
    final rows = await db.query('future_message', limit: 1);
    if (rows.isEmpty) return null;
    return FutureMessage.fromMap(rows.first);
  }

  Future<void> saveFutureMessage(FutureMessage message) async {
    final db = await database;
    await db.insert(
      'future_message',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> countEntries({int? year, int? month}) async {
    final db = await database;
    String? where;
    List<Object?>? args;
    if (year != null && month != null) {
      where = 'year = ? AND month = ?';
      args = [year, month];
    } else if (year != null) {
      where = 'year = ?';
      args = [year];
    }
    final result = await db.rawQuery(
      'SELECT COUNT(*) as c FROM diary_entry${where != null ? ' WHERE $where' : ''}',
      args,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countEntriesWithContent() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as c FROM diary_entry WHERE content != ''",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countPhotos() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as c FROM diary_entry WHERE photo_path IS NOT NULL AND photo_path != ''",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> totalWordCount() async {
    final db = await database;
    final rows = await db.query('diary_entry', columns: ['content']);
    var total = 0;
    for (final row in rows) {
      total += (row['content'] as String? ?? '').trim().length;
    }
    return total;
  }

  Future<int> coveredYears() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(DISTINCT year) as c FROM diary_entry',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<MoodStat>> moodStats({DateTime? from, DateTime? to}) async {
    final db = await database;
    final rows = await _queryInRange(db, from, to);
    final map = <int, int>{};
    for (final row in rows) {
      final mood = row['mood'] as int? ?? 0;
      map[mood] = (map[mood] ?? 0) + 1;
    }
    return map.entries
        .map((e) => MoodStat(mood: e.key, count: e.value))
        .toList()
      ..sort((a, b) => a.mood.compareTo(b.mood));
  }

  Future<List<LocationStat>> topLocations({int limit = 5}) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT location, COUNT(*) as c FROM diary_entry
      WHERE location != ''
      GROUP BY location
      ORDER BY c DESC
      LIMIT ?
    ''', [limit]);
    return rows
        .map(
          (r) => LocationStat(
            location: r['location'] as String,
            count: r['c'] as int,
          ),
        )
        .toList();
  }

  Future<List<DayCount>> last7DaysCounts() async {
    final db = await database;
    final now = DateTime.now();
    final result = <DayCount>[];
    for (var i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final countResult = await db.rawQuery(
        'SELECT COUNT(*) as c FROM diary_entry WHERE year = ? AND month = ? AND day = ?',
        [d.year, d.month, d.day],
      );
      final label = '${d.month}/${d.day}';
      result.add(
        DayCount(label: label, count: Sqflite.firstIntValue(countResult) ?? 0),
      );
    }
    return result;
  }

  Future<List<WeightPoint>> weightTrend({int days = 30}) async {
    final db = await database;
    final cutoff = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch;
    final rows = await db.query(
      'diary_entry',
      where: 'weight IS NOT NULL AND updated_at >= ?',
      whereArgs: [cutoff],
      orderBy: 'updated_at ASC',
    );
    return rows
        .map(
          (r) => WeightPoint(
            timestamp: r['updated_at'] as int,
            weight: r['weight'] as double,
          ),
        )
        .toList();
  }

  Future<Set<String>> markedDaysInMonth(int year, int month) async {
    final entries = await getEntriesForMonth(year, month);
    return entries
        .where((e) => e.hasContent)
        .map((e) => '${e.month}-${e.day}')
        .toSet();
  }

  Future<int> streakDays() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT DISTINCT year, month, day FROM diary_entry
      WHERE content != ''
      ORDER BY year DESC, month DESC, day DESC
    ''');
    if (rows.isEmpty) return 0;

    var streak = 0;
    var expected = DateTime.now();
    expected = DateTime(expected.year, expected.month, expected.day);

    for (final row in rows) {
      final d = DateTime(
        row['year'] as int,
        row['month'] as int,
        row['day'] as int,
      );
      if (d == expected || d == expected.subtract(const Duration(days: 1))) {
        if (streak == 0 && d == expected.subtract(const Duration(days: 1))) {
          expected = d;
        } else if (d == expected) {
          streak++;
          expected = expected.subtract(const Duration(days: 1));
        } else if (d == expected.subtract(const Duration(days: 1))) {
          streak++;
          expected = d.subtract(const Duration(days: 1));
        }
      } else {
        break;
      }
    }
    return streak;
  }

  Future<List<Map<String, dynamic>>> _queryInRange(
    Database db,
    DateTime? from,
    DateTime? to,
  ) async {
    if (from == null && to == null) {
      return db.query('diary_entry');
    }
    final fromTs = from?.millisecondsSinceEpoch ?? 0;
    final toTs = to?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
    return db.query(
      'diary_entry',
      where: 'updated_at >= ? AND updated_at <= ?',
      whereArgs: [fromTs, toTs],
    );
  }

  Future<List<DiaryEntry>> entriesInPeriod(String period) async {
    final now = DateTime.now();
    DateTime? from;
    if (period == 'month') {
      from = DateTime(now.year, now.month, 1);
    } else if (period == 'year') {
      from = DateTime(now.year, 1, 1);
    }
    final db = await database;
    final rows = await _queryInRange(db, from, now);
    return rows.map(DiaryEntry.fromMap).toList();
  }

  Future<List<HeatmapCell>> heatmapCells({int days = 30}) async {
    final entries = await getAllEntries();
    final dayChars = <String, int>{};
    for (final e in entries.where((e) => e.hasContent)) {
      final key = '${e.year}-${e.month}-${e.day}';
      dayChars[key] = (dayChars[key] ?? 0) + e.content.trim().length;
    }

    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final windowStart = end.subtract(Duration(days: days - 1));
    var gridStart = windowStart;
    while (gridStart.weekday != DateTime.monday) {
      gridStart = gridStart.subtract(const Duration(days: 1));
    }

    final cells = <HeatmapCell>[];
    for (var d = gridStart; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      if (d.isBefore(windowStart)) {
        cells.add(HeatmapCell(date: d, level: 0));
        continue;
      }
      final key = '${d.year}-${d.month}-${d.day}';
      final chars = dayChars[key] ?? 0;
      var level = 0;
      if (chars > 0) {
        if (chars < 80) {
          level = 1;
        } else if (chars < 200) {
          level = 2;
        } else {
          level = 3;
        }
      }
      cells.add(HeatmapCell(date: d, level: level));
    }
    return cells;
  }

  Future<List<int>> weekdayWriteCounts() async {
    final entries = await getAllEntries();
    final counts = List.filled(7, 0);
    for (final e in entries.where((e) => e.hasContent)) {
      final wd = DateTime(e.year, e.month, e.day).weekday - 1;
      counts[wd]++;
    }
    return counts;
  }

  Future<Map<String, int>> timeOfDayBuckets() async {
    final entries = await getAllEntries();
    final buckets = {
      'morning': 0,
      'afternoon': 0,
      'evening': 0,
      'night': 0,
    };
    for (final e in entries.where((e) => e.hasContent)) {
      final hour = DateTime.fromMillisecondsSinceEpoch(e.updatedAt).hour;
      if (hour >= 5 && hour < 12) {
        buckets['morning'] = buckets['morning']! + 1;
      } else if (hour >= 12 && hour < 17) {
        buckets['afternoon'] = buckets['afternoon']! + 1;
      } else if (hour >= 17 && hour < 22) {
        buckets['evening'] = buckets['evening']! + 1;
      } else {
        buckets['night'] = buckets['night']! + 1;
      }
    }
    return buckets;
  }

  Future<List<int>> moodMosaic({int days = 28}) async {
    final entries = await getAllEntries();
    final byDate = <String, int>{};
    for (final e in entries.where((e) => e.hasContent && e.mood > 0)) {
      byDate['${e.year}-${e.month}-${e.day}'] = e.mood;
    }

    final now = DateTime.now();
    final result = <int>[];
    for (var i = days - 1; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final mood = byDate['${d.year}-${d.month}-${d.day}'];
      result.add(mood ?? -1);
    }
    return result;
  }
}
