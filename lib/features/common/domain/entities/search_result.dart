import 'package:equatable/equatable.dart';

enum SearchResultType { infographic, stepByStep, video, emergency }

class SearchResult extends Equatable {
  final String id;
  final String title;
  final String description;
  final SearchResultType type;
  final String route;
  final Map<String, dynamic>? extraData;

  const SearchResult({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.route,
    this.extraData,
  });

  @override
  List<Object?> get props => [id, title, description, type, route, extraData];
}
