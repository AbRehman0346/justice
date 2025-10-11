import 'dart:ui';
import 'package:get/get.dart';
import 'package:justice/res/extensions/datetime-extensions.dart';
import '../../../models/case-model.dart';
import '../../../models/contact-model.dart';
import '../../../models/date-model.dart';

class CaseHearingsController extends GetxController {
  var isLoading = false.obs;
  var selectedTab = 0.obs; // 0: Upcoming, 1: Previous
  CaseModel kase;
  CaseHearingsController(this.kase);

  CaseHearingsDateModel? get hearings => kase.date;

  List<PrevHearingDateModel> get previousHearings {
    if(hearings == null) return [];
    return hearings!.prevDate..sort((a, b) => b.date.compareTo(a.date));
  }

  DateTime? get upcomingHearing => hearings?.upcomingDate;

  Color getStatusColor(String status) {
    final dateStatus = HearingStatus();
    if(status == dateStatus.attended) return Color(0xFF48BB78);
    if(status == dateStatus.adjourned) return Color(0xFFED8936);
    if(status == dateStatus.missed) return Color(0xFFF56565);
    if(status == dateStatus.upcoming) return Color(0xFF4299E1);
    if(status == dateStatus.notAssigned) return Color(0xFF718096);
    return Color(0xFFCBD5E0);
  }

  String getStatusLabel(String status) {
    final dateStatus = HearingStatus();
    return dateStatus.getLabel(status);
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == yesterday) return 'Yesterday';

    return '${date.weekday}, ${date.day} ${date.monthName} ${date.year}';
  }

  void setTab(int index) {
    selectedTab.value = index;
  }

  void refreshHearings() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
  }

  void addNewHearing() {
    Get.snackbar(
      'Add Hearing',
      'Add new hearing functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void editHearing(PrevHearingDateModel hearing) {
    Get.snackbar(
      'Edit Hearing',
      'Edit hearing for ${formatDate(hearing.date)}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}