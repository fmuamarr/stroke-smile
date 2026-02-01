enum InfographicCategory { stepByStep, emergency, education }

class Infographic {
  final String title;
  final String assetPath;
  final String description;
  final InfographicCategory category;

  const Infographic({
    required this.title,
    required this.assetPath,
    this.description = '',
    required this.category,
  });
}
