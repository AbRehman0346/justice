import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/res/xwidgets/xtext.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/case-model.dart';
import 'calender-controller.dart';

class CalendarScreen extends StatelessWidget {
  final CalendarController controller = Get.put(CalendarController());

  CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      body: Column(
        children: [
          // Header
          _buildHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Calendar
                  _buildCalendar(),

                  // Cases List Header
                  _buildCasesHeader(),

                  // Cases List
                  _buildCasesList(),
                ],
              ),
            ),
          ),
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
                'Case Calendar',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${controller.allCases.length} Total Cases',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Manage your case schedule efficiently',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(() => TableCalendar(
          availableGestures: AvailableGestures.horizontalSwipe,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: controller.focusedDay.value,
          selectedDayPredicate: (day) => isSameDay(day, controller.selectedDay.value),
          onDaySelected: controller.onDaySelected,
          onFormatChanged: controller.onFormatChanged,
          onPageChanged: controller.onPageChanged,
          calendarFormat: controller.calendarFormat.value,
          eventLoader: controller.getEventsForDay,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Color(0xFF1A365D).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Color(0xFF1A365D),
              shape: BoxShape.circle,
            ),
            markersAlignment: Alignment.bottomCenter,
            markersAutoAligned: false,
            markerSize: 6,
            markerDecoration: BoxDecoration(
              color: Color(0xFFF56565),
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              border: Border.all(color: Color(0xFF1A365D)),
              borderRadius: BorderRadius.circular(8),
            ),
            formatButtonTextStyle: GoogleFonts.poppins(color: Color(0xFF1A365D)),
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A365D),
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: GoogleFonts.poppins(color: Color(0xFF4A5568)),
            weekendStyle: GoogleFonts.poppins(color: Color(0xFFF56565)),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final eventCount = controller.getEventCountForDay(date);
              if (eventCount > 0) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: _buildEventBadge(eventCount),
                );
              }
              return SizedBox.shrink();
            },
          ),
        )),
      ),
    );
  }

  Widget _buildEventBadge(int count) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Color(0xFFF56565),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: GoogleFonts.poppins(
            fontSize: 8,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCasesHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.getSelectedDayHeader(),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A365D),
            ),
          ),
          Text(
            '${controller.selectedEvents.length} cases',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildCasesList() {
    return Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.selectedEvents.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshData(),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 60),
            itemCount: controller.selectedEvents.length,
            itemBuilder: (context, index) {
              final caseItem = controller.selectedEvents[index];
              return _buildCaseCard(caseItem);
            },
          ),
        );
      });
  }

  Widget _buildCaseCard(CaseModel caseItem) {
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
          onTap: () {
            NavigatorService().gotoCaseDetails(kase: caseItem);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Case Header with Priority
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        caseItem.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A365D),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildPriorityIndicator(caseItem.priority),
                  ],
                ),

                SizedBox(height: 12),

                // Case Details
                _buildCaseDetailRow(
                  icon: Icons.account_balance_rounded,
                  text: caseItem.court,
                ),

                _buildCaseDetailRow(
                  icon: Icons.assignment_rounded,
                  text: '${caseItem.caseType} • ${caseItem.caseStage}',
                ),

                // _buildCaseDetailRow(
                //   icon: Icons.schedule_rounded,
                //   text: caseItem.date == null ? "" : '${caseItem.date!.upcomingDate == null ? "" : _formatTime(caseItem.date!.upcomingDate!)} • ${caseItem.date!.dateStatus.capitalizeFirst}',
                //   textColor: _getStatusColor(caseItem.date?.dateStatus),
                // ),

                SizedBox(height: 8),

                // Hearing Time
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //   decoration: BoxDecoration(
                //     color: Color(0xFF1A365D).withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF1A365D)),
                //       SizedBox(width: 4),
                //       Text(
                //         caseItem.date == null || caseItem.date!.upcomingDate == null ? "" :
                //         'Hearing at ${_formatTime(caseItem.date!.upcomingDate!)}',
                //         style: GoogleFonts.poppins(
                //           fontSize: 12,
                //           color: Color(0xFF1A365D),
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    final color = controller.getPriorityColor(priority);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        priority.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCaseDetailRow({required IconData icon, required String text, Color? textColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Color(0xFF718096)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: textColor ?? Color(0xFF4A5568),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'attended':
        return Color(0xFF48BB78);
      case 'adjourned':
        return Color(0xFFED8936);
      case 'missed':
        return Color(0xFFF56565);
      default:
        return Color(0xFF718096);
    }
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.event_note_rounded,
            //   size: 60,
            //   color: Color(0xFFCBD5E0),
            // ),
            SizedBox(height: 10),
            Text(
              'No cases scheduled',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF718096),
              ),
            ),
            Text(
              'Select another date to view cases',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Color(0xFFA0AEC0),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: FloatingActionButton(
        onPressed: () {
          NavigatorService().gotoAddCase();
        },
        backgroundColor: Color(0xFF1A365D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}