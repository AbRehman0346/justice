import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/services/firebase/case/firestore-case.dart';
import 'package:justice/temp_data/cases-data.dart';
import '../create_case/controller-tags.dart';
import '../create_case/link-case-controller.dart';
import '../../../models/case-model.dart';
import '../../../models/contact-model.dart';
import '../../../models/date-model.dart';

class AddCaseController extends GetxController {
  var isLoading = false.obs;
  var selectedClients = <ContactModel>[].obs;

  // Form fields
  var title = ''.obs;
  var court = ''.obs;
  var city = ''.obs;
  var proceedingsDetails = ''.obs;
  var caseStage = 'First Hearing'.obs;
  var caseType = 'Civil'.obs;
  var caseNumber = ''.obs;
  var status = 'active'.obs;
  var priority = 'medium'.obs;

  // Date fields
  var upcomingDate = Rxn<DateTime>();
  var dateStatus = HearingStatus().notAssigned.obs;
  var dateNotes = ''.obs;

  final List<String> statusOptions = CaseStatus().all;
  final List<String> priorityOptions = CasePriority().all;
  final List<String> caseStageOptions = CaseStages().all;
  final List<String> caseTypeOptions = CaseTypes().all;
  final List<String> dateStatusOptions = [HearingStatus().upcoming, HearingStatus().notAssigned];

  // var linkedCaseIds = <String>[].obs;
  var newLinkedCaseId = ''.obs;

  void setStatus(String newStatus) {
    status.value = newStatus;
  }

  void setPriority(String newPriority) {
    priority.value = newPriority;
  }

  void setCaseStage(String stage) {
    caseStage.value = stage;
  }

  void setCaseType(String type) {
    caseType.value = type;
  }

  void setDateStatus(String status) {
    dateStatus.value = status;
  }

  void setUpcomingDate(DateTime? date) {
    upcomingDate.value = date;
    setDateStatus(HearingStatus().upcoming);
  }

  void addClient(ContactModel client) {
    if (!selectedClients.any((c) => c.id == client.id)) {
      selectedClients.add(client);
    }
  }

  void removeClient(ContactModel client) {
    selectedClients.removeWhere((c) => c.id == client.id);
  }

  Future<void> navigateToAddContact() async {
    ContactModel? result = await NavigatorService().gotoAddContact();
    if (result != null) {
      addClient(result);
    }
  }

  bool validateForm() {
    if (title.isEmpty || court.isEmpty || city.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (upcomingDate.value == null) {
      Get.snackbar(
        'Error',
        'Please select an upcoming date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> saveCase() async {
    if (!validateForm()) return;

    XUtils.showProgressBar();

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    var tags = AddCaseScreenControllerTags();

    LinkCaseController linkCaseController = Get.find<LinkCaseController>(tag: tags.linkCase);
    List<String> linkedCasesIds = linkCaseController.getLinkedCasesIds;
    UserModel user = await UserModel.currentUser;

    final newCase = CaseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.value,
      court: court.value,
      city: city.value,
      status: status.value,
      priority: priority.value,
      proceedingsDetails: proceedingsDetails.value,
      caseStage: caseStage.value,
      createdAt: DateTime.now(),
      date: CaseHearingsDateModel(
        prevDate: [], // Empty initially, will be added later
        upcomingDate: upcomingDate.value!,
        dateStatus: dateStatus.value,
        dateNotes: dateNotes.value.isEmpty ? null : dateNotes.value,
      ),
      clientIds: selectedClients.isNotEmpty ? selectedClients.toList() : null,
      caseType: caseType.value,
      caseNumber: caseNumber.value.isEmpty ? null : caseNumber.value,
      linkedCaseId: linkedCasesIds,
      ownerId: user.id,
    );

    await FirestoreCase().createCase(newCase);

    XUtils.hideProgressBar();

    goback();
    Get.snackbar(
      'Success',
      'Case added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void resetForm() {
    title.value = '';
    court.value = '';
    city.value = '';
    proceedingsDetails.value = '';
    caseStage.value = 'First Hearing';
    caseType.value = 'Civil';
    caseNumber.value = '';
    status.value = 'active';
    priority.value = 'medium';
    upcomingDate.value = null;
    dateStatus.value = 'upcoming';
    dateNotes.value = '';
    selectedClients.clear();
  }

  Future<void> goback() async {
    await disposeControllers();
    NavigatorService.pop();
  }

  Future<bool> disposeControllers() async {
    var tags = AddCaseScreenControllerTags();
    bool success1 = await Get.delete<LinkCaseController>(tag: tags.linkCase);
    bool success2 = await Get.delete<AddCaseController>(tag: tags.addCase);

    return success1 && success2;
  }
}