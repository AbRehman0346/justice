import 'dart:ui';
import 'package:get/get.dart';
import 'package:justice/temp_data/temp-data.dart';
import '../../../models/case-model.dart';
import '../../../models/contact-model.dart';
import '../../../models/date-model.dart';

class HearingDateController extends GetxController {
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  CaseModel? kase;

  HearingDateController(CaseModel kase){
    this.kase = kase;
  }

  List<CaseModel> get getCase {
    return [?kase];
  }

  List<CaseModel> get displayedCases {
    return getCase.where((caseItem) {
      return true;
      // return caseItem.date != null && caseItem.date!.prevDate.isBefore(DateTime.now());
    }).toList();
  }

  void searchDates(String query) {
    searchQuery.value = query;
  }

  Color getDateStatusColor(String status) {
    final DateStatus s = DateStatus();

    if(status == s.attended){
      return Color(0xFF48BB78);
    }
    else if(status == s.adjourned){
      return Color(0xFFED8936);
    }
    else if(status == s.missed){
      return Color(0xFFF56565);
    }
    else if(status == s.upcoming){
      return Color(0xFF4299E1);
    } else{
      return Color(0xFFCBD5E0);
    }
  }

  String getDateStatusText(String status) {
    return status.capitalizeFirst ?? "Unknown";
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final tomorrow = today.add(Duration(days: 1));

    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == yesterday) return 'Yesterday';
    if (dateOnly == tomorrow) return 'Tomorrow';

    return '${getDayName(date.weekday)}, ${date.day} ${getMonthName(date.month)} ${date.year}';
  }

  String formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }

  String getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  String getDaysDifference(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(DateTime(now.year, now.month, now.day));
    final days = difference.inDays;

    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    if (days == -1) return 'Yesterday';
    if (days > 0) return 'In $days days';
    if (days < 0) return '${days.abs()} days ago';

    return '';
  }

  void refreshDates() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
  }

  void viewCaseDetails(CaseModel caseItem) {
    Get.toNamed('/case-details', arguments: caseItem);
  }
}