import 'package:equatable/equatable.dart';

class DailyChecklist extends Equatable {
  final DateTime date;
  final bool teethBrushedMorning;
  final bool teethBrushedNight;
  final bool mouthCleaned;
  final bool tongueCleaned;
  final int hygieneScore; // 1-10

  const DailyChecklist({
    required this.date,
    this.teethBrushedMorning = false,
    this.teethBrushedNight = false,
    this.mouthCleaned = false,
    this.tongueCleaned = false,
    this.hygieneScore = 0,
  });

  DailyChecklist copyWith({
    DateTime? date,
    bool? teethBrushedMorning,
    bool? teethBrushedNight,
    bool? mouthCleaned,
    bool? tongueCleaned,
    int? hygieneScore,
  }) {
    return DailyChecklist(
      date: date ?? this.date,
      teethBrushedMorning: teethBrushedMorning ?? this.teethBrushedMorning,
      teethBrushedNight: teethBrushedNight ?? this.teethBrushedNight,
      mouthCleaned: mouthCleaned ?? this.mouthCleaned,
      tongueCleaned: tongueCleaned ?? this.tongueCleaned,
      hygieneScore: hygieneScore ?? this.hygieneScore,
    );
  }

  @override
  List<Object?> get props => [
    date,
    teethBrushedMorning,
    teethBrushedNight,
    mouthCleaned,
    tongueCleaned,
    hygieneScore,
  ];
}
