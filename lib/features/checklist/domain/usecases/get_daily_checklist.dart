import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/checklist_item.dart';
import '../repositories/checklist_repository.dart';

class GetDailyChecklist implements UseCase<List<ChecklistItem>, DateTime> {
  final ChecklistRepository repository;

  GetDailyChecklist(this.repository);

  @override
  Future<Either<Failure, List<ChecklistItem>>> call(DateTime date) async {
    return await repository.getDailyChecklist(date);
  }
}
