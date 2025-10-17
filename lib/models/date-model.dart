import 'dart:developer';
import 'package:get/get.dart';

class CaseHearingDateFields{
  final String prevDate = "prevDate";
  final String upcomingDate = "upcomingDate";
  final String dateStatus = "dateStatus";
  final String dateNotes = "dateNotes";
}

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

  void print(){
    log("Upcoming Date: $upcomingDate");
    log("Date Status: $dateStatus");
    log("Date Notes: $dateNotes");

    log("Prev Dates: ");
    for(var date in prevDate){
      date.print();
    }
  }

  Map<String, dynamic> toMap(){
    var f = CaseHearingDateFields();
    return {
      f.prevDate: prevDate.map((e) => e.toMap()).toList(),
      f.upcomingDate: upcomingDate?.toIso8601String(),
      f.dateStatus: dateStatus,
      f.dateNotes: dateNotes,
    };
  }

  factory CaseHearingsDateModel.fromMap(Map<String, dynamic> map){
    var f = CaseHearingDateFields();
    List<PrevHearingDateModel> prevDates = [];

    if(map[f.prevDate] != null){
      prevDates = (map[f.prevDate] as List).map((e) => PrevHearingDateModel.fromMap(e)).toList();
    }


    return CaseHearingsDateModel(
      prevDate: prevDates,
      upcomingDate: DateTime.tryParse(map[f.upcomingDate]),
      dateStatus: map[f.dateStatus],
      dateNotes: map[f.dateNotes],
    );
  }
}

class PrevHearingDateFields{
  final String date = "date";
  final String dateStatus = "dateStatus";
  final String dateNotes = "dateNotes";
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

  void print(){
    log("Date: $date");
    log("Date Status: $dateStatus");
    log("Date Notes: $dateNotes");
  }

  Map<String, dynamic> toMap(){
    var f = PrevHearingDateFields();
    return {
      f.date: date.toIso8601String(),
      f.dateStatus: dateStatus,
      f.dateNotes: dateNotes,
    };
  }

  factory PrevHearingDateModel.fromMap(Map<String, dynamic> map){
    var f = PrevHearingDateFields();
    return PrevHearingDateModel(
      date: DateTime.parse(map[f.date]),
      dateStatus: map[f.dateStatus],
      dateNotes: map[f.dateNotes],
    );
  }
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