import 'dart:developer';
import 'package:flutter/cupertino.dart';

import '../../services/firebase/auth/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:justice/AppData.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/temp_data/users-data.dart';

class SignupController extends GetxController {
  var isPasswordVisible = false.obs;
  var selectedCountry = 'Pakistan'.obs;
  var selectedCity = 'Naushahro Feroz'.obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  final String _uniqueId = XUtils().getUniqueId();

  String name = '';
  String phoneNumber = '';
  String email = '';
  String assignedNumber = '';

  final Map<String, List<String>> countriesCities = {
    'Pakistan': ['Naushahro Feroz', 'Lahore', 'Karachi', 'Islamabad'],
    'United States': ['New York', 'Los Angeles', 'Chicago', 'Houston'],
    'United Kingdom': ['London', 'Manchester', 'Birmingham', 'Liverpool'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal', 'Calgary'],
    'Australia': ['Sydney', 'Melbourne', 'Brisbane', 'Perth'],
  };

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void setName(String name) {
    this.name = name;
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setCountry(String country) {
    selectedCountry.value = country;
    selectedCity.value = countriesCities[country]?.first ?? '';
  }

  void setCity(String city) {
    selectedCity.value = city;
  }

  void setAssignedNumber(String assignedNumber) {
    this.assignedNumber = assignedNumber;
  }

  Future<void> signUp() async {
    try{
      XUtils.showProgressBar();

      String id = _uniqueId;
      String name = this.name;
      String phoneNumber = this.phoneNumber;
      String email = this.email;
      String country = selectedCountry.value;
      String city = selectedCity.value;
      String password = passwordController.value.text;
      String assignedNumber = this.assignedNumber;

      // Simulate API call
      // await Future.delayed(Duration(seconds: 2));
      UserModel user = UserModel(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        country: country,
        city: city,
        password: password,
        assignedNumber: assignedNumber,
      );


      await Auth().createUserAccount(user);
      UserModel.dummy().setCurrentUser = user;

      XUtils.hideProgressBar();
      NavigatorService().gotoDashboard();
    }catch(e){
      XUtils.hideProgressBar();
      XUtils().printSuppressedError(e, "Signup Controller");
      Get.snackbar("Error", e.toString());
    }
  }

  void pop(){
    NavigatorService.pop();
  }
}