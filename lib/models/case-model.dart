import 'package:justice/models/contact-model.dart';
import 'package:justice/models/date-model.dart';

class CaseModel {
  final String id;
  final String title;
  final String court;
  final String city;
  final String proceedingsDetails;
  final String caseStage;
  final String? caseType;
  final List<String>? linkedCaseId;
  final List<ContactModel>? clientIds;
  final DateTime createdAt;
  CaseHearingsDateModel? date;
  final String? caseNumber;
  final String status;
  final String priority;

  CaseModel({
    required this.id,
    required this.title,
    required this.court,
    required this.city,
    required this.status,
    required this.priority,
    required this.proceedingsDetails,
    required this.caseStage,
    required this.createdAt,
    this.date,
    this.clientIds,
    this.caseType,
    this.caseNumber,
    this.linkedCaseId,
  });
}


class CasePriority{
  final String high = "high";
  final String medium = "medium";
  final String low = "low";

  List<String> get all => [high, medium, low];
}

class CaseStatus{
  final String active = "active";
  final String disposeOff = "disposed-off";

  List<String> get all => [active, disposeOff];
}

class CaseStages{
  String firstHearing = 'First Hearing';
  String evidence = 'Evidence';
  String arguments = 'Arguments';
  String judgement = 'Judgment';
  String appeal = 'Appeal';
  String mediation = 'Mediation';
  String settlement = 'Settlement';
  String trail = 'trial';

  List<String> get all => [
    firstHearing,
    evidence,
    arguments,
    judgement,
    appeal,
    mediation,
    settlement,
    trail,
  ];
}

class CaseTypes{
  String civil = 'Civil';
  String criminal = 'Criminal';
  String family = 'Family';
  String bail = 'Bail Application';
  String corporate = 'Corporate';
  String property = 'Property';
  String labor = 'Labor';
  String intellectualProperty = 'Intellectual Property';
  String tax = "tax";

  List<String> get all => [
    civil,
    criminal,
    family,
    bail,
    corporate,
    property,
    labor,
    intellectualProperty,
    tax,
  ];
}
