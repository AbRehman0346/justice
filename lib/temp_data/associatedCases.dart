import 'package:justice/models/associate_lawyer_model.dart';
import 'package:justice/models/user-model.dart';

class AssociatedCases{
  static List<AssociatedLinksModel> associatedCases = [
    AssociatedLinksModel(
        id: "1", 
        lawyerId: "6",
        associateLawyerId: "1",
        role: LawyerRole().partner, 
        joinedDate: DateTime.now(), 
        caseAccesses: [
          CaseAccess(caseId: "1", accessLevel: CaseAccessLevel().read, grantedAt: DateTime.now(), grantedBy: "1"),
          CaseAccess(caseId: "2", accessLevel: CaseAccessLevel().write, grantedAt: DateTime.now(), grantedBy: "1"),
          CaseAccess(caseId: "3", accessLevel: CaseAccessLevel().write, grantedAt: DateTime.now(), grantedBy: "1"),
        ],
    ),

    AssociatedLinksModel(
      id: "2",
      lawyerId: "6",
      associateLawyerId: "2",
      role: LawyerRole().partner,
      joinedDate: DateTime.now(),
      caseAccesses: [
        CaseAccess(caseId: "4", accessLevel: CaseAccessLevel().write, grantedAt: DateTime.now(), grantedBy: "1"),
        CaseAccess(caseId: "5", accessLevel: CaseAccessLevel().read, grantedAt: DateTime.now(), grantedBy: "1"),
        CaseAccess(caseId: "6", accessLevel: CaseAccessLevel().write, grantedAt: DateTime.now(), grantedBy: "1"),
      ],
    ),

    AssociatedLinksModel(
      id: "3",
      lawyerId: "6",
      associateLawyerId: "3",
      role: LawyerRole().partner,
      joinedDate: DateTime.now(),
      caseAccesses: [
        CaseAccess(caseId: "7", accessLevel: CaseAccessLevel().write, grantedAt: DateTime.now(), grantedBy: "1"),
        CaseAccess(caseId: "8", accessLevel: CaseAccessLevel().read, grantedAt: DateTime.now(), grantedBy: "1"),
        CaseAccess(caseId: "9", accessLevel: CaseAccessLevel().write, grantedAt: DateTime.now(), grantedBy: "1"),
      ],
    ),
  ];

  List<AssociatedLinksModel> getAssociatedCasesByLawyerId(String lawyerId){
    return associatedCases.where((associateCase) => associateCase.lawyerId == lawyerId).toList();
  }

  bool doesAssociationExists(String lawyerId, String associationId){
    return associatedCases.any((associateCase) => associateCase.id == associationId && associateCase.lawyerId == lawyerId);
  }
}