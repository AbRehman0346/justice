import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/temp_data/temp-data.dart';
import '../../../models/case-model.dart';
import '../../../models/contact-model.dart';
import '../../../models/date-model.dart';

class CaseDetailsController extends GetxController {
  late Rx<CaseModel> caseModel;

  CaseDetailsController(CaseModel caseModel){
    this.caseModel = caseModel.obs;
  }

  var isLoading = false.obs;

  Color getPriorityColor(String priority) {
    final p = CasePriority();
    if(priority == p.high) return Color(0xFFF56565);
    if(priority == p.medium) return Color(0xFFED8936);
    if(priority == p.low) return Color(0xFF48BB78);
    return Color(0xFFCBD5E0);
  }

  Color getStatusColor(String status) {
    final s = CaseStatus();
    if(status == s.active) return Color(0xFF48BB78);
    if(status == s.disposeOff) return Color(0xFF718096);
    return Color(0xFFCBD5E0);
  }

  Color getDateStatusColor(String status) {
    final s = DateStatus();

    if(status == s.attended) return Color(0xFF48BB78);
    if(status == s.adjourned) return Color(0xFFED8936);
    if(status == s.missed) return Color(0xFFF56565);
    return Color(0xFFCBD5E0);
  }

  String formatDate(DateTime date) {
    return '${_getDayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  void gotoHearingDetails() {
    NavigatorService().gotoCaseHearingDetails(kase: caseModel.value);
  }

  void editCase() {
    NavigatorService().gotoCaseEditScreen(kase: caseModel.value);
  }

  void addNote() {
    Get.snackbar(
      'Add Note',
      'Note functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewClientDetails(ContactModel client) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              client.name,
              style: Get.textTheme.titleLarge?.copyWith(color: Color(0xFF1A365D)),
            ),
            SizedBox(height: 10),
            _buildContactInfo('Phone', client.contactNumber ?? ""),
            if (client.email != null) _buildContactInfo('Email', client.email!),
            _buildContactInfo('Type', client.type.capitalizeFirst!),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => NavigatorService.pop(),
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A5568),
            ),
          ),
          Text(value, style: Get.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Future<void> leaveScreen() async {
    await Get.delete<CaseDetailsController>();
    NavigatorService.pop();
  }
}