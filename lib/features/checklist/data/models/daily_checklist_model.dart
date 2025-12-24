import '../../domain/entities/daily_checklist.dart';

class DailyChecklistModel extends DailyChecklist {
  const DailyChecklistModel({
    required super.date,
    super.teethBrushedMorning,
    super.teethBrushedNight,
    super.mouthCleaned,
    super.tongueCleaned,
    super.hygieneScore,
  });

  factory DailyChecklistModel.fromEntity(DailyChecklist entity) {
    return DailyChecklistModel(
      date: entity.date,
      teethBrushedMorning: entity.teethBrushedMorning,
      teethBrushedNight: entity.teethBrushedNight,
      mouthCleaned: entity.mouthCleaned,
      tongueCleaned: entity.tongueCleaned,
      hygieneScore: entity.hygieneScore,
    );
  }

  factory DailyChecklistModel.fromMap(Map<dynamic, dynamic> map) {
    return DailyChecklistModel(
      date: DateTime.parse(map['date']),
      teethBrushedMorning: map['teethBrushedMorning'] ?? false,
      teethBrushedNight: map['teethBrushedNight'] ?? false,
      mouthCleaned: map['mouthCleaned'] ?? false,
      tongueCleaned: map['tongueCleaned'] ?? false,
      hygieneScore: map['hygieneScore'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'teethBrushedMorning': teethBrushedMorning,
      'teethBrushedNight': teethBrushedNight,
      'mouthCleaned': mouthCleaned,
      'tongueCleaned': tongueCleaned,
      'hygieneScore': hygieneScore,
    };
  }
}
