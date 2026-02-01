import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../../../education/data/datasources/infographic_data.dart';
import '../../../step_by_step/data/datasources/step_local_datasource.dart';
import '../../../videos/domain/repositories/video_repository.dart';
import '../../../education/domain/entities/infographic.dart';

class SearchRepositoryImpl implements SearchRepository {
  final StepLocalDataSource stepLocalDataSource;
  final VideoRepository videoRepository;

  SearchRepositoryImpl({
    required this.stepLocalDataSource,
    required this.videoRepository,
  });

  @override
  Future<List<SearchResult>> searchContent(String query) async {
    final lowerQuery = query.toLowerCase();
    final List<SearchResult> results = [];

    // Search Infographics
    for (final info in infographics) {
      if (info.title.toLowerCase().contains(lowerQuery)) {
        results.add(
          SearchResult(
            id: info.title,
            title: info.title,
            description: info.category == InfographicCategory.emergency
                ? 'Panduan Darurat'
                : info.category == InfographicCategory.stepByStep
                ? 'Panduan Step-by-Step'
                : info.category == InfographicCategory.education
                ? 'Infografis Edukasi'
                : 'Infografis Perawatan',
            type: SearchResultType.infographic,
            route: '/infographic/detail',
            extraData: {'infographic': info},
          ),
        );
      }
    }

    // // Search Step by Step Guides
    // try {
    //   final steps = await stepLocalDataSource.getStepGuides();
    //   for (final step in steps) {
    //     if (step.title.toLowerCase().contains(lowerQuery) ||
    //         step.description.toLowerCase().contains(lowerQuery)) {
    //       results.add(
    //         SearchResult(
    //           id: step.id,
    //           title: step.title,
    //           description: step.description,
    //           type: SearchResultType.stepByStep,
    //           route: '/steps/detail',
    //           extraData: {'step': step},
    //         ),
    //       );
    //     }
    //   }
    // } catch (_) {
    //   // Ignore step loading errors
    // }

    // Search Videos
    final videosResult = await videoRepository.getVideos();
    videosResult.fold((failure) {}, (videos) {
      for (final video in videos) {
        if (video.title.toLowerCase().contains(lowerQuery)) {
          results.add(
            SearchResult(
              id: video.id,
              title: video.title,
              description: 'Video Tutorial',
              type: SearchResultType.video,
              route: '/videos/player',
              extraData: {'url': video.url, 'title': video.title},
            ),
          );
        }
      }
    });

    // Search Emergency Guides (Hardcoded similar to EmergencyPage)
    // NOTE: Ideally this should come from a datasource/repository as well
    // final emergencyCases = [
    //   {
    //     'title': 'Pasien Sulit Membuka Mulut',
    //     'desc': 'Panduan menangani pasien sulit membuka mulut',
    //   },
    //   {
    //     'title': 'Pasien Batuk Saat Dibersihkan',
    //     'desc': 'Panduan penanganan saat pasien batuk',
    //   },
    //   {
    //     'title': 'Pasien Menggunakan NGT',
    //     'desc': 'Panduan oral care pasien dengan NGT',
    //   },
    //   {
    //     'title': 'Pasien Tidak Sadar / Tirah Baring',
    //     'desc': 'Panduan oral care pasien bedrest',
    //   },
    // ];

    // for (final emergency in emergencyCases) {
    //   if ((emergency['title'] as String).toLowerCase().contains(lowerQuery)) {
    //     results.add(
    //       SearchResult(
    //         id: emergency['title'] as String,
    //         title: emergency['title'] as String,
    //         description: 'Panduan Darurat',
    //         type: SearchResultType.emergency,
    //         route: '/emergency-guide',
    //       ),
    //     );
    //   }
    // }

    return results;
  }
}
