import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:justice/models/contact-model.dart';
import 'package:justice/models/date-model.dart';
import 'package:justice/res/extensions/llist-extension.dart';


class CaseModelFields{
  final String id = "id";
  final String title = "title";
  final String court = "court";
  final String city = "city";
  final String proceedingsDetails = "proceedingsDetails";
  final String caseStage = "caseStage";
  final String caseType = "caseType";
  final String linkedCaseId = "linkedCaseId";
  final String clientIds = "clients";
  final String createdAt = "createdAt";
  final String date = "date";
  final String caseNumber = "caseNumber";
  final String status = "status";
  final String priority = "priority";
  final String ownerId = "ownerId";
}

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
  final String ownerId;

  bool _isDummy = false;

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
    required this.ownerId,
    this.date,
    this.clientIds,
    this.caseType,
    this.caseNumber,
    this.linkedCaseId,
  });

  factory CaseModel.dummy(
  {
    String id = "--",
    String title = "Unknown",
    String court = "Unknown",
    String city = "Unknown",
    String status = "Unknown",
    String priority = "Unknown",
    String proceedingsDetails = "Unknown",
    String caseStage = "Unknown",
    String ownerId = "Unknown",
    DateTime? createdAt,
}
      ){
    DateTime dateTime = createdAt ?? DateTime.now();


    final object = CaseModel(
        id: id,
        title: title,
        court: court,
        city: city,
        status: status,
        priority: priority,
        proceedingsDetails: proceedingsDetails,
        caseStage: caseStage,
        createdAt: dateTime,
        ownerId: ownerId,
    );

    object._isDummy = true;
    return object;
  }

  factory CaseModel.fromDocument(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    final f = CaseModelFields();

    final caseModel = CaseModel(
      id: data[f.id],
      title: data[f.title],
      date: data[f.date] != null ? CaseHearingsDateModel.fromMap(data[f.date]) : null,
      linkedCaseId: (data[f.linkedCaseId] as List).toListString,
      caseNumber: data[f.caseNumber],
      caseType: data[f.caseType],
      court: data[f.court],
      city: data[f.city],
      status: data[f.status],
      priority: data[f.priority],
      proceedingsDetails: data[f.proceedingsDetails],
      caseStage: data[f.caseStage],
      createdAt: DateTime.parse(data[f.createdAt]),
      ownerId: data[f.ownerId],
    );

    return caseModel;
  }

  bool get isDummy => _isDummy;
  bool get isNotDummy => !_isDummy;

  void print(){
    log("id: $id");
    log("title: $title");
    log("court: $court");
    log("city: $city");
    log("proceedingsDetails: $proceedingsDetails");
    log("caseStage: $caseStage");
    log("caseType: $caseType");
    log("linkedCaseId: $linkedCaseId");
    log("createdAt: $createdAt");
    log("caseNumber: $caseNumber");
    log("status: $status");
    log("priority: $priority");
    log("ownerId: $ownerId");

    log("\nDate: ");
    date?.print();

    log("\nclientIds: ");
    for (ContactModel client in clientIds ?? []){
        client.print();
    }
  }


  Map<String, dynamic> toMap() {
    var f = CaseModelFields();
    return {
      f.id: id,
      f.title: title,
      f.court: court,
      f.city: city,
      f.proceedingsDetails: proceedingsDetails,
      f.caseStage: caseStage,
      f.caseType: caseType,
      f.linkedCaseId: linkedCaseId,
      f.clientIds: clientIds?.map((e) => e.toMap()).toList(),
      f.createdAt: createdAt.toIso8601String(),
      f.date: date?.toMap(),
      f.caseNumber: caseNumber,
      f.status: status,
      f.priority: priority,
      f.ownerId: ownerId,
    };
  }
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
