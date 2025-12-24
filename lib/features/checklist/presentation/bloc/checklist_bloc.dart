import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/checklist_item.dart';
import '../../domain/usecases/get_daily_checklist.dart';
import '../../domain/usecases/get_start_date.dart';
import '../../domain/usecases/toggle_checklist_item.dart';

// Events
abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object?> get props => [];
}

class LoadChecklist extends ChecklistEvent {
  final DateTime date;

  const LoadChecklist(this.date);

  @override
  List<Object?> get props => [date];
}

class ToggleItem extends ChecklistEvent {
  final String itemId;
  final DateTime date;
  final bool isCompleted;
  final String? mouthCondition;
  final String? notes;

  const ToggleItem({
    required this.itemId,
    required this.date,
    required this.isCompleted,
    this.mouthCondition,
    this.notes,
  });

  @override
  List<Object?> get props => [itemId, date, isCompleted, mouthCondition, notes];
}

// States
abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object?> get props => [];
}

class ChecklistInitial extends ChecklistState {}

class ChecklistLoading extends ChecklistState {}

class ChecklistLoaded extends ChecklistState {
  final List<ChecklistItem> items;
  final DateTime date;
  final DateTime startDate;

  const ChecklistLoaded({
    required this.items,
    required this.date,
    required this.startDate,
  });

  @override
  List<Object?> get props => [items, date, startDate];
}

class ChecklistError extends ChecklistState {
  final String message;

  const ChecklistError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final GetDailyChecklist getDailyChecklist;
  final ToggleChecklistItem toggleChecklistItem;
  final GetStartDate getStartDate;

  DateTime? _startDate;

  ChecklistBloc({
    required this.getDailyChecklist,
    required this.toggleChecklistItem,
    required this.getStartDate,
  }) : super(ChecklistInitial()) {
    on<LoadChecklist>(_onLoadChecklist);
    on<ToggleItem>(_onToggleItem);
  }

  Future<void> _onLoadChecklist(
    LoadChecklist event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(ChecklistLoading());

    if (_startDate == null) {
      final startResult = await getStartDate(NoParams());
      startResult.fold(
        (failure) => _startDate = DateTime.now(),
        (date) => _startDate = date,
      );
    }

    final result = await getDailyChecklist(event.date);
    result.fold(
      (failure) => emit(const ChecklistError('Failed to load checklist')),
      (items) => emit(
        ChecklistLoaded(items: items, date: event.date, startDate: _startDate!),
      ),
    );
  }

  Future<void> _onToggleItem(
    ToggleItem event,
    Emitter<ChecklistState> emit,
  ) async {
    // Optimistic update
    if (state is ChecklistLoaded) {
      final currentState = state as ChecklistLoaded;
      final updatedItems = currentState.items.map((item) {
        if (item.id == event.itemId) {
          return item.copyWith(
            isCompleted: event.isCompleted,
            mouthCondition: event.mouthCondition,
            notes: event.notes,
          );
        }
        return item;
      }).toList();

      emit(
        ChecklistLoaded(
          items: updatedItems,
          date: currentState.date,
          startDate: currentState.startDate,
        ),
      );

      final result = await toggleChecklistItem(
        ToggleChecklistParams(
          itemId: event.itemId,
          date: event.date,
          isCompleted: event.isCompleted,
          mouthCondition: event.mouthCondition,
          notes: event.notes,
        ),
      );

      result.fold((failure) {
        // Revert on failure
        emit(ChecklistError(failure.message));
        add(LoadChecklist(event.date));
      }, (_) {});
    }
  }
}
