import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.grayText),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            color: AppColors.grayText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Jadwal Pengingat Harian',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.grayText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kami akan mengingatkan Anda 15 menit sebelum waktu perawatan.',
            style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _NotificationItem(
            time: '06:45',
            title: 'Persiapan Pagi',
            message:
                'Waktunya bersiap untuk perawatan mulut pagi. Sentuhan kasih Anda sangat berarti.',
            icon: Icons.wb_sunny_outlined,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _NotificationItem(
            time: '11:45',
            title: 'Persiapan Siang',
            message:
                'Setelah makan siang nanti, jangan lupa bersihkan mulut pasien ya.',
            icon: Icons.cleaning_services_outlined,
            color: AppColors.blueSoft,
          ),
          const SizedBox(height: 16),
          _NotificationItem(
            time: '18:45',
            title: 'Persiapan Malam',
            message:
                'Mari bersiap untuk perawatan mulut sebelum tidur agar pasien nyaman.',
            icon: Icons.nights_stay_outlined,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String time;
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  const _NotificationItem({
    required this.time,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grayText,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
