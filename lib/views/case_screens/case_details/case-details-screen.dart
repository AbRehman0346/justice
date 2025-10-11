import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/models/case-model.dart';
import 'package:justice/models/date-model.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'package:justice/res/utils/XElevatedButton.dart';
import 'package:justice/res/utils/xutils.dart';
import '../../../models/contact-model.dart';
import '../case_details/case-details-controller.dart';

class CaseDetailsScreen extends StatelessWidget {
  final CaseModel kase;
  CaseDetailsScreen({super.key, required this.kase});
  late CaseDetailsController controller;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(CaseDetailsController(kase));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if(didPop) return;
        await controller.leaveScreen();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF7FAFC),
        body: Obx(() => CustomScrollView(
          slivers: [
            // App Bar with Case Title
            _buildAppBar(),

            // Case Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Case Status and Priority
                    _buildStatusPrioritySection(),
                    SizedBox(height: 20),

                    // Case Information
                    _buildCaseInformationSection(),
                    SizedBox(height: 20),

                    // Hearing Dates
                    _buildHearingDatesSection(),

                    SizedBox(height: 20),

                    // Proceedings Details
                    _buildProceedingsSection(),
                    SizedBox(height: 20),

                    // Clients Section
                    if (controller.caseModel.value.clientIds != null &&
                        controller.caseModel.value.clientIds!.isNotEmpty)
                      _buildClientsSection(),
                    if (controller.caseModel.value.clientIds != null &&
                        controller.caseModel.value.clientIds!.isNotEmpty)
                      SizedBox(height: 20),

                    // Linked Cases
                    if (controller.caseModel.value.linkedCaseId != null &&
                        controller.caseModel.value.linkedCaseId!.isNotEmpty)
                      _buildLinkedCasesSection(),
                    if (controller.caseModel.value.linkedCaseId != null &&
                        controller.caseModel.value.linkedCaseId!.isNotEmpty)
                      SizedBox(height: 20),

                    // Case Metadata
                    _buildMetadataSection(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        )),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Color(0xFF1A365D),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: controller.leaveScreen,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: Colors.white),
          onPressed: controller.editCase,
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () {
            Get.snackbar('Share', 'Share functionality coming soon');
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Case Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A365D),
                Color(0xFF2D3748),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.gavel_rounded,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPrioritySection() {
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
              controller.caseModel.value.title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A365D),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildStatusChip(
                  'Status',
                  controller.caseModel.value.status.capitalizeFirst!,
                  controller.getStatusColor(controller.caseModel.value.status),
                ),
                SizedBox(width: 8),
                _buildStatusChip(
                  'Priority',
                  controller.caseModel.value.priority.capitalizeFirst!,
                  controller.getPriorityColor(controller.caseModel.value.priority),
                ),
              ],
            ),
            if (controller.caseModel.value.caseNumber != null) ...[
              SizedBox(height: 8),
              Text(
                'Case Number: ${controller.caseModel.value.caseNumber}',
                style: GoogleFonts.poppins(
                  color: Color(0xFF718096),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCaseInformationSection() {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Case Information'),
            SizedBox(height: 12),
            _buildInfoRow('Court', controller.caseModel.value.court),
            _buildInfoRow('Location', '${controller.caseModel.value.court}, ${controller.caseModel.value.city}'),
            _buildInfoRow('Case Type', controller.caseModel.value.caseType.toString()),
            _buildInfoRow('Case Stage', controller.caseModel.value.caseStage),
          ],
        ),
      ),
    );
  }

  Widget _buildHearingDatesSection() {
    if(controller.caseModel.value.date == null){
      return Text("NO Hearing Date Assigned Yet");
    }


    CaseHearingsDateModel date = controller.caseModel.value.date!;

    Widget getPrevHearing(){
      if(date.prevDate.isEmpty){
        return SizedBox();
      }

      return _buildDateCard(
        'Previous Hearing',
        date.prevDate.isEmpty ? "" : controller.formatDate(date.lastDate!.date),
        date.dateStatus,
        controller.getDateStatusColor(date.dateStatus),
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
            _buildSectionHeader('Hearing Dates'),
            SizedBox(height: 12),
            getPrevHearing(),
            SizedBox(height: 12),
            _buildDateCard(
              'Upcoming Hearing',
              date.upcomingDate == null ? "Not Assigned" : controller.formatDate(date.upcomingDate!),
              'scheduled',
              Color(0xFF4299E1),
            ),
            if (date.dateNotes != null) ...[
              SizedBox(height: 12),
              _buildNotesCard(date.dateNotes!),
            ],
            XUtils.height(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                XElevatedButton(label: "HEARINGS", onPressed: controller.gotoHearingDetails),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(String title, String date, String status, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded, color: Color(0xFF1A365D), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF718096))),
                Text(date, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status.capitalizeFirst!,
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(String notes) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.note_rounded, color: Color(0xFF1A365D), size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              notes,
              style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF4A5568)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedingsSection() {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Proceedings Details'),
              SizedBox(height: 12),
              Text(
                controller.caseModel.value.proceedingsDetails,
                style: GoogleFonts.poppins(
                  color: Color(0xFF4A5568),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientsSection() {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Clients'),
            SizedBox(height: 12),
            Column(
              children: controller.caseModel.value.clientIds!
                  .map((client) => _buildClientTile(client))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientTile(ContactModel client) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      leading: CircleAvatar(
        backgroundColor: Color(0xFF1A365D).withOpacity(0.1),
        child: Icon(Icons.person, color: Color(0xFF1A365D), size: 20),
      ),
      title: Text(client.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      subtitle: Text(client.type.capitalizeFirst!, style: GoogleFonts.poppins(fontSize: 12)),
      trailing: Icon(Icons.phone, color: Color(0xFF1A365D), size: 18),
      onTap: () => controller.viewClientDetails(client),
    );
  }

  Widget _buildLinkedCasesSection() {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Linked Cases'),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
              controller.caseModel.value.linkedCaseId == null ||
              controller.caseModel.value.linkedCaseId!.isEmpty  ?
              [Text("No Linked Cases")] :
              controller.caseModel.value.linkedCaseId!
                  .map((caseId) => _buildLinkedCaseChip(caseId))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedCaseChip(String caseId) {
    return GestureDetector(
      onTap: () {
        Get.snackbar('Linked Case', 'Viewing $caseId');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Color(0xFFE8F4FD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFBEE3F8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link, size: 12, color: Color(0xFF1A365D)),
            SizedBox(width: 4),
            Text(caseId, style: GoogleFonts.poppins(fontSize: 12, color: Color(0xFF1A365D))),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataSection() {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Case Metadata'),
            SizedBox(height: 12),
            _buildInfoRow('Case ID', controller.caseModel.value.id),
            _buildInfoRow('Created', controller.formatDate(controller.caseModel.value.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A365D),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: Color(0xFF718096)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: controller.addNote,
      backgroundColor: Color(0xFF1A365D),
      child: Icon(Icons.note_add_rounded, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}