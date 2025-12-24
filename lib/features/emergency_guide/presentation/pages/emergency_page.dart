import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  final List<Map<String, dynamic>> _emergencyCases = const [
    {
      'title': 'Pasien Sulit Membuka Mulut',
      'icon': Icons.lock_outline,
      'color': Colors.orange,
      'instructions': [
        'Jangan dipaksa',
        'Gunakan spons lembap',
        'Gunakan bite block bila perlu',
        'Jika kejang/tetanus → rujuk medis',
      ],
    },
    {
      'title': 'Pasien Batuk Saat Dibersihkan',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.red,
      'instructions': [
        'Hentikan tindakan',
        'Atur posisi kepala ke samping',
        'Jika kebiruan → panggil tenaga medis',
      ],
    },
    {
      'title': 'Pasien Menggunakan NGT',
      'icon': Icons.medical_services_outlined,
      'color': Colors.blue,
      'instructions': [
        'Kepala ≥30°',
        'Hindari cairan berlebih',
        'Oral care tetap wajib',
      ],
    },
    {
      'title': 'Pasien Tidak Sadar / Tirah Baring',
      'icon': Icons.nights_stay_outlined,
      'color': Colors.grey,
      'instructions': [
        'Teknik sangat hati-hati',
        'Kepala miring ke bawah/samping',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFFF5F5,
      ), // Light red tint for emergency context
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.emergencyTitle,
          style: GoogleFonts.poppins(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.error),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      AppStrings.emergencyWarning,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: _emergencyCases.length,
                itemBuilder: (context, index) {
                  final item = _emergencyCases[index];
                  return _EmergencyCard(
                    title: item['title'],
                    icon: item['icon'],
                    color: item['color'],
                    onTap: () => _showEmergencyDetail(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDetail(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item['icon'], color: item['color'], size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grayText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Tindakan Cepat:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.grayText,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: (item['instructions'] as List).length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final instruction = item['instructions'][index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.check_circle,
                          color: item['color'],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          instruction,
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grayText,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: item['color'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _EmergencyCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.grayText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
