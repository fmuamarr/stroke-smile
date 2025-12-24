import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/checklist_repository.dart';

class ToggleChecklistItem implements UseCase<void, ToggleChecklistParams> {
  final ChecklistRepository repository;

  ToggleChecklistItem(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleChecklistParams params) async {
    return await repository.toggleChecklistItem(
      params.itemId,
      params.date,
      params.isCompleted,
      mouthCondition: params.mouthCondition,
      notes: params.notes,
    );
  }
}

class ToggleChecklistParams extends Equatable {
  final String itemId;
  final DateTime date;
  final bool isCompleted;
  final String? mouthCondition;
  final String? notes;

  const ToggleChecklistParams({
    required this.itemId,
    required this.date,
    required this.isCompleted,
    this.mouthCondition,
    this.notes,
  });

  @override
  List<Object?> get props => [itemId, date, isCompleted, mouthCondition, notes];
}
