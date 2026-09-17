class DiaryEntry {
  final int? id;
  final int year;
  final int month;
  final int day;
  final String content;
  final int mood;
  final String weather;
  final String scene;
  final String location;
  final double? weight;
  final String? photoPath;
  final int createdAt;
  final int updatedAt;

  const DiaryEntry({
    this.id,
    required this.year,
    required this.month,
    required this.day,
    this.content = '',
    this.mood = 0,
    this.weather = '',
    this.scene = '',
    this.location = '',
    this.weight,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'content': content,
      'mood': mood,
      'weather': weather,
      'scene': scene,
      'location': location,
      'weight': weight,
      'photo_path': photoPath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'] as int?,
      year: map['year'] as int,
      month: map['month'] as int,
      day: map['day'] as int,
      content: map['content'] as String? ?? '',
      mood: map['mood'] as int? ?? 0,
      weather: map['weather'] as String? ?? '',
      scene: map['scene'] as String? ?? '',
      location: map['location'] as String? ?? '',
      weight: map['weight'] as double?,
      photoPath: map['photo_path'] as String?,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  DiaryEntry copyWith({
    int? id,
    int? year,
    int? month,
    int? day,
    String? content,
    int? mood,
    String? weather,
    String? scene,
    String? location,
    double? weight,
    String? photoPath,
    bool clearPhoto = false,
    bool clearWeight = false,
    int? createdAt,
    int? updatedAt,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      weather: weather ?? this.weather,
      scene: scene ?? this.scene,
      location: location ?? this.location,
      weight: clearWeight ? null : (weight ?? this.weight),
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasContent =>
      content.trim().isNotEmpty ||
      (photoPath != null && photoPath!.isNotEmpty);
}

class FutureMessage {
  final int? id;
  final String content;
  final int createdAt;
  final int unlockAt;

  const FutureMessage({
    this.id,
    required this.content,
    required this.createdAt,
    required this.unlockAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'created_at': createdAt,
      'unlock_at': unlockAt,
    };
  }

  factory FutureMessage.fromMap(Map<String, dynamic> map) {
    return FutureMessage(
      id: map['id'] as int?,
      content: map['content'] as String? ?? '',
      createdAt: map['created_at'] as int,
      unlockAt: map['unlock_at'] as int,
    );
  }
}

class DayStat {
  final int month;
  final int day;
  final int count;

  const DayStat({required this.month, required this.day, required this.count});
}

class MoodStat {
  final int mood;
  final int count;

  const MoodStat({required this.mood, required this.count});
}

class LocationStat {
  final String location;
  final int count;

  const LocationStat({required this.location, required this.count});
}

class DayCount {
  final String label;
  final int count;

  const DayCount({required this.label, required this.count});
}

class WeightPoint {
  final int timestamp;
  final double weight;

  const WeightPoint({required this.timestamp, required this.weight});
}

class HeatmapCell {
  final DateTime date;
  final int level;

  const HeatmapCell({required this.date, required this.level});
}

class TrailBadge {
  final String id;
  final String title;
  final String description;
  final bool unlocked;

  const TrailBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.unlocked,
  });
}
