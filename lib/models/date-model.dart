import 'package:get/get.dart';

class DateModel{
  List<PrevDateModel> prevDate;
  DateTime? upcomingDate;
  String dateStatus;
  String? dateNotes;

  DateModel({
    required this.prevDate,
    required this.upcomingDate,
    required this.dateStatus,
    this.dateNotes
  });

  PrevDateModel? get lastDate {
    if(prevDate.isEmpty){
      return null;
    }
    return prevDate[prevDate.length - 1];
  }
}

class PrevDateModel{
  DateTime date;
  String dateStatus;
  String? dateNotes;

  PrevDateModel({
    required this.date,
    required this.dateStatus,
    this.dateNotes,
  });
}

class DateStatus{
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