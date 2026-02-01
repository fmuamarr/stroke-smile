import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/infographic.dart';

class InfographicDetailPage extends StatelessWidget {
  final Infographic infographic;

  const InfographicDetailPage({super.key, required this.infographic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueLight2,
      appBar: AppBar(
        title: Text(infographic.title),
        backgroundColor: AppColors.blueLight2,
        foregroundColor: AppColors.white,
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.asset(
          infographic.assetPath,
          fit: BoxFit.contain,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Text('Gagal memuat gambar')),
        ),
      ),
    );
  }
}
