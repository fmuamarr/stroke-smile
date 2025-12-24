import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/step_repository.dart';
import 'step_event.dart';
import 'step_state.dart';

class StepBloc extends Bloc<StepEvent, StepState> {
  final StepRepository repository;

  StepBloc({required this.repository}) : super(StepInitial()) {
    on<GetStepGuidesEvent>(_onGetStepGuides);
  }

  Future<void> _onGetStepGuides(
    GetStepGuidesEvent event,
    Emitter<StepState> emit,
  ) async {
    emit(StepLoading());
    final result = await repository.getStepGuides();
    result.fold(
      (failure) => emit(StepError(failure.message)),
      (steps) => emit(StepLoaded(steps)),
    );
  }
}
