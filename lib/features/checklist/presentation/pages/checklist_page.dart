import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection/injection_container.dart';
import '../../domain/entities/checklist_item.dart';
import '../bloc/checklist_bloc.dart';
import 'checklist_detail_page.dart';
import 'monthly_report_page.dart'; // New page
import 'checklist_table_page.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChecklistBloc>()..add(LoadChecklist(DateTime.now())),
      child: const ChecklistView(),
    );
  }
}

class ChecklistView extends StatefulWidget {
  const ChecklistView({super.key});

  @override
  State<ChecklistView> createState() => _ChecklistViewState();
}

class _ChecklistViewState extends State<ChecklistView> {
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime _focusedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: BlocBuilder<ChecklistBloc, ChecklistState>(
          builder: (context, state) {
            DateTime startDate = DateTime(2024, 1, 1); // Default fallback
            if (state is ChecklistLoaded) {
              startDate = state.startDate;
            }

            // Normalize dates to midnight to avoid time issues
            final now = DateTime.now();
            final normalizedStart = DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            );
            // Use a safe past date for firstDay to avoid crashes if focusedDay < startDate
            // We will use enabledDayPredicate to restrict selection instead
            final safeFirstDay = DateTime(2020, 1, 1);
            final normalizedLast = DateTime(
              now.year + 1,
              now.month,
              now.day,
            ); // 1 year ahead

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jadwal Harian',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grayText,
                            ),
                          ),
                          Text(
                            DateFormat(
                              'MMMM yyyy',
                              'id_ID',
                            ).format(_focusedDay),
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.table_chart_outlined,
                              color: AppColors.greenHealth,
                              size: 28,
                            ),
                            onPressed: () {
                              // Navigate to Table View
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChecklistTablePage(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.calendar_month,
                              color: AppColors.greenHealth,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MonthlyReportPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Calendar Strip
                TableCalendar(
                  locale: 'id_ID',
                  firstDay: safeFirstDay,
                  lastDay: normalizedLast,
                  focusedDay: _focusedDay,
                  currentDay: DateTime.now(),
                  calendarFormat: CalendarFormat.week,
                  headerVisible: false,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  enabledDayPredicate: (day) {
                    // Disable days before the install date (startDate)
                    return !day.isBefore(normalizedStart);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDate, selectedDay)) {
                      setState(() {
                        _selectedDate = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      context.read<ChecklistBloc>().add(
                        LoadChecklist(selectedDay),
                      );
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: AppColors.greenHealth,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.greenHealth.withOpacity(0.5),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    weekendDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    outsideDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: GoogleFonts.nunito(color: Colors.grey),
                    weekendStyle: GoogleFonts.nunito(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 24),

                // Timeline / Task List
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Builder(
                      builder: (context) {
                        if (state is ChecklistLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is ChecklistLoaded) {
                          if (state.items.isEmpty) {
                            return Center(
                              child: Text(
                                'Tidak ada jadwal untuk hari ini.',
                                style: GoogleFonts.nunito(color: Colors.grey),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              final item = state.items[index];
                              return _TimelineItem(
                                item: item,
                                date: _selectedDate,
                                onUpdate: (value, mouthCondition, notes) {
                                  context.read<ChecklistBloc>().add(
                                    ToggleItem(
                                      itemId: item.id,
                                      date: _selectedDate,
                                      isCompleted: value,
                                      mouthCondition: mouthCondition,
                                      notes: notes,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else if (state is ChecklistError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ChecklistItem item;
  final DateTime date;
  final Function(bool, String?, String?) onUpdate;

  const _TimelineItem({
    required this.item,
    required this.date,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column
          SizedBox(
            width: 50,
            child: Text(
              item.time,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          // Timeline Line
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: item.isCompleted
                      ? AppColors.greenHealth
                      : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              Container(width: 2, height: 60, color: Colors.grey.shade100),
            ],
          ),
          const SizedBox(width: 16),
          // Card
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChecklistDetailPage(
                      item: item,
                      date: date,
                      onConfirm: (mouthCondition, notes) =>
                          onUpdate(true, mouthCondition, notes),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: item.isCompleted
                        ? AppColors.greenHealth.withOpacity(0.5)
                        : Colors.grey.shade100,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
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
                      child: Icon(item.icon, color: item.color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: item.isCompleted
                                  ? AppColors.grayText.withOpacity(0.5)
                                  : AppColors.grayText,
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.greenHealth,
                        size: 20,
                      )
                    else
                      Icon(
                        Icons.circle_outlined,
                        color: Colors.grey.shade300,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
