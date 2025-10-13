class AssociateLawyerModel {
  final String id;
  final String lawyerId;
  final String associateLawyerId;
  final String role;
  final DateTime joinedDate;
  final List<CaseAccess> caseAccesses;

  AssociateLawyerModel({
    required this.id,
    required this.lawyerId,
    required this.associateLawyerId,
    required this.role,
    required this.joinedDate,
    required this.caseAccesses,
  });
}

class CaseAccess {
  final String caseId;
  final String accessLevel;
  final DateTime grantedAt;
  final String grantedBy;
  DateTime? expiresAt;

  CaseAccess({
    required this.caseId,
    required this.accessLevel,
    required this.grantedAt,
    required this.grantedBy,
    this.expiresAt,
  });
}

class CaseAccessLevel{
  String read = "read";
  String write = "write";
  String none = "none";

  List<String> get all => [read, write, none];
}

class LawyerRole{
  String senior = "senior";
  String junior = "junior";
  String partner = "partner";

  List<String> get all => [senior, junior, partner];
}