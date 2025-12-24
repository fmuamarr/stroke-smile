import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class ArticleDetailPage extends StatelessWidget {
  final Map<String, String> article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.grayText),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.blueSoft.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Edukasi Kesehatan',
                style: GoogleFonts.nunito(
                  color: AppColors.blueSoft,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article['title']!,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.grayText,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                image: article.containsKey('imageUrl')
                    ? DecorationImage(
                        image: AssetImage(article['imageUrl']!),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage(
                          'assets/images/education_placeholder.png',
                        ), // Placeholder
                        fit: BoxFit.cover,
                      ),
              ),
              child: article.containsKey('imageUrl')
                  ? null
                  : const Center(
                      child: Icon(Icons.image, size: 64, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 24),
            MarkdownBody(
              data: article['content']!,
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.8,
                ),
                strong: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grayText,
                ),
                h1: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grayText,
                ),
                h2: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grayText,
                ),
                h3: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayText,
                ),
                listBullet: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
