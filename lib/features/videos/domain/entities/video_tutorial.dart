import 'package:equatable/equatable.dart';

class VideoTutorial extends Equatable {
  final String id;
  final String title;
  final String url;
  final String? localPath;
  final bool isDownloaded;

  const VideoTutorial({
    required this.id,
    required this.title,
    required this.url,
    this.localPath,
    this.isDownloaded = false,
  });

  VideoTutorial copyWith({
    String? id,
    String? title,
    String? url,
    String? localPath,
    bool? isDownloaded,
  }) {
    return VideoTutorial(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  @override
  List<Object?> get props => [id, title, url, localPath, isDownloaded];
}
