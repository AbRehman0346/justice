import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice/AppData.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/temp_data/users-data.dart';

class SignInController extends GetxController {
  var isPasswordVisible = false.obs;
  var isRememberMe = false.obs;
  var emailOrPhone = ''.obs;
  var password = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    isRememberMe.value = !isRememberMe.value;
  }

  bool get isEmail => emailOrPhone.value.contains('@');

  Future<void> signIn() async {
    try{
      XUtils.showProgressBar();
      if (this.emailOrPhone.isEmpty || this.password.isEmpty) {
        throw Exception("Please fill in all fields.");
      }


      String emailOrPhone = this.emailOrPhone.value;
      String password = this.password.value;

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      UserModel? user = UsersData().getUserByEmailAndPassword(emailOrPhone, password);
      if(user == null){
        throw Exception("Could not find user");
      }
      UserModel.dummy().setCurrentUser = user!;
      XUtils.hideProgressBar();

      // Navigate to dashboard after successful signin
      NavigatorService().gotoDashboard();
    }catch(e){
      XUtils.hideProgressBar();
      XUtils().printSuppressedError(e, "SignIn Controller");
      Get.snackbar(
        'Error',
        e.toString().replaceFirst("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void navigateToSignup() {
    NavigatorService().gotoSignup();
  }

  void navigateToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
}