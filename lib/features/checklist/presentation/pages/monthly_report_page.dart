import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection/injection_container.dart';
import '../../domain/entities/checklist_item.dart';
import '../../domain/entities/daily_report.dart';
import '../../domain/repositories/checklist_repository.dart';

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<DailyReport> _reports = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now(); // Default to today
    _fetchReports(_focusedDay);
  }

  Future<void> _fetchReports(DateTime month) async {
    setState(() => _isLoading = true);
    final result = await sl<ChecklistRepository>().getMonthlyReports(month);
    result.fold(
      (failure) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      },
      (reports) {
        if (mounted) {
          setState(() {
            _reports = reports;
            _isLoading = false;
          });
        }
      },
    );
  }

  List<ChecklistItem> _getCompletedEventsForDay(DateTime day) {
    final report = _reports.firstWhere(
      (r) => isSameDay(r.date, day),
      orElse: () => DailyReport(date: day, items: const []),
    );
    return report.items.where((i) => i.isCompleted).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.grayText),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Laporan Bulanan',
            style: GoogleFonts.poppins(
              color: AppColors.grayText,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            labelColor: AppColors.blueSoft,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.blueSoft,
            tabs: const [
              Tab(text: 'Kalender'),
              Tab(text: 'Statistik'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildCalendarView(), _buildStatisticsView()],
        ),
      ),
    );
  }

  Widget _buildStatisticsView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_reports.isEmpty) {
      return Center(
        child: Text(
          'Belum ada data untuk bulan ini',
          style: GoogleFonts.nunito(color: Colors.grey),
        ),
      );
    }

    final stats = <String, int>{};
    final colors = <String, Color>{};
    final icons = <String, IconData>{};

    // Calculate stats
    for (var report in _reports) {
      for (var item in report.items) {
        if (item.isCompleted) {
          stats[item.title] = (stats[item.title] ?? 0) + 1;
        }
        // Cache metadata for display
        if (!colors.containsKey(item.title)) {
          colors[item.title] = item.color;
          icons[item.title] = item.icon;
        }
      }
    }

    // Sort by count descending
    final sortedKeys = stats.keys.toList()
      ..sort((a, b) => (stats[b] ?? 0).compareTo(stats[a] ?? 0));

    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedDay.year,
      _focusedDay.month,
    );

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Rekapitulasi Aktivitas ${_focusedDay.month}/${_focusedDay.year}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.grayText,
          ),
        ),
        const SizedBox(height: 24),
        if (sortedKeys.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'Belum ada aktivitas yang selesai bulan ini',
                style: GoogleFonts.nunito(color: Colors.grey),
              ),
            ),
          )
        else
          ...sortedKeys.map((title) {
            final count = stats[title] ?? 0;
            final percentage = count / daysInMonth;
            final color = colors[title] ?? AppColors.blueSoft;
            final icon = icons[title] ?? Icons.circle;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: AppColors.grayText,
                          ),
                        ),
                      ),
                      Text(
                        '$count kali',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: color.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(percentage * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 16),
          child: TableCalendar(
            locale: 'id_ID',
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _fetchReports(focusedDay);
            },
            eventLoader: _getCompletedEventsForDay,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: AppColors.greenHealth,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.greenHealth.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.blueSoft,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildSelectedDayReport()),
      ],
    );
  }

  Widget _buildSelectedDayReport() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_selectedDay == null) {
      return Center(
        child: Text(
          'Pilih tanggal untuk melihat detail',
          style: GoogleFonts.nunito(color: Colors.grey),
        ),
      );
    }

    final selectedReport = _reports.firstWhere(
      (r) => isSameDay(r.date, _selectedDay),
      orElse: () => DailyReport(date: _selectedDay!, items: const []),
    );

    final completedItems = selectedReport.items
        .where((i) => i.isCompleted)
        .toList();

    if (completedItems.isEmpty) {
      // Check if it's future
      if (_selectedDay!.isAfter(DateTime.now())) {
        return Center(
          child: Text(
            'Hari belum dimulai',
            style: GoogleFonts.nunito(color: Colors.grey),
          ),
        );
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            Text(
              'Tidak ada aktivitas tercatat pada tanggal ini',
              style: GoogleFonts.nunito(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aktivitas Selesai',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayText,
                ),
              ),
              Text(
                DateFormat('d MMM yyyy', 'id_ID').format(_selectedDay!),
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blueSoft,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            itemCount: completedItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = completedItems[index];
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColors.grayText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.time,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (item.mouthCondition != null &&
                              item.mouthCondition!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Kondisi: ${item.mouthCondition}',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.greenHealth,
                      size: 28,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
