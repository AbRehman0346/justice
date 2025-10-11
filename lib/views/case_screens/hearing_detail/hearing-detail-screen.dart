import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/models/case-model.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'package:justice/res/extensions/datetime-extensions.dart';
import '../add_hearing_dialog/add_hearing_dialog.dart';
import 'show_hearing_controller.dart';
import '../../../models/date-model.dart';

class CaseHearingsScreen extends StatelessWidget {
  CaseModel kase;
  CaseHearingsScreen({required this.kase});

  late CaseHearingsController controller;

  _init(){
    controller = Get.put(CaseHearingsController(kase));
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      body: Column(
        children: [
          // Header
          _buildHeader(),

          // Tab Bar
          _buildTabBar(),

          // Content
          _buildContent(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 50,
        left: 24,
        right: 24,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A365D),
            Color(0xFF2D3748),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Case Hearings',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Obx(() => Text(
                controller.selectedTab.value == 0
                    ? 'Upcoming'
                    : '${controller.previousHearings.length} Previous',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              )),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Track all hearing dates and status',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 16),
          // Case Info Card
          _buildCaseInfoCard(),
        ],
      ),
    );
  }

  Widget _buildCaseInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.gavel_rounded, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.kase.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '${controller.kase.caseNumber ?? "-----"} • ${controller.kase.court ?? "-----"}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabButton('Upcoming', 0),
          _buildTabButton('Previous', 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    return Obx(() => Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.setTab(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: controller.selectedTab.value == index
                  ? Color(0xFF1A365D)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: controller.selectedTab.value == index
                      ? Colors.white
                      : Color(0xFF4A5568),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildContent() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshHearings(),
          child: controller.selectedTab.value == 0
              ? _buildUpcomingHearing()
              : _buildPreviousHearings(),
        );
      }),
    );
  }

  Widget _buildUpcomingHearing() {
    if (controller.upcomingHearing == null) {
      return _buildEmptyState(
        'No Upcoming Hearing',
        Icons.calendar_today_rounded,
        'No upcoming hearing scheduled for this case',
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Upcoming Hearing Card
          _buildUpcomingHearingCard(),
          SizedBox(height: 20),

          // Last Hearing Summary
          if (controller.hearings?.lastDate != null)
            _buildLastHearingSummary(),
        ],
      ),
    );
  }

  Widget _buildUpcomingHearingCard() {
    final upcoming = controller.upcomingHearing!;

    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Next Hearing',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A365D),
                  ),
                ),
                _buildStatusChip(controller.hearings?.dateStatus ?? ""),
              ],
            ),

            SizedBox(height: 16),

            // Date and Time
            _buildDateTimeSection(upcoming),

            SizedBox(height: 16),

            // Notes
            if (controller.hearings?.dateNotes != null && controller.hearings!.dateNotes!.isNotEmpty)
              _buildNotesSection(controller.hearings!.dateNotes!),

            SizedBox(height: 16),

            // Days Countdown
            _buildCountdownSection(upcoming),
          ],
        ),
      ),
    );
  }

  Widget _buildLastHearingSummary() {
    final lastHearing = controller.hearings?.lastDate!;

    if(lastHearing == null){
      return _buildEmptyState(
        'No Last Hearing',
        Icons.history_rounded,
        'No last hearing records found for this case',
      );
    }

    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Hearing Summary',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A365D),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildDateBadge(lastHearing.date),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.formatDate(lastHearing.date),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: 4),
                      _buildStatusChip(lastHearing.dateStatus),
                      if (lastHearing.dateNotes != null && lastHearing.dateNotes!.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Text(
                          lastHearing.dateNotes!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Color(0xFF718096),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousHearings() {
    if (controller.previousHearings.isEmpty) {
      return _buildEmptyState(
        'No Previous Hearings',
        Icons.history_rounded,
        'No previous hearing records found for this case',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: controller.previousHearings.length,
      itemBuilder: (context, index) {
        final hearing = controller.previousHearings[index];
        return _buildPreviousHearingCard(hearing, index);
      },
    );
  }

  Widget _buildPreviousHearingCard(PrevHearingDateModel hearing, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.editHearing(hearing),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Badge
                _buildDateBadge(hearing.date),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Hearing Number and Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hearing ${controller.previousHearings.length - index}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A365D),
                            ),
                          ),
                          _buildStatusChip(hearing.dateStatus),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Date and Time
                      Text(
                        controller.formatDate(hearing.date),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xFF4A5568),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${hearing.date.formatTime} • ${hearing.date.dayDifferenceString(DateTime.now())}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                      // Notes
                      if (hearing.dateNotes != null && hearing.dateNotes!.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFEDF2F7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            hearing.dateNotes!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0xFF4A5568),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateBadge(DateTime date) {
    return Container(
      width: 60,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF1A365D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            date.shortDayName.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            date.day.toString(),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            date.shortMonthName,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection(DateTime date) {
    return Row(
      children: [
        Icon(Icons.calendar_today_rounded, color: Color(0xFF1A365D), size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.formatDate(date),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${date.formatTime} • ${date.dayDifferenceString(DateTime.now())}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes:',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 8),
        Container(
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
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownSection(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    final days = difference.inDays;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE8F4FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFBEE3F8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Days Remaining',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xFF4A5568),
                ),
              ),
              Text(
                days.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A365D),
                ),
              ),
            ],
          ),
          Icon(
            Icons.access_time_rounded,
            size: 40,
            color: Color(0xFF1A365D).withOpacity(0.5),
          ),
        ],
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
      child: Text(
        controller.getStatusLabel(status),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Color(0xFFCBD5E0),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: showAddUpcomingHearingDialog, // Updated
      backgroundColor: Color(0xFF1A365D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  void showAddUpcomingHearingDialog() {
    Get.dialog(
      AddUpcomingHearingDialog(
        currentUpcomingDate: controller.upcomingHearing,
        onUpcomingHearingUpdated: (previousHearing, newUpcomingDate, notes) {
          // Handle the date transition logic here
          // previousHearing will be null if there was no current upcoming date

          if (previousHearing != null) {
            // Add the current upcoming date to previous dates list
            controller.kase.date?.prevDate.add(previousHearing);
          }

          // Set the new upcoming date
          controller.kase.date?.upcomingDate = newUpcomingDate;
          controller.kase.date?.dateStatus = HearingStatus().upcoming;
          controller.kase.date?.dateNotes = notes;

          // Update the UI
          // update();

          Get.snackbar(
            'Success',
            'New hearing scheduled successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      ),
      barrierDismissible: false,
    );
  }
}