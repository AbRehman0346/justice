import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:justice/models/case-model.dart';
import 'package:justice/models/fields/users-fields.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/services/firebase/collections.dart';

class FirestoreCase{
  static List<CaseModel> _cases = [];
  Future<void> createCase(CaseModel caseModel) async {
    await Collections().cases.doc(caseModel.id).set(caseModel.toMap());
    await getCases(forceReload: true);
  }

  Future<List<CaseModel>> getCases({bool forceReload = false}) async {
    if(_cases.isNotEmpty && !forceReload) return _cases;
    var user = await UserModel.currentUser;
    var fields = CaseModelFields();
    QuerySnapshot query = await Collections().cases.where(fields.ownerId, isEqualTo: user.id).get();
    List<DocumentSnapshot> docs = query.docs;
    _cases = docs.map((doc) => CaseModel.fromDocument(doc)).toList();
    return _cases;
  }
}