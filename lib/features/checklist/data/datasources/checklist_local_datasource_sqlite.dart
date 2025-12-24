import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/database_helper.dart';
import '../models/checklist_model.dart';

abstract class ChecklistLocalDataSource {
  Future<List<ChecklistItemModel>> getChecklistItems();
  Future<List<ChecklistLogModel>> getChecklistLogs(String date);
  Future<List<ChecklistLogModel>> getChecklistLogsForMonth(String monthPrefix);
  Future<void> updateChecklistLog(ChecklistLogModel log);
  Future<DateTime> getStartDate();
}

class ChecklistLocalDataSourceImpl implements ChecklistLocalDataSource {
  final DatabaseHelper databaseHelper;
  final SharedPreferences sharedPreferences;

  ChecklistLocalDataSourceImpl({
    required this.databaseHelper,
    required this.sharedPreferences,
  });

  @override
  Future<DateTime> getStartDate() async {
    final dateStr = sharedPreferences.getString('install_date');
    if (dateStr != null) {
      return DateTime.parse(dateStr);
    }
    return DateTime.now();
  }

  @override
  Future<List<ChecklistItemModel>> getChecklistItems() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('checklist_items');
    return List.generate(maps.length, (i) {
      return ChecklistItemModel.fromJson(maps[i]);
    });
  }

  @override
  Future<List<ChecklistLogModel>> getChecklistLogs(String date) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'checklist_logs',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) {
      return ChecklistLogModel.fromJson(maps[i]);
    });
  }

  @override
  Future<List<ChecklistLogModel>> getChecklistLogsForMonth(
    String monthPrefix,
  ) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'checklist_logs',
      where: 'date LIKE ?',
      whereArgs: ['$monthPrefix%'],
    );
    return List.generate(maps.length, (i) {
      return ChecklistLogModel.fromJson(maps[i]);
    });
  }

  @override
  Future<void> updateChecklistLog(ChecklistLogModel log) async {
    final db = await databaseHelper.database;

    // Check if log exists for this item and date
    final existingLogs = await db.query(
      'checklist_logs',
      where: 'checklist_item_id = ? AND date = ?',
      whereArgs: [log.checklistItemId, log.date],
    );

    if (existingLogs.isNotEmpty) {
      await db.update(
        'checklist_logs',
        log.toJson(),
        where: 'checklist_item_id = ? AND date = ?',
        whereArgs: [log.checklistItemId, log.date],
      );
    } else {
      await db.insert('checklist_logs', log.toJson());
    }
  }
}
