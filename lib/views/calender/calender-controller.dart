import 'dart:ui';
import 'package:get/get.dart';
import 'package:justice/models/contact-model.dart';
import 'package:justice/models/date-model.dart';
import 'package:justice/temp_data/cases-data.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/case-model.dart';

class CalendarController extends GetxController {
  var isLoading = false.obs;
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var calendarFormat = CalendarFormat.month.obs;
  var selectedEvents = <CaseModel>[].obs;

  ContactModel contact(String id, String name){
    return ContactModel(
        id: id,
        type: ContactType().client,
        name: name,
        createdAt: DateTime.now()
    );
  }

  // Sample cases data
  List<CaseModel> get allCases => CasesData.cases;

  List<CaseModel> get eventsForSelectedDay {
    return allCases.where((caseItem) {
      if(caseItem.date == null) return false;
      return isSameDay(caseItem.date!.upcomingDate, selectedDay.value);
    }).toList();
  }

  String formatEventKey(DateTime date){
    return "${date.day}.${date.month}.${date.year}";
  }

  Map<String, List<CaseModel>> get events {
    Map<String, List<CaseModel>> eventsMap = {};

    for (var caseItem in allCases) {
      if(caseItem.date == null) continue;
      if(caseItem.date!.upcomingDate == null) continue;

      final date = DateTime(
          caseItem.date!.upcomingDate!.year,
          caseItem.date!.upcomingDate!.month,
          caseItem.date!.upcomingDate!.day
      );

      String key = formatEventKey(date);
      if (eventsMap[key] == null) {
        eventsMap[key] = [];
      }
      eventsMap[key]!.add(caseItem);
    }

    return eventsMap;
  }

  List<CaseModel> getEventsForDay(DateTime day) {
    String key = formatEventKey(day);
    return events[key] ?? [];
  }

  int getEventCountForDay(DateTime day) {
    return getEventsForDay(day).length;
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
    selectedEvents.value = getEventsForDay(selectedDay);
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  void onPageChanged(DateTime focusedDay) {
    this.focusedDay.value = focusedDay;
  }

  String getSelectedDayHeader() {
    if (isSameDay(selectedDay.value, DateTime.now())) {
      return 'Today\'s Cases';
    } else if (isSameDay(selectedDay.value, DateTime.now().add(Duration(days: 1)))) {
      return 'Tomorrow\'s Cases';
    } else {
      return 'Cases on ${_formatDate(selectedDay.value)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Color(0xFFF56565);
      case 'medium':
        return Color(0xFFED8936);
      case 'low':
        return Color(0xFF48BB78);
      default:
        return Color(0xFFCBD5E0);
    }
  }

  void refreshData() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
    selectedEvents.value = getEventsForDay(selectedDay.value);
  }
}