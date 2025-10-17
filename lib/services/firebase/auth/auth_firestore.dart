import 'package:justice/models/user-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:justice/services/firebase/collections.dart';
class AuthFirestore{
  Future<UserModel> uploadUserData(UserModel user) async {
    await Collections().users.doc(user.id).set(user.toMap());
    return user;
  }

  Future<UserModel?> getUserData(String email) async {
    QuerySnapshot snapshot = await Collections().users.where('email', isEqualTo: email).get();

    if(snapshot.docs.isEmpty) return null;

    return UserModel.fromDoc(snapshot.docs[0]);
  }
}