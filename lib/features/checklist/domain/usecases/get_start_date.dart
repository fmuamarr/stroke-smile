import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/checklist_repository.dart';

class GetStartDate implements UseCase<DateTime, NoParams> {
  final ChecklistRepository repository;

  GetStartDate(this.repository);

  @override
  Future<Either<Failure, DateTime>> call(NoParams params) async {
    return await repository.getStartDate();
  }
}
