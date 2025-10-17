import 'package:firebase_auth/firebase_auth.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/services/firebase/auth/auth_firestore.dart';

class Auth{
  Future<void> createUserAccount(UserModel user) async {
    try{
      await AuthFirestore().uploadUserData(user);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password);
    }catch(e){
      XUtils().printSuppressedError(e, "auth.dart");
      rethrow;
    }
  }

  Future<UserModel> login(String email, String password) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      UserModel user = await UserModel.currentUser;
      return user;
    }catch(e){
      XUtils().printSuppressedError(e, "auth.dart");
      rethrow;
    }
  }

}