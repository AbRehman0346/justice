import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import '../../models/contact-model.dart';

class AddContactController extends GetxController {
  var isLoading = false.obs;

  // Form fields
  var email = ''.obs;
  var contactNumber = ''.obs;
  var type = 'client'.obs;
  var name = ''.obs;

  final List<String> contactTypes = ['client', 'opposing counsel', 'judge', 'witness', 'expert'];

  void setContactType(String contactType) {
    type.value = contactType;
  }

  Future<void> saveContact() async {
    if (name.isEmpty) { // Only name is required now
      Get.snackbar(
        'Error',
        'Please enter contact name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    await Future.delayed(Duration(seconds: 2));

    final newContact = ContactModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email.value.isEmpty ? null : email.value,
      contactNumber: contactNumber.value.isEmpty ? null : contactNumber.value, // Optional
      type: type.value,
      name: name.value,
      createdAt: DateTime.now(),
    );

    isLoading.value = false;

    Get.back(result: newContact);
    Get.snackbar(
      'Success',
      'Contact added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void resetForm() {
    email.value = '';
    contactNumber.value = '';
    type.value = 'client';
    name.value = '';
  }
}