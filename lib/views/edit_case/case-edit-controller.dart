import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/temp_data/temp-data.dart';
import '../../res/navigation_service/NavigatorService.dart';
import '../create_case/link-case-controller.dart';
import '../../views/edit_case/EditScreenControllerTags.dart';
import '../../models/case-model.dart';
import '../../models/contact-model.dart';
import '../../models/date-model.dart';

class CaseEditController extends GetxController {
  var isLoading = false.obs;
  var isSaving = false.obs;

  // Form fields
  var id = ''.obs;
  var title = ''.obs;
  var court = ''.obs;
  var city = ''.obs;
  var proceedingsDetails = ''.obs;
  var caseStage = ''.obs;
  var caseType = ''.obs;
  var caseNumber = ''.obs;
  var status = ''.obs;
  var priority = ''.obs;

  // Date fields
  var prevDate = DateTime.now().obs;
  Rx<DateTime?> upcomingDate = DateTime.now().add(Duration(days: 30)).obs;
  var dateStatus = ''.obs;
  var dateNotes = ''.obs;

  // Linked cases and clients
  var selectedClients = <ContactModel>[].obs;
  var newLinkedCaseId = ''.obs;

  // Other controllers
  var linkCaseController = Get.find<LinkCaseController>(tag: EditScreenControllerTags().linkCase);

  // Options
  final List<String> statusOptions = CaseStatus().all;
  final List<String> priorityOptions = CasePriority().all;
  final List<String> caseStageOptions = CaseStages().all;
  final List<String> caseTypeOptions = CaseTypes().all;
  final List<String> dateStatusOptions = DateStatus().all;

  void initializeWithCase(CaseModel caseModel) {
    id.value = caseModel.id;
    title.value = caseModel.title;
    court.value = caseModel.court;
    city.value = caseModel.city;
    proceedingsDetails.value = caseModel.proceedingsDetails;
    caseStage.value = caseModel.caseStage;
    caseType.value = caseModel.caseType ?? '';
    caseNumber.value = caseModel.caseNumber ?? '';
    status.value = caseModel.status;
    priority.value = caseModel.priority;

    if (caseModel.date != null) {
      prevDate.value = caseModel.date!.prevDate.last.date;
      upcomingDate.value = caseModel.date!.upcomingDate;
      dateStatus.value = caseModel.date!.dateStatus;
      dateNotes.value = caseModel.date!.dateNotes ?? '';
    }

    linkCaseController.loadCaseFromLinkedIds(caseModel.linkedCaseId ?? []);
    selectedClients.value = caseModel.clientIds ?? [];
  }

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

  void addClient(ContactModel client) {
    if (!selectedClients.any((c) => c.id == client.id)) {
      selectedClients.add(client);
    }
  }

  void removeClient(ContactModel client) {
    selectedClients.removeWhere((c) => c.id == client.id);
  }

  void navigateToAddContact() async {
    Get.snackbar("Upcoming", "Functionality Coming Soon");
    // final result = await Get.toNamed('/add-contact');
    // if (result != null && result is ContactModel) {
    //   addClient(result);
    // }
  }

  bool validateForm() {
    if (title.value.isEmpty) {
      Get.snackbar('Error', 'Please enter case title', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (caseStage.value.isEmpty) {
      Get.snackbar('Error', 'Please select case stage', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  Future<void> saveCase() async {
    if (!validateForm()) return;

    XUtils.showProgressBar("SAVING");

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    final updatedCase = CaseModel(
      id: id.value,
      title: title.value,
      court: court.value,
      city: city.value,
      status: status.value,
      priority: priority.value,
      proceedingsDetails: proceedingsDetails.value,
      caseStage: caseStage.value,
      caseType: caseType.value.isEmpty ? null : caseType.value,
      createdAt: DateTime.now(),
      date: DateModel(
        // TODO: update that prevDate property.
        prevDate: [PrevDateModel(date: prevDate.value, dateStatus: DateStatus().attended)],
        upcomingDate: upcomingDate.value,
        dateStatus: dateStatus.value,
        dateNotes: dateNotes.value.isEmpty ? null : dateNotes.value,
      ),
      clientIds: selectedClients.isEmpty ? null : selectedClients,
      caseNumber: caseNumber.value.isEmpty ? null : caseNumber.value,
      linkedCaseId: linkCaseController.linkedCases.isEmpty ? null : linkCaseController.getLinkedCasesIds,
    );

    int index = TempData.cases.indexWhere((value) => value.id == id.value);

    TempData.cases[index] = updatedCase;

    XUtils.hideProgressBar();

    Get.back(result: updatedCase);
    Get.snackbar(
      'Success',
      'Case updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void deleteCase() {
    Get.defaultDialog(
      title: 'Delete Case',
      middleText: 'Are you sure you want to delete this case? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(result: 'deleted'); // Return to previous screen with delete signal
        Get.snackbar(
          'Deleted',
          'Case has been deleted',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> goback() async {
    bool status = await disposeControllers();
    log("Dispose Controllers ==============>   $status");
    NavigatorService.pop();
  }

  Future<bool> disposeControllers() async {
    bool success1 = await Get.delete<CaseEditController>(tag: "CaseEdit");
    bool success2 = await Get.delete<LinkCaseController>(tag: "EditScreenLinkCase");
    return success1 && success2;
  }
}