import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  final List<Map<String, String>> _articles = const [
    {
      'title': 'Dasar Pengetahuan Stroke',
      'description': 'Apa itu stroke dan gejala FAST yang harus diwaspadai.',
      'imageUrl': 'assets/images/types-of-stroke.jpg',
      'content': '''**Apa itu Stroke?**
Stroke terjadi ketika aliran darah ke otak terganggu.
*   **Stroke Iskemik:** Penyumbatan pembuluh darah.
*   **Stroke Hemoragik:** Pecahnya pembuluh darah.

**Tanda Bahaya (SeGeRa Ke RS):**
*   **Senyum:** Tidak simetris / wajah perot.
*   **Gerak:** Melemah pada satu sisi tubuh.
*   **Bicara:** Pelo atau tidak jelas.
*   **Kebas:** Mati rasa separuh tubuh.
*   **Rabun:** Pandangan kabur tiba-tiba.
*   **Sakit Kepala:** Hebat dan mendadak.

**Mitos Berbahaya:**
*   Menusuk jari dengan jarum (TIDAK BOLEH).
*   Memberi minum saat tersedak (BERBAHAYA).''',
    },
    {
      'title': 'Mulut Kotor & Pneumonia',
      'description':
          'Mengapa sikat gigi bisa menyelamatkan nyawa pasien stroke.',
      'imageUrl': 'assets/images/bersihkan-lidah.jpg',
      'content': '''**Hubungan Mulut & Paru-paru:**
Mulut yang kotor penuh dengan bakteri jahat. Pada pasien stroke yang sulit menelan (disfagia), air liur yang mengandung bakteri ini bisa "salah jalan" masuk ke saluran napas (aspirasi).

**Pneumonia Aspirasi:**
Jika bakteri masuk ke paru-paru, akan terjadi infeksi berat (Pneumonia). Ini adalah penyebab kematian umum pada pasien stroke.

**Pencegahan Utama:**
Perawatan mulut terbukti menurunkan angka kematian (mortalitas) dan mencegah infeksi saluran napas bawah.''',
    },
    {
      'title': 'Posisi Aman (Cegah Tersedak)',
      'description': 'Posisi tubuh yang benar saat makan dan perawatan mulut.',
      'imageUrl': 'assets/images/default-1.jpeg',
      'content': '''**Aturan Posisi:**
1.  **Duduk Tegak (90°):** Posisi paling aman.
2.  **Setengah Duduk (30-45°):** Naikkan bagian kepala tempat tidur.
3.  **Chin Tuck (Dagu ke Dada):** Saat menelan, tundukkan kepala sedikit.
4.  **Posisi Lateral Semi-Upright:** Miring dengan kepala agak tinggi.

**PENTING:**
Pertahankan posisi duduk/setengah duduk selama **30 menit setelah makan** untuk mencegah makanan naik kembali (refluks).''',
    },
    {
      'title': 'Makanan & Minuman Aman',
      'description': 'Tekstur makanan yang aman untuk mencegah tersedak.',
      'imageUrl': 'assets/images/default-2.jpeg',
      'content': '''**Tekstur yang Disarankan (Aman):**
*   **Makanan Lunak/Halus:** Bubur saring, puree, kentang tumbuk.
*   **Cairan Kental:** Air yang dikentalkan (thickened liquids) bergerak lebih lambat.

**HINDARI (Risiko Tinggi):**
*   **Cairan Encer:** Air putih biasa (sangat cepat mengalir).
*   **Makanan Kering/Remah:** Biskuit kering, kerupuk.
*   **Tekstur Campuran:** Sup encer dengan potongan besar (pasien bingung membedakan cair dan padat).''',
    },
    {
      'title': 'Perawatan Sisi Lemah (Hemiparesis)',
      'description': 'Tips khusus untuk sisi wajah yang lumpuh.',
      'imageUrl': 'assets/images/default-3.jpeg',
      'content': '''**Prinsip Perawatan:**
1.  **Libatkan Pasien:** Ajak pasien memegang sikat jika mampu.
2.  **Posisi Perawat:** Berdiri di sisi yang SEHAT (non-paretik) agar pasien menoleh ke arah Anda.
3.  **Stabilisasi Rahang:** Bantu menopang rahang jika lemah.
4.  **Modifikasi Alat:** Gunakan gagang sikat yang diperbesar jika genggaman lemah.

**Cek Sisa Makanan:**
Selalu periksa pipi bagian dalam sisi lemah (pocketing) setelah makan.''',
    },
    {
      'title': 'Mulut Kering (Xerostomia)',
      'description':
          'Mengatasi mulut kering akibat obat atau bernapas lewat mulut.',
      'imageUrl': 'assets/images/gigi-palsu.jpeg',
      'content': '''**Penyebab:**
*   Efek samping obat (Antihipertensi, Antidepresan, Diuretik).
*   Gangguan saraf.
*   Bernapas lewat mulut.
*   Kurang asupan cairan.

**Dampak:**
*   Risiko gigi berlubang (karies) meningkat.
*   Sulit bicara dan menelan.
*   Gigi palsu menjadi longgar.
*   Risiko infeksi jamur (Candidiasis).

**Solusi:**
*   Oleskan pelembap bibir (Vaseline/Minyak Zaitun).
*   Basahi mulut sesering mungkin (jika aman).''',
    },
    {
      'title': 'Tanda Bahaya Mulut & Kapan ke Dokter',
      'description': 'Gejala yang memerlukan penanganan medis segera.',
      'imageUrl': 'assets/images/masker-sarung-tangan.jpg',
      'content': '''**Segera Konsultasi ke Tenaga Kesehatan Jika:**
1.  **Gusi Berdarah Spontan:** Terus menerus tanpa disikat.
2.  **Pembengkakan:** Bengkak pada gusi atau wajah.
3.  **Luka Tak Sembuh:** Sariawan/luka lebih dari 2 minggu.
4.  **Nyeri Hebat:** Pasien menolak makan karena sakit.
5.  **Tanda Infeksi Umum:** Demam tinggi.
6.  **Tanda Pneumonia:** Sesak napas, suara napas "grok-grok" (basah).''',
    },
  ];

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
                'Edukasi',
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
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final article = _articles[index];
                return _buildArticleCard(context, article, index);
              }, childCount: _articles.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(
    BuildContext context,
    Map<String, String> article,
    int index,
  ) {
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
            context.push('/education/detail', extra: article);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.blueSoft.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueSoft,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grayText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article['description']!,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
