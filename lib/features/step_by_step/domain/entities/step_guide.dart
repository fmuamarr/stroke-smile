import 'package:equatable/equatable.dart';
import 'step_instruction.dart';

class StepGuide extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<StepInstruction> steps;

  const StepGuide({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.steps,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, steps];
}
