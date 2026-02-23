import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection/injection_container.dart';
import '../../../checklist/presentation/bloc/checklist_bloc.dart';
import '../bloc/search_bloc.dart';
import 'search_page.dart';

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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => sl<SearchBloc>(),
                                child: const SearchPage(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Cari panduan atau video...',
                                style: GoogleFonts.nunito(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
                            // A task is missed if current time > task end time + 1 hour buffer
                            final now = TimeOfDay.now();
                            final nowMinutes = now.hour * 60 + now.minute;

                            // Helper to parse time from format "HH:MM" or "HH:MM-HH:MM"
                            int? parseStartMinutes(String time) {
                              try {
                                // Handle range format "07:00-08:00"
                                final startTime = time.contains('-')
                                    ? time.split('-')[0]
                                    : time;
                                final parts = startTime.split(':');
                                return int.parse(parts[0]) * 60 +
                                    int.parse(parts[1]);
                              } catch (e) {
                                return null;
                              }
                            }

                            int? parseEndMinutes(String time) {
                              try {
                                // Handle range format "07:00-08:00"
                                final endTime = time.contains('-')
                                    ? time.split('-')[1]
                                    : time;
                                final parts = endTime.split(':');
                                return int.parse(parts[0]) * 60 +
                                    int.parse(parts[1]);
                              } catch (e) {
                                return null;
                              }
                            }

                            final nextItems = state.items.where((item) {
                              if (item.isCompleted) return false;

                              final endMinutes = parseEndMinutes(item.time);
                              if (endMinutes == null) return true;

                              // 1 hour buffer after end time to complete
                              final deadlineMinutes = endMinutes + 60;

                              // Keep if we are still before the deadline
                              return nowMinutes <= deadlineMinutes;
                            }).toList();

                            // Sort by start time to get the most relevant next task
                            nextItems.sort((a, b) {
                              final aStart = parseStartMinutes(a.time) ?? 0;
                              final bStart = parseStartMinutes(b.time) ?? 0;
                              return aStart.compareTo(bStart);
                            });

                            // Find the current or next upcoming task
                            // Prefer task that is currently active (now is within its time window)
                            final activeItem = nextItems
                                .cast<dynamic>()
                                .firstWhere((item) {
                                  final start = parseStartMinutes(item.time);
                                  final end = parseEndMinutes(item.time);
                                  if (start == null || end == null)
                                    return false;
                                  // Add 1 hour buffer after end time
                                  return nowMinutes >= start &&
                                      nowMinutes <= end + 60;
                                }, orElse: () => null);

                            // Use active item if found, otherwise first upcoming
                            final filteredItems = activeItem != null
                                ? [activeItem as dynamic]
                                : nextItems.where((item) {
                                    final start =
                                        parseStartMinutes(item.time) ?? 0;
                                    return nowMinutes <= start + 60;
                                  }).toList();

                            if (filteredItems.isEmpty) {
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

                            final nextTask = filteredItems.first;

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
                            title: 'Panduan Praktik\nPerawatan Mulut',
                            imagePath:
                                'assets/images/menu-perawatan-mulut.jpeg',
                            onTap: () => context.push('/steps'),
                          ),
                          _MenuCard(
                            title: 'Mode Cepat\n(Darurat)',
                            imagePath: 'assets/images/menu-mode-darurat.jpeg',
                            onTap: () => context.push('/emergency'),
                          ),
                          _MenuCard(
                            title: 'Video\nDemonstrasi',
                            imagePath: 'assets/images/menu-video.jpeg',
                            onTap: () => context.go('/videos'),
                          ),
                          _MenuCard(
                            title: 'Edukasi\nStroke',
                            imagePath: 'assets/images/menu-edukasi-stroke.jpeg',
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
  final String imagePath;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
