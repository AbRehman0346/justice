import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justice/models/fields/users-fields.dart';

import '../res/navigation_service/NavigatorService.dart';

class UserModel {
  static UserModel? _user;
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String? assignedNumber; // optional
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


  static UserModel get getCurrentUser {
    if(_user != null) return _user!;


    Get.snackbar("Signed out", "You were Signout");
    NavigatorService().gotoSignIn(rmStack: true);
    return UserModel.dummy();
  }

  set setCurrentUser(UserModel value) {
    _user = value;
  }
}
