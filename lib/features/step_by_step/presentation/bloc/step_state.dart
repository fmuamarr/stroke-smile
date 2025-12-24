import 'package:equatable/equatable.dart';
import '../../domain/entities/step_guide.dart';

abstract class StepState extends Equatable {
  const StepState();

  @override
  List<Object> get props => [];
}

class StepInitial extends StepState {}

class StepLoading extends StepState {}

class StepLoaded extends StepState {
  final List<StepGuide> steps;

  const StepLoaded(this.steps);

  @override
  List<Object> get props => [steps];
}

class StepError extends StepState {
  final String message;

  const StepError(this.message);

  @override
  List<Object> get props => [message];
}
