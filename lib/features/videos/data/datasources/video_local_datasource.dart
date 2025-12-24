import 'package:hive/hive.dart';
import '../models/video_tutorial_model.dart';

abstract class VideoLocalDataSource {
  Future<List<VideoTutorialModel>> getDownloadedVideos();
  Future<void> saveVideoMetadata(VideoTutorialModel video);
}

class VideoLocalDataSourceImpl implements VideoLocalDataSource {
  final Box box;

  VideoLocalDataSourceImpl({required this.box});

  @override
  Future<List<VideoTutorialModel>> getDownloadedVideos() async {
    return box.values.cast<VideoTutorialModel>().toList();
  }

  @override
  Future<void> saveVideoMetadata(VideoTutorialModel video) async {
    await box.put(video.id, video);
  }
}
