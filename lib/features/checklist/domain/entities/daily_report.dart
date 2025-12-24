import 'package:equatable/equatable.dart';
import 'checklist_item.dart';

class DailyReport extends Equatable {
  final DateTime date;
  final List<ChecklistItem> items;

  const DailyReport({required this.date, required this.items});

  @override
  List<Object?> get props => [date, items];
}
