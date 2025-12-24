import 'package:equatable/equatable.dart';

class StepInstruction extends Equatable {
  final String text;
  final String? imageUrl;

  const StepInstruction({required this.text, this.imageUrl});

  @override
  List<Object?> get props => [text, imageUrl];
}
