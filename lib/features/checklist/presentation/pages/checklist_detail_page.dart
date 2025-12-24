import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/checklist_item.dart';

class ChecklistDetailPage extends StatefulWidget {
  final ChecklistItem item;
  final DateTime date;
  final Function(String mouthCondition, String notes) onConfirm;

  const ChecklistDetailPage({
    super.key,
    required this.item,
    required this.date,
    required this.onConfirm,
  });

  @override
  State<ChecklistDetailPage> createState() => _ChecklistDetailPageState();
}

class _ChecklistDetailPageState extends State<ChecklistDetailPage> {
  String? _selectedCondition;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _conditions = [
    'Bersih',
    'Sedikit Plak',
    'Banyak Plak',
    'Sariawan/Luka',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.item.isCompleted) {
      _selectedCondition = widget.item.mouthCondition;
      _notesController.text = widget.item.notes ?? '';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  // Returns 0 if within window, -1 if before, 1 if after
  int _checkTimeWindow(String timeStr) {
    final now = TimeOfDay.now();
    final parts = timeStr.split(':');
    final startHour = int.parse(parts[0]);
    final startMinute = int.parse(parts[1]);

    // Window is 3 hours: [start, start + 3h]
    // Convert everything to minutes for easier comparison
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = startMinutes + (4 * 60); // 3 hours window

    if (nowMinutes < startMinutes) return -1; // Before window
    if (nowMinutes > endMinutes) return 1; // After window
    return 0; // Within window
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final normalizedDate = _normalizeDate(widget.date);
    final normalizedNow = _normalizeDate(now);

    final isFutureDate = normalizedDate.isAfter(normalizedNow);
    final isPastDate = normalizedDate.isBefore(normalizedNow);

    final timeWindowStatus = _checkTimeWindow(widget.item.time);

    // Status Logic
    bool canComplete = false;
    String statusText = '';
    Color statusColor = Colors.grey;

    if (widget.item.isCompleted) {
      statusText = 'Tugas Selesai';
      statusColor = AppColors.greenHealth;
    } else if (isFutureDate) {
      statusText = 'Belum Waktunya';
      statusColor = Colors.grey;
    } else if (isPastDate) {
      statusText = 'Terlewat';
      statusColor = Colors.red;
    } else {
      // Today
      if (timeWindowStatus == -1) {
        // Before window
        statusText = 'Belum Waktunya';
        statusColor = Colors.grey;
      } else if (timeWindowStatus == 1) {
        // After window
        statusText = 'Terlewat';
        statusColor = Colors.red;
      } else {
        // Within window
        canComplete = true;
      }
    }

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
          'Detail Tugas',
          style: GoogleFonts.poppins(
            color: AppColors.grayText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon and Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.item.icon,
                    color: widget.item.color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grayText,
                        ),
                      ),
                      Text(
                        widget.item.time,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Instructions Section
            Text(
              'Instruksi',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.grayText,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                widget.item.description,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: AppColors.grayText,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Mouth Condition Section
            if (canComplete || widget.item.isCompleted) ...[
              Text(
                'Kondisi Mulut',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayText,
                ),
              ),
              const SizedBox(height: 16),
              ..._conditions.map(
                (condition) => RadioListTile<String>(
                  title: Text(
                    condition,
                    style: GoogleFonts.nunito(color: AppColors.grayText),
                  ),
                  value: condition,
                  groupValue: _selectedCondition,
                  activeColor: AppColors.greenHealth,
                  onChanged: widget.item.isCompleted
                      ? null
                      : (value) {
                          setState(() {
                            _selectedCondition = value;
                          });
                        },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 24),

              // Notes Section
              Text(
                'Keterangan (Opsional)',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayText,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                enabled: !widget.item.isCompleted,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tambahkan catatan jika ada...',
                  hintStyle: GoogleFonts.nunito(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.greenHealth),
                  ),
                  filled: true,
                  fillColor: widget.item.isCompleted
                      ? Colors.grey.shade100
                      : Colors.white,
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Confirmation Button
            if (canComplete)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedCondition == null
                      ? null
                      : () {
                          widget.onConfirm(
                            _selectedCondition!,
                            _notesController.text,
                          );
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenHealth,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Konfirmasi Selesai',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: statusColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.item.isCompleted
                          ? Icons.check_circle
                          : Icons.info_outline,
                      color: statusColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      statusText,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
