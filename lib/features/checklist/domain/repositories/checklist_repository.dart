import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/checklist_item.dart';
import '../entities/daily_report.dart';

abstract class ChecklistRepository {
  Future<Either<Failure, List<ChecklistItem>>> getDailyChecklist(DateTime date);
  Future<Either<Failure, void>> toggleChecklistItem(
    String itemId,
    DateTime date,
    bool isCompleted, {
    String? mouthCondition,
    String? notes,
  });
  Future<Either<Failure, DateTime>> getStartDate();
  Future<Either<Failure, Map<DateTime, double>>> getMonthlyCompletion(
    DateTime month,
  );
  Future<Either<Failure, List<DailyReport>>> getMonthlyReports(DateTime month);
}
