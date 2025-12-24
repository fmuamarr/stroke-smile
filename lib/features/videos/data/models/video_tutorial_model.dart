import '../../domain/entities/video_tutorial.dart';

class VideoTutorialModel extends VideoTutorial {
  const VideoTutorialModel({
    required super.id,
    required super.title,
    required super.url,
    super.localPath,
    super.isDownloaded,
  });

  factory VideoTutorialModel.fromEntity(VideoTutorial entity) {
    return VideoTutorialModel(
      id: entity.id,
      title: entity.title,
      url: entity.url,
      localPath: entity.localPath,
      isDownloaded: entity.isDownloaded,
    );
  }

  // Hive adapter logic will be needed here or generated
  // For now, manual mapping for Hive if not using generator
  factory VideoTutorialModel.fromMap(Map<dynamic, dynamic> map) {
    return VideoTutorialModel(
      id: map['id'],
      title: map['title'],
      url: map['url'],
      localPath: map['localPath'],
      isDownloaded: map['isDownloaded'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'localPath': localPath,
      'isDownloaded': isDownloaded,
    };
  }
}
