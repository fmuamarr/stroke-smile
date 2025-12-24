import 'package:equatable/equatable.dart';

class ChecklistItemModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String time;
  final int iconCodePoint;
  final int colorValue;
  final bool isDefault;

  const ChecklistItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.iconCodePoint,
    required this.colorValue,
    required this.isDefault,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return ChecklistItemModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: json['time'],
      iconCodePoint: json['icon_code_point'],
      colorValue: json['color_value'],
      isDefault: json['is_default'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'icon_code_point': iconCodePoint,
      'color_value': colorValue,
      'is_default': isDefault ? 1 : 0,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    time,
    iconCodePoint,
    colorValue,
    isDefault,
  ];
}

class ChecklistLogModel extends Equatable {
  final int? id;
  final String checklistItemId;
  final String date;
  final bool isCompleted;
  final String? completedAt;
  final String? mouthCondition;
  final String? notes;

  const ChecklistLogModel({
    this.id,
    required this.checklistItemId,
    required this.date,
    required this.isCompleted,
    this.completedAt,
    this.mouthCondition,
    this.notes,
  });

  factory ChecklistLogModel.fromJson(Map<String, dynamic> json) {
    return ChecklistLogModel(
      id: json['id'],
      checklistItemId: json['checklist_item_id'],
      date: json['date'],
      isCompleted: json['is_completed'] == 1,
      completedAt: json['completed_at'],
      mouthCondition: json['mouth_condition'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checklist_item_id': checklistItemId,
      'date': date,
      'is_completed': isCompleted ? 1 : 0,
      'completed_at': completedAt,
      'mouth_condition': mouthCondition,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    id,
    checklistItemId,
    date,
    isCompleted,
    completedAt,
    mouthCondition,
    notes,
  ];
}
