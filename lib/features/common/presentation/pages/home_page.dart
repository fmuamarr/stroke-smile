import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection/injection_container.dart';
import '../../../checklist/presentation/bloc/checklist_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChecklistBloc>()..add(LoadChecklist(DateTime.now())),
      child: Scaffold(
        backgroundColor: const Color(
          0xFFF8F9FE,
        ), // Light background from reference
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.blueLight,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Halo, Keluarga Pasien',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.grayText,
                                    ),
                                  ),
                                  Text(
                                    'Siap merawat hari ini?',
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => context.push('/notifications'),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Search Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.search, color: Colors.grey),
                            hintText: 'Cari panduan atau video...',
                            hintStyle: GoogleFonts.nunito(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Upcoming Activity (Next Task)
                      Text(
                        'Aktivitas Berikutnya',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grayText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<ChecklistBloc, ChecklistState>(
                        builder: (context, state) {
                          if (state is ChecklistLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is ChecklistLoaded) {
                            // Filter for incomplete items that are NOT missed (skipped)
                            // A task is missed if current time > task time + 3 hours
                            final now = TimeOfDay.now();
                            final nowMinutes = now.hour * 60 + now.minute;

                            final nextItems = state.items.where((item) {
                              if (item.isCompleted) return false;

                              try {
                                final parts = item.time.split(':');
                                final startHour = int.parse(parts[0]);
                                final startMinute = int.parse(parts[1]);
                                final startMinutes =
                                    startHour * 60 + startMinute;
                                // 3 hour window to complete
                                final endMinutes = startMinutes + (3 * 60);

                                // Keep if we are still before the end of the window
                                return nowMinutes <= endMinutes;
                              } catch (e) {
                                return true; // Keep if parse fails
                              }
                            }).toList();

                            if (nextItems.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.greenHealth.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.greenHealth,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        'Semua aktivitas hari ini selesai!',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.greenHealth,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final nextTask = nextItems.first;

                            return InkWell(
                              onTap: () {
                                context.push('/checklist');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.blueSoft,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        nextTask.icon,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nextTask.title,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            nextTask.time,
                                            style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (state is ChecklistError) {
                            return Text('Error: ${state.message}');
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 24),

                      // Menu Grid (Replacing "Today Activities")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Menu Utama',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grayText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                          _MenuCard(
                            title: 'Panduan\nStep-by-Step',
                            icon: Icons.format_list_numbered_rounded,
                            color: AppColors.blueLight.withOpacity(0.2),
                            iconColor: AppColors.blueSoft,
                            onTap: () => context.push('/steps'),
                          ),
                          _MenuCard(
                            title: 'Mode Cepat\n(Darurat)',
                            icon: Icons.medical_services_outlined,
                            color: AppColors.error.withOpacity(0.1),
                            iconColor: AppColors.error,
                            onTap: () => context.push('/emergency'),
                          ),
                          _MenuCard(
                            title: 'Video\nDemonstrasi',
                            icon: Icons.play_circle_outline_rounded,
                            color: Colors.purple.withOpacity(0.1),
                            iconColor: Colors.purple,
                            onTap: () => context.go('/videos'),
                          ),
                          _MenuCard(
                            title: 'Edukasi\nStroke',
                            icon: Icons.school_outlined,
                            color: Colors.orange.withOpacity(0.1),
                            iconColor: Colors.orange,
                            onTap: () => context.go('/education'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
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
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.grayText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
