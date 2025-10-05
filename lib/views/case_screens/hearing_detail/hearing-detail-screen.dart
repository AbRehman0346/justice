import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/models/date-model.dart';
import 'package:justice/res/utils/xutils.dart';
import '../../../models/case-model.dart';
import 'show_hearing_controller.dart';

class HearingDetailScreen extends StatelessWidget {
  CaseModel kase;
  HearingDetailScreen({super.key, required this.kase});

  late HearingDateController controller;

  _init(){
    controller = Get.put(HearingDateController(kase));
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

          XUtils.height(20),

          // Search Bar
          _buildSearchBar(),

          // Dates List
          _buildDatesList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: Get.statusBarHeight,
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
                'Case Dates',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'All Case Hearings Will Appear Here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
        child: TextField(
          onChanged: controller.searchDates,
          decoration: InputDecoration(
            hintText: 'Search cases...',
            hintStyle: GoogleFonts.poppins(color: Color(0xFFA0AEC0)),
            prefixIcon: Icon(Icons.search, color: Color(0xFF4A5568)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildDatesList() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.displayedCases.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshDates(),
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.displayedCases.length,
            itemBuilder: (context, index) {
              final caseItem = controller.displayedCases[index];
              return _buildDateCard(caseItem);
            },
          ),
        );
      }),
    );
  }

  Widget _buildDateCard(CaseModel caseItem) {
    final date = caseItem.date!;
    final DateTime? displayDate = date.dateStatus == DateStatus().upcoming
        ? date.upcomingDate
        : date.prevDate.first.date;

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
          onTap: () => controller.viewCaseDetails(caseItem),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Case Info and Priority
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Badge
                    _buildDateBadge(displayDate),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            caseItem.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A365D),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${caseItem.court} • ${caseItem.city}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildPriorityIndicator(caseItem.priority),
                  ],
                ),

                SizedBox(height: 12),

                // Case Details
                _buildCaseDetailRow(
                  icon: Icons.assignment_rounded,
                  text: caseItem.caseNumber ?? 'No Case Number',
                ),

                _buildCaseDetailRow(
                  icon: Icons.work_outline_rounded,
                  text: '${caseItem.caseType ?? "N/A"} • ${caseItem.caseStage}',
                ),

                SizedBox(height: 8),

                // Date Status and Notes
                _buildDateStatusSection(date),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateBadge(DateTime? date) {
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
            date == null ? 'N/A' :
            controller.getDayName(date.weekday).toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            date == null ? '--' :
            date.day.toString(),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            date == null ? '----' :
            controller.getMonthName(date.month),
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Text(
        priority.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildCaseDetailRow({required IconData icon, required String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Color(0xFF718096)),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateStatusSection(DateModel date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status and Time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusChip(date.dateStatus),
            Text(
              controller.formatTime((date.dateStatus == DateStatus().upcoming
                  ? date.upcomingDate
                  : date.prevDate.first.date) ?? DateTime.now()),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A365D),
              ),
            ),
          ],
        ),

        // Date Notes (if any)
        if (date.dateNotes != null && date.dateNotes!.isNotEmpty) ...[
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFEDF2F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.note_rounded, size: 16, color: Color(0xFF1A365D)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date.dateNotes!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(0xFF4A5568),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Days Difference
        SizedBox(height: 8),
        Text(
          controller.getDaysDifference((date.dateStatus == DateStatus().upcoming
              ? date.upcomingDate
              : date.prevDate.first.date) ?? DateTime.now()),
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Color(0xFF718096),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final color = controller.getDateStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        controller.getDateStatusText(status),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 80,
            color: Color(0xFFCBD5E0),
          ),
          SizedBox(height: 16),
          Text('No previous dates',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          Text(
            'All case hearings will appear here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }
}