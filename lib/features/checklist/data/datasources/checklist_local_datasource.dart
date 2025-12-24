import 'package:hive/hive.dart';
import 'package:pohps_app/features/checklist/data/models/daily_checklist_model.dart';
import '../../../../core/error/failures.dart';

abstract class ChecklistLocalDataSource {
  Future<DailyChecklistModel?> getChecklist(DateTime date);
  Future<void> saveChecklist(DailyChecklistModel checklist);
}

class ChecklistLocalDataSourceImpl implements ChecklistLocalDataSource {
  final Box box;

  ChecklistLocalDataSourceImpl({required this.box});

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  @override
  Future<DailyChecklistModel?> getChecklist(DateTime date) async {
    try {
      final key = _getDateKey(date);
      final data = box.get(key);
      if (data != null) {
        return DailyChecklistModel.fromMap(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      throw const CacheFailure('Failed to load checklist');
    }
  }

  @override
  Future<void> saveChecklist(DailyChecklistModel checklist) async {
    try {
      final key = _getDateKey(checklist.date);
      await box.put(key, checklist.toMap());
    } catch (e) {
      throw const CacheFailure('Failed to save checklist');
    }
  }
}
