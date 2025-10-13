import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'package:justice/res/extensions/datetime-extensions.dart';
import '../../../models/date-model.dart';

class AddUpcomingHearingDialog extends StatefulWidget {
  final DateTime? currentUpcomingDate;
  final Function(PrevHearingDateModel? previousHearing, DateTime newUpcomingDate, String? notes)? onUpcomingHearingUpdated;

  const AddUpcomingHearingDialog({
    Key? key,
    this.currentUpcomingDate,
    this.onUpcomingHearingUpdated,
  }) : super(key: key);

  @override
  _AddUpcomingHearingDialogState createState() => _AddUpcomingHearingDialogState();
}

class _AddUpcomingHearingDialogState extends State<AddUpcomingHearingDialog> {
  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now().add(Duration(days: 7));
  TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 0);
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial date to next week or after current upcoming date
    if (widget.currentUpcomingDate != null &&
        widget.currentUpcomingDate!.isAfter(DateTime.now())) {
      _selectedDate = widget.currentUpcomingDate!.add(Duration(days: 7));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgSurface,
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              SizedBox(height: 24),

              // Current Upcoming Date Info (if exists)
              if (widget.currentUpcomingDate != null)
                _buildCurrentDateInfo(),
              if (widget.currentUpcomingDate != null)
                SizedBox(height: 20),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Date Picker
                    _buildDateField(),
                    SizedBox(height: 16),

                    // Time Picker
                    _buildTimeField(),
                    SizedBox(height: 16),

                    // Notes
                    _buildNotesField(),
                    SizedBox(height: 24),

                    // Buttons
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule New Hearing',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A365D),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Set next upcoming hearing date',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentDateInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE8F4FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFBEE3F8)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF1A365D), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Upcoming Hearing',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A365D),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatDate(widget.currentUpcomingDate!),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Color(0xFF4A5568),
                  ),
                ),
                Text(
                  'This will be moved to previous hearings',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Color(0xFF718096),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'New Hearing Date',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: ListTile(
            leading: Icon(Icons.calendar_today_rounded, color: Color(0xFF1A365D)),
            title: Text(
              _formatDate(_selectedDate),
              style: GoogleFonts.poppins(),
            ),
            trailing: Icon(Icons.arrow_drop_down, color: Color(0xFF4A5568)),
            onTap: _selectDate,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Hearing Time',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: ListTile(
            leading: Icon(Icons.access_time_rounded, color: Color(0xFF1A365D)),
            title: Text(
              _selectedTime.format(context),
              style: GoogleFonts.poppins(),
            ),
            trailing: Icon(Icons.arrow_drop_down, color: Color(0xFF4A5568)),
            onTap: _selectTime,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hearing Notes (Optional)',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add notes for the new hearing...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Color(0xFF4A5568),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveUpcomingHearing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1A365D),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Schedule',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1A365D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1A365D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveUpcomingHearing() {
    if (_formKey.currentState!.validate()) {
      final newUpcomingDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Create previous hearing from current upcoming date (if exists)
      PrevHearingDateModel? previousHearing;
      if (widget.currentUpcomingDate != null) {
        previousHearing = PrevHearingDateModel(
          date: widget.currentUpcomingDate!,
          dateStatus: 'scheduled', // You can change this as needed
          dateNotes: 'Rescheduled to new date',
        );
      }

      if (widget.onUpcomingHearingUpdated != null) {
        widget.onUpcomingHearingUpdated!(
          previousHearing,
          newUpcomingDateTime,
          _notesController.text.isEmpty ? null : _notesController.text,
        );
      }

      Get.back();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == tomorrow) return 'Tomorrow';

    return '${date.shortDayName}, ${date.day} ${date.shortMonthName} ${date.year}';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}