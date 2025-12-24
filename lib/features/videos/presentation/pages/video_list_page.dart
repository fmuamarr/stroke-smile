import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection/injection_container.dart';
import '../../domain/entities/video_tutorial.dart';
import '../../domain/repositories/video_repository.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List<VideoTutorial> _videos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final result = await sl<VideoRepository>().getVideos();
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat video';
        });
      },
      (videos) {
        setState(() {
          _isLoading = false;
          _videos = videos;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.blueSoft,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                'Video Tutorial',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.blueSoft, AppColors.blueLight],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(child: Center(child: Text(_errorMessage!)))
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final video = _videos[index];
                  return _buildVideoCard(context, video);
                }, childCount: _videos.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoTutorial video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push(
              '/videos/player',
              extra: {'url': video.url, 'title': video.title},
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: _VideoThumbnail(videoUrl: video.url),
                        ),
                        Container(color: Colors.black.withOpacity(0.3)),
                        const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.grayText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ketuk untuk memutar video',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Simulate download
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mengunduh video...'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.download_rounded,
                        color: AppColors.blueSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoThumbnail extends StatefulWidget {
  final String videoUrl;

  const _VideoThumbnail({required this.videoUrl});

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  Uint8List? _thumbnailBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  @override
  void didUpdateWidget(covariant _VideoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _generateThumbnail();
    }
  }

  Future<void> _generateThumbnail() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: widget.videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 512,
        quality: 75,
      );

      if (mounted) {
        setState(() {
          _thumbnailBytes = bytes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_thumbnailBytes != null) {
      return Image.memory(
        _thumbnailBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Container(
      color: Colors.grey.shade300,
      child: const Icon(Icons.videocam_off, size: 50, color: Colors.grey),
    );
  }
}
