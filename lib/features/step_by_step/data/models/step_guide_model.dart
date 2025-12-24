import '../../domain/entities/step_guide.dart';
import '../../domain/entities/step_instruction.dart';

class StepGuideModel extends StepGuide {
  const StepGuideModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.steps,
  });

  factory StepGuideModel.fromJson(Map<String, dynamic> json) {
    return StepGuideModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      steps: (json['steps'] as List).map((item) {
        if (item is String) {
          return StepInstruction(text: item);
        } else if (item is Map<String, dynamic>) {
          return StepInstruction(
            text: item['text'],
            imageUrl: item['imageUrl'],
          );
        }
        return const StepInstruction(text: '');
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'steps': steps
          .map(
            (s) => s.imageUrl == null
                ? s.text
                : {'text': s.text, 'imageUrl': s.imageUrl},
          )
          .toList(),
    };
  }
}
