import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChecklistItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  final bool isDefault;
  final bool isCompleted;
  final String? mouthCondition;
  final String? notes;

  const ChecklistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    required this.isDefault,
    this.isCompleted = false,
    this.mouthCondition,
    this.notes,
  });

  ChecklistItem copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    IconData? icon,
    Color? color,
    bool? isDefault,
    bool? isCompleted,
    String? mouthCondition,
    String? notes,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      isCompleted: isCompleted ?? this.isCompleted,
      mouthCondition: mouthCondition ?? this.mouthCondition,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    time,
    icon,
    color,
    isDefault,
    isCompleted,
    mouthCondition,
    notes,
  ];
}
