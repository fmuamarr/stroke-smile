import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/step_guide.dart';
import '../../domain/repositories/step_repository.dart';
import '../datasources/step_local_datasource.dart';

class StepRepositoryImpl implements StepRepository {
  final StepLocalDataSource localDataSource;

  StepRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<StepGuide>>> getStepGuides() async {
    try {
      final localSteps = await localDataSource.getStepGuides();
      return Right(localSteps);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(CacheFailure('Unexpected error'));
    }
  }
}
