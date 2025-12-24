import 'package:dartz/dartz.dart';
import 'package:pohps_app/features/step_by_step/domain/entities/step_guide.dart';
import '../../../../core/error/failures.dart';

abstract class StepRepository {
  Future<Either<Failure, List<StepGuide>>> getStepGuides();
}
