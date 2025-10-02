import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../../../models/date-model.dart';
import '../../../../res/colors/app-colors.dart';
import '../../../../res/utils/xutils.dart';
import '../../../../res/navigation_service/NavigatorService.dart';
import '../../../../res/utils/XElevatedButton.dart';
import 'edit-date-controller.dart';

class DateEditScreen extends StatelessWidget {
  final EditDateController controller = Get.put(EditDateController());
  DateModel? dateModel;

  DateEditScreen({super.key, this.dateModel});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result){
        if(didPop) {
          controller.disposeControllers();
          return;
        }
        controller.leaveScreen();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF7FAFC),
        appBar: AppBar(
          title: Text('Case Dates', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF1A365D)),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Color(0xFF1A365D)),
              onPressed: _showAddPreviousDateDialog,
            ),
          ],
        ),
        body: Obx(() => SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Upcoming Date Section
              if (controller.hasUpcomingDate) _buildUpcomingDateSection(),
              if (controller.hasUpcomingDate) SizedBox(height: 24),

              // Previous Dates Section
              _buildPreviousDatesSection(),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildUpcomingDateSection() {
    final dateModel = controller.dateModel.value;
    return Card(
      color: AppColors.foreground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HEARING',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A365D),
                  ),
                ),
                _buildStatusChip(dateModel.dateStatus),
              ],
            ),
            SizedBox(height: 16),

            _buildDateInfo(
              dateModel.upcomingDate!,
              dateModel.dateNotes,
            ),

            SizedBox(height: 16),
            _buildEditButton(
              onTap: () => _showEditUpcomingDateDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousDatesSection() {
    return Card(
      color: AppColors.foreground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PREVIOUS HEARINGS',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A365D),
                  ),
                ),
                Text(
                  '${controller.dateModel.value.prevDate.length} dates',
                  style: GoogleFonts.poppins(
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Obx(() => controller.hasPreviousDates
                ? _buildPreviousDatesList()
                : _buildEmptyState(
              'No previous dates',
              'Add previous hearing dates to track case progress',
              Icons.event_note_rounded,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousDatesList() {
    return Column(
      children: controller.sortedPreviousDates
          .asMap()
          .entries
          .map((entry) => _buildPreviousDateItem(entry.value, entry.key))
          .toList(),
    );
  }

  Widget _buildPreviousDateItem(PrevDateModel dateModel, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.formatDate(dateModel.date),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A365D),
                  ),
                ),
              ),
              _buildStatusChip(dateModel.dateStatus),
            ],
          ),
          SizedBox(height: 8),
          _buildDateStatusRow(dateModel.dateStatus, dateModel.date),
          if (dateModel.dateNotes != null && dateModel.dateNotes!.isNotEmpty) ...[
            SizedBox(height: 8),
            _buildDateNotes(dateModel.dateNotes!),
          ],
          SizedBox(height: 12),
          _buildEditButton(
            onTap: () => _showEditPreviousDateDialog(
              controller.dateModel.value.prevDate.indexOf(dateModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(DateTime date, String? notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF718096)),
            SizedBox(width: 8),
            Text(
              controller.formatDate(date),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A5568),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF718096)),
            SizedBox(width: 8),
            Text(
              controller.formatTime(date),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A5568),
              ),
            ),
          ],
        ),
        if (notes != null && notes.isNotEmpty) ...[
          SizedBox(height: 12),
          _buildDateNotes(notes),
        ],
      ],
    );
  }

  Widget _buildDateStatusRow(String status, DateTime date) {
    return Row(
      children: [
        Icon(
          controller.getStatusIcon(status),
          size: 16,
          color: controller.getStatusColor(status),
        ),
        SizedBox(width: 6),
        Text(
          status,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: controller.getStatusColor(status),
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Text(
          '${date.difference(DateTime.now()).inDays.abs()} days ago',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildDateNotes(String notes) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        notes,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Color(0xFF4A5568),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = controller.getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(controller.getStatusIcon(status), size: 14, color: color),
          SizedBox(width: 4),
          Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton({required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Color(0xFF1A365D).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, size: 14, color: Color(0xFF1A365D)),
            SizedBox(width: 4),
            Text(
              'Edit',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A365D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(icon, size: 60, color: Color(0xFFCBD5E0)),
          SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditUpcomingDateDialog() {
    var dateModel = controller.dateModel.value;
    var date = (dateModel.upcomingDate ?? DateTime.now());
    var status = dateModel.dateStatus;
    var notes = TextEditingController(text: dateModel.dateNotes);

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Container(
            height: Get.height * 0.7,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Edit Upcoming Date',
                  style: Get.textTheme.titleLarge?.copyWith(color: Color(0xFF1A365D)),
                ),
                SizedBox(height: 20),

                // Date Picker
                _buildDateField('Date', date, (newDate) => setState(()=>date = newDate)),
                SizedBox(height: 16),

                // Status Dropdown
                _buildStatusDropdown('Status', status, (newStatus) => status = newStatus),
                SizedBox(height: 16),

                // Notes
                TextField(
                  controller: notes,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),

                Spacer(),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: XElevatedButton(
                    onPressed: () {
                      controller.updateUpcomingDate(
                        date,
                        status,
                        notes.text.isEmpty ? null : notes.text,
                      );
                      Navigator.pop(context);
                      Get.snackbar(
                        'Success',
                        'Upcoming date updated successfully',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    label: 'Update',
                  ),
                ),
              ],
            ),
          );
        }
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDateField(String label, DateTime currentDate, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(controller.formatDate(currentDate)),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () async {
              final pickedDate = await XUtils().selectDate(currentDate);
              if (pickedDate != null) {
                onDateSelected(pickedDate);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(String label, String currentStatus, Function(String) onStatusChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: AppColors.foreground,
            initialValue: currentStatus,
            items: controller.dateStatus.all.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              );
            }).toList(),
            onChanged: (newValue) => onStatusChanged(newValue!),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddPreviousDateDialog() {
    final newDate = PrevDateModel(
      date: DateTime.now(),
      dateStatus: controller.dateStatus.upcoming,
      dateNotes: "",
    );

    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _buildAddDateForm(newDate, isNew: true),
      ),
      isScrollControlled: true,
    );
  }

  void _showEditPreviousDateDialog(int index) {
    final dateToEdit = controller.dateModel.value.prevDate[index];
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _buildAddDateForm(dateToEdit, isNew: false, index: index),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildAddDateForm(PrevDateModel dateModel, {bool isNew = true, int? index}) {
    final date = dateModel.date.obs;
    final status = dateModel.dateStatus.obs;
    final notes = TextEditingController(text: dateModel.dateNotes);

    return Column(
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          isNew ? 'Add Previous Date' : 'Edit Date',
          style: Get.textTheme.titleLarge?.copyWith(color: Color(0xFF1A365D)),
        ),
        SizedBox(height: 20),

        // Date Picker
        _buildDateField('Date', date.value, (newDate) => date.value = newDate),
        SizedBox(height: 16),

        // Status Dropdown
        _buildStatusDropdown('Status', status.value, (newStatus) => status.value = newStatus),
        SizedBox(height: 16),

        // Notes
        TextField(
          controller: notes,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Notes',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),

        Spacer(),

        // Action Buttons
        Row(
          children: [
            if (!isNew) // Delete Button...
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    NavigatorService.pop();
                    controller.deletePreviousDate(index!);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                  ),
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ),
            if (!isNew) SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final updatedDate = PrevDateModel(
                    date: date.value,
                    dateStatus: status.value,
                    dateNotes: notes.text.isEmpty ? null : notes.text,
                  );
                  if (isNew) {
                    controller.addPreviousDate(updatedDate);
                  } else {
                    controller.updatePreviousDate(index!, updatedDate);
                  }
                  NavigatorService.pop();
                  Get.snackbar(
                    'Success',
                    isNew ? 'Date added successfully' : 'Date updated successfully',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBg,
                  foregroundColor: AppColors.buttonForeground,
                ),
                child: Text(isNew ? 'Add Date' : 'Update'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildDateField(String label, DateTime currentDate, Function(DateTime) onDateSelected) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
  //       SizedBox(height: 8),
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.grey),
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: ListTile(
  //           leading: Icon(Icons.calendar_today),
  //           title: Text(controller.formatDate(currentDate)),
  //           trailing: Icon(Icons.arrow_drop_down),
  //           onTap: () async {
  //             final pickedDate = await XUtils().selectDate();
  //             if (pickedDate != null) {
  //               onDateSelected()pickedDate;
  //             }
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildStatusDropdown(String label, String currentStatus, Function(String) onStatusChanged) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
  //       SizedBox(height: 8),
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.grey),
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: DropdownButtonFormField<String>(
  //           initialValue: currentStatus,
  //           dropdownColor: Colors.white,
  //           items: controller.dateStatus.all.map((String status) {
  //             return DropdownMenuItem<String>(
  //               value: status,
  //               child: Text(status.capitalizeFirst.toString()),
  //             );
  //           }).toList(),
  //           onChanged: (newValue) => onStatusChanged(newValue!),
  //           decoration: InputDecoration(
  //             border: InputBorder.none,
  //             contentPadding: EdgeInsets.symmetric(horizontal: 16),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}