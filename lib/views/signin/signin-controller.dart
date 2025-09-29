import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';

class SigninController extends GetxController {
  var isLoading = false.obs;
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
    if (emailOrPhone.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    isLoading.value = false;

    // Navigate to dashboard after successful signin
    Get.offAllNamed('/dashboard');
  }

  void navigateToSignup() {
    NavigatorService().gotoSignup();
  }

  void navigateToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
}