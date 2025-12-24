import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection/injection_container.dart';
import '../../domain/entities/daily_report.dart';
import '../../domain/repositories/checklist_repository.dart';

class ChecklistTablePage extends StatefulWidget {
  const ChecklistTablePage({super.key});

  @override
  State<ChecklistTablePage> createState() => _ChecklistTablePageState();
}

class _ChecklistTablePageState extends State<ChecklistTablePage> {
  DateTime _currentMonth = DateTime.now();
  late Future<List<DailyReport>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    _reportsFuture = sl<ChecklistRepository>()
        .getMonthlyReports(_currentMonth)
        .then((result) => result.fold((l) => [], (r) => r));
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + offset,
      );
      _loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.grayText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rekap Bulanan',
          style: GoogleFonts.poppins(
            color: AppColors.grayText,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.grayText),
            onPressed: () => _changeMonth(-1),
          ),
          Center(
            child: Text(
              DateFormat('MMMM yyyy', 'id_ID').format(_currentMonth),
              style: GoogleFonts.nunito(
                color: AppColors.grayText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.grayText),
            onPressed: () => _changeMonth(1),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<DailyReport>>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final reports = snapshot.data ?? [];
          if (reports.isEmpty) {
            return const Center(child: Text('Tidak ada data.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.blueSoft),
                headingTextStyle: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                dataRowColor: WidgetStateProperty.resolveWith((states) {
                  return Colors.white;
                }),
                border: TableBorder.all(color: Colors.grey.shade200),
                columns: const [
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Pagi')),
                  DataColumn(label: Text('Siang')),
                  DataColumn(label: Text('Malam')),
                  DataColumn(label: Text('Bersih')),
                  DataColumn(label: Text('Sedikit Plak')),
                  DataColumn(label: Text('Banyak Plak')),
                  DataColumn(label: Text('Sariawan/Luka')),
                  DataColumn(label: Text('Keterangan')),
                ],
                rows: reports.map((report) {
                  // Helper to check if any task has a specific condition
                  bool hasCondition(String condition) {
                    return report.items.any(
                      (item) =>
                          item.isCompleted && item.mouthCondition == condition,
                    );
                  }

                  // Helper to get notes
                  String getNotes() {
                    final notes = report.items
                        .where(
                          (item) =>
                              item.isCompleted &&
                              item.notes != null &&
                              item.notes!.isNotEmpty,
                        )
                        .map((item) => item.notes)
                        .join('; ');
                    return notes;
                  }

                  // Helper to check specific task completion
                  bool isTaskDone(String taskId) {
                    return report.items.any(
                      (item) => item.id == taskId && item.isCompleted,
                    );
                  }

                  return DataRow(
                    cells: [
                      DataCell(Text(DateFormat('dd/MM').format(report.date))),
                      DataCell(_CheckCell(isDone: isTaskDone('morning_care'))),
                      DataCell(
                        _CheckCell(isDone: isTaskDone('afternoon_care')),
                      ),
                      DataCell(_CheckCell(isDone: isTaskDone('night_care'))),
                      DataCell(_CheckCell(isDone: hasCondition('Bersih'))),
                      DataCell(
                        _CheckCell(isDone: hasCondition('Sedikit Plak')),
                      ),
                      DataCell(_CheckCell(isDone: hasCondition('Banyak Plak'))),
                      DataCell(
                        _CheckCell(isDone: hasCondition('Sariawan/Luka')),
                      ),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(
                            getNotes(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.nunito(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CheckCell extends StatelessWidget {
  final bool isDone;

  const _CheckCell({required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isDone
          ? const Icon(Icons.check, color: AppColors.greenHealth, size: 20)
          : const SizedBox(),
    );
  }
}
