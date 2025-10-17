import 'package:justice/models/case-model.dart';
import 'package:justice/services/firebase/collections.dart';

class FirestoreCase{
  Future<void> createCase(CaseModel caseModel) async {
    await Collections().cases.doc(caseModel.id).set(caseModel.toMap());
  }
}