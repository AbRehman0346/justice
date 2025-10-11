import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/res/utils/xutils.dart';
import '../../../../models/date-model.dart';

class EditDateController extends GetxController {
  var isLoading = false.obs;
  final HearingStatus dateStatus = HearingStatus();
  late Rx<CaseHearingsDateModel> dateModel;

  // RxList<PrevDateModel> prevDates = <PrevDateModel>[].obs;
  // Rx<DateTime?> upcomingDate = Rx<DateTime?>(null);
  // RxString upcomingDateNotes = ''.obs;
  // RxString upcomingDateStatus = ''.obs;


  // initializeWithDate(DateModel dateModel){
  //   prevDates = dateModel.prevDate.obs;
  //   upcomingDate.value = dateModel.upcomingDate;
  //   upcomingDateNotes.value = dateModel.dateNotes ?? '';
  //   upcomingDateStatus.value = dateModel.dateStatus;
  // }

  EditDateController(){
    dateModel = CaseHearingsDateModel(
      prevDate: [
        PrevHearingDateModel(
          date: DateTime(2024, 1, 15),
          dateStatus: dateStatus.attended,
          dateNotes: "First hearing - Both parties presented preliminary arguments",
        ),
        PrevHearingDateModel(
          date: DateTime(2024, 1, 30),
          dateStatus: dateStatus.adjourned,
          dateNotes: "Adjourned due to witness unavailability",
        ),
        PrevHearingDateModel(
          date: DateTime(2024, 2, 10),
          dateStatus: dateStatus.missed,
          dateNotes: "Client failed to appear",
        ),
      ],
      upcomingDate: DateTime(2024, 3, 15),
      dateStatus: dateStatus.upcoming,
      dateNotes: "Next hearing for evidence submission",
    ).obs;
  }

  Color getStatusColor(String status) {
    HearingStatus statuses = HearingStatus();

    if(status == statuses.attended){
      return Color(0xFF48BB78);
    }
    else if(status == statuses.adjourned){
      return Color(0xFFED8936);
    }
    else if(status == statuses.missed){
      return Color(0xFFF56565);
    }
    else if(status == statuses.upcoming){
      return Color(0xFF4299E1);
    }
    else if(status == statuses.notAssigned){
      return Color(0xFF718096);
    }else{
      return Color(0xFFCBD5E0);
    }
  }

  IconData getStatusIcon(String status) {
    if(status == dateStatus.attended){
      return Icons.check_circle;
    }
    else if(status == dateStatus.adjourned){
      return Icons.schedule;
    }
    else if(status == dateStatus.missed){
      return Icons.cancel;
    }
    else if(status == dateStatus.upcoming){
      return Icons.event_available;
    }
    else if(status == dateStatus.notAssigned){
      return Icons.event_busy;
    }else{
      return Icons.event;
    }
  }

  String formatDate(DateTime date) {
    return '${_getDayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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

  void addPreviousDate(PrevHearingDateModel newDate) {
    // prevDates.add(newDate);
    // // Sort by date descending (most recent first)
    // prevDates.sort((a, b) => b.date.compareTo(a.date));
    dateModel.update((model) {
      model!.prevDate.add(newDate);
      // Sort by date descending (most recent first)
      model.prevDate.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void updateUpcomingDate(DateTime? newDate, String? status, String? notes) {
    dateModel.update((model) {
      model!.upcomingDate = newDate ?? model.upcomingDate;
      model.dateStatus = status ?? model.dateStatus;
      model.dateNotes = notes ?? model.dateNotes;
    });
  }

  void updatePreviousDate(int index, PrevHearingDateModel updatedDate) {
    dateModel.update((model) {
      model!.prevDate[index] = updatedDate;
    });
  }

  void deletePreviousDate(int index) {
    dateModel.update((model) {
      model!.prevDate.removeAt(index);
    });
  }

  void addDateNote(int index, String note) {
    dateModel.update((model) {
      model!.prevDate[index].dateNotes = note;
    });
  }

  void updateOverallStatus(String status) {
    dateModel.update((model) {
      model!.dateStatus = status;
    });
  }

  void updateOverallNotes(String notes) {
    dateModel.update((model) {
      model!.dateNotes = notes;
    });
  }

  bool get hasUpcomingDate => dateModel.value.upcomingDate != null;
  bool get hasPreviousDates => dateModel.value.prevDate.isNotEmpty;

  List<PrevHearingDateModel> get sortedPreviousDates {
    return List.from(dateModel.value.prevDate)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> leaveScreen() async {
    bool status = await disposeControllers();
    NavigatorService.pop();
  }

  Future<bool> disposeControllers()  async {
    return await Get.delete<EditDateController>();
  }
}