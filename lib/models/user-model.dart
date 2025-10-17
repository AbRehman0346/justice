import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justice/models/fields/users-fields.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/services/firebase/auth/auth_firestore.dart';
import '../res/navigation_service/NavigatorService.dart';
import '../temp_data/users-data.dart';

class UserModel {
  static UserModel? _user;
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String? assignedNumber;
  final String country;
  final String city;
  final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.assignedNumber,
    required this.country,
    required this.city,
    required this.password,
  });

  // Convert a UserModel to JSON
  Map<String, dynamic> toJson() {
    final f = UserFields();
    return {
      f.name: name,
      f.phoneNumber: phoneNumber,
      f.email: email,
      f.assignedNumber: assignedNumber,
      f.country: country,
      f.city: city,
      f.password: password,
    };
  }

  // Create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final f = UserFields();
    return UserModel(
      id: json[f.id] ?? '',
      name: json[f.name] ?? '',
      phoneNumber: json[f.phoneNumber] ?? '',
      email: json[f.email] ?? '',
      assignedNumber: json[f.assignedNumber],
      country: json[f.country] ?? '',
      city: json[f.city] ?? '',
      password: json[f.password] ?? '',
    );
  }

  factory UserModel.dummy(){
    return UserModel(id: "Unknowns", name: "Unknowns", phoneNumber: "###########", email: "@gmail.com", country: "Unknown", city: "Unknown", password: "Unknown");
  }

  UserModel.error() : this._all("Error");

  UserModel._all(String text)
      : id = "----",
        name = text,
        email = text,
        phoneNumber = text,
        country = text,
        city = text,
        assignedNumber = text,
        password = text;

  factory UserModel.getUserById(String id){
    return UsersData().getUserById(id) ?? UserModel.dummy();
  }

  static Future<UserModel> get currentUser async {
    void gotoSignIn(){
      Get.snackbar("Signed out", "You were Signed Out");
      NavigatorService().gotoSignIn(rmStack: true);
    }
    try{
      if(_user != null) return _user!;
      User? userCredentials = FirebaseAuth.instance.currentUser;
      if(userCredentials == null || userCredentials!.email == null) {
        gotoSignIn();
        throw Exception("User not found");
      }
      UserModel? user = await AuthFirestore().getUserData(userCredentials!.email!);
      if(user == null) {
        gotoSignIn();
        throw Exception("User not found");
      }
      _user = user;
      return _user!;
    }catch(e){
      XUtils().printSuppressedError(e, "File: UserModel");
      return UserModel.error();
    }
  }

  set setCurrentUser(UserModel value) {
    _user = value;
  }

  void print(){
    log("id $id");
    log("name $name");
    log("phoneNumber $phoneNumber");
    log("email $email");
    log( "assignedNumber $assignedNumber");
    log("country $country");
    log("city $city");
    log("password $password");
  }

  Map<String, dynamic> toMap(){
    UserFields f = UserFields();
    return {
      f.id: id,
      f.name: name,
      f.phoneNumber: phoneNumber,
      f.email: email,
      f.assignedNumber: assignedNumber,
      f.country: country,
      f.city: city
    };
  }

  factory UserModel.fromDoc(DocumentSnapshot doc){
    final f = UserFields();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
        id: doc.id,
        name: doc[f.name] ?? "Error",
        phoneNumber: doc[f.phoneNumber] ?? "Error",
        email: doc[f.email] ?? "Error",
        country: doc[f.country] ?? "Error",
        city: doc[f.city] ?? "Error",
        password: doc.get(f.password) ?? "",
    );
  }
}
