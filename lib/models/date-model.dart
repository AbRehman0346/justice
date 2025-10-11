import 'package:get/get.dart';

class CaseHearingsDateModel{
  List<PrevHearingDateModel> prevDate;
  DateTime? upcomingDate;
  String dateStatus;
  String? dateNotes;

  CaseHearingsDateModel({
    required this.prevDate,
    required this.upcomingDate,
    required this.dateStatus,
    this.dateNotes
  });

  PrevHearingDateModel? get lastDate {
    if(prevDate.isEmpty){
      return null;
    }
    return prevDate[prevDate.length - 1];
  }
}

class PrevHearingDateModel{
  DateTime date;
  String dateStatus;
  String? dateNotes;

  PrevHearingDateModel({
    required this.date,
    required this.dateStatus,
    this.dateNotes,
  });
}

class HearingStatus{
  final String missed = "missed";
  final String adjourned = "adjourned";
  final String attended = "attended";
  final String upcoming = "upcoming";
  final String notAssigned = "Not-Assigned";


  List<String> get all => [
    missed,
    adjourned,
    attended,
    upcoming,
  ];

  String getLabel(String status){
    if(!isValidStatus(status)) return "Unknown";
    if(status == notAssigned) return "Not Assigned";
    return status.capitalizeFirst ?? "Unknown";
  }

  bool isValidStatus(String status){
    return all.contains(status);
  }
}