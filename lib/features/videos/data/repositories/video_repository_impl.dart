import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/video_tutorial.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_local_datasource.dart';
import '../models/video_tutorial_model.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoLocalDataSource localDataSource;
  final Dio dio;

  VideoRepositoryImpl({required this.localDataSource, required this.dio});

  // Hardcoded list of videos available
  final List<VideoTutorialModel> _allVideos = [
    const VideoTutorialModel(
      id: '1',
      title: 'Teknik Menyikat Gigi',
      url:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // Placeholder
    ),
    const VideoTutorialModel(
      id: '2',
      title: 'Teknik Menjaga Jalan Napas',
      url:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // Placeholder
    ),
  ];

  @override
  Future<Either<Failure, List<VideoTutorial>>> getVideos() async {
    try {
      final downloadedVideos = await localDataSource.getDownloadedVideos();
      final Map<String, VideoTutorialModel> downloadedMap = {
        for (var v in downloadedVideos) v.id: v,
      };

      final List<VideoTutorial> result = _allVideos.map((video) {
        if (downloadedMap.containsKey(video.id)) {
          return downloadedMap[video.id]!;
        }
        return video;
      }).toList();

      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VideoTutorial>> downloadVideo(
    VideoTutorial video,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${video.id}.mp4';

      await dio.download(video.url, filePath);

      final updatedVideo = VideoTutorialModel(
        id: video.id,
        title: video.title,
        url: video.url,
        localPath: filePath,
        isDownloaded: true,
      );

      await localDataSource.saveVideoMetadata(updatedVideo);

      return Right(updatedVideo);
    } catch (e) {
      return Left(ServerFailure('Download failed: ${e.toString()}'));
    }
  }
}
