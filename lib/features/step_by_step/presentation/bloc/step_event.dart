import 'package:equatable/equatable.dart';
// import '../../domain/entities/step_guide.dart';

abstract class StepEvent extends Equatable {
  const StepEvent();

  @override
  List<Object> get props => [];
}

class GetStepGuidesEvent extends StepEvent {}
