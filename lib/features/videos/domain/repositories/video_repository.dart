import 'package:dartz/dartz.dart';
import 'package:pohps_app/features/videos/domain/entities/video_tutorial.dart';
import '../../../../core/error/failures.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<VideoTutorial>>> getVideos();
  Future<Either<Failure, VideoTutorial>> downloadVideo(VideoTutorial video);
}
