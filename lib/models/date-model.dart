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
  String missed = "Missed";
  String adjourned = "Adjourned";
  String attended = "attended";
  String upcoming = "upcoming";
  String notAssigned = "Not-Assigned";


  List<String> get all => [
    missed,
    adjourned,
    attended,
    upcoming,
    notAssigned,
  ];
}