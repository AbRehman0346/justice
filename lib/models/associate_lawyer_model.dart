import 'package:get/get.dart';
import 'package:justice/models/case-model.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/temp_data/cases-data.dart';

class AssociatedLinksModel {
  final String id;
  final String lawyerId;
  final String associateLawyerId;
  final String role;
  final DateTime joinedDate;
  final List<CaseAccess> caseAccesses;

  UserModel? _associateLawyerDetails;

  AssociatedLinksModel({
    required this.id,
    required this.lawyerId,
    required this.associateLawyerId,
    required this.role,
    required this.joinedDate,
    required this.caseAccesses,
  });

  UserModel get associateLawyerDetails{
    if(_associateLawyerDetails != null) return _associateLawyerDetails!;

    _associateLawyerDetails = UserModel.getUserById(associateLawyerId);
    return _associateLawyerDetails!;
  }

}

class CaseAccess {
  CaseModel? _case;
  UserModel? _grantedByUserDetails;

  late final String _caseId;
  final String accessLevel;
  final DateTime grantedAt;
  late final String _grantedBy;
  DateTime? expiresAt;

  CaseAccess({
    required String caseId,
    required this.accessLevel,
    required this.grantedAt,
    required String grantedBy,
    this.expiresAt,
  }){
    this._caseId = caseId;
    this._grantedBy = grantedBy;
  }

  CaseModel get kase {
    if(_case != null && _case!.isNotDummy) return _case!;
    _case = CasesData.getCaseById(_caseId) ?? CaseModel.dummy(id: _caseId);
    return _case!;
  }

  UserModel get grantedBy {
    if(_grantedByUserDetails != null) return _grantedByUserDetails!;
    _grantedByUserDetails = UserModel.getUserById(_grantedBy);
    return _grantedByUserDetails!;
  }
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

  List<String> get all => [senior.capitalizeFirst!, junior.capitalizeFirst!, partner.capitalizeFirst!];
}