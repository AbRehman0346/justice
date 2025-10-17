import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/temp_data/cases-data.dart';
import '../../../models/associate_lawyer_model.dart';
import '../../../models/case-model.dart';

class AssociateLawyerController extends GetxController {
  var isLoading = false.obs;
  var isEditingPermissions = false.obs;
  var selectedAccessLevel = CaseAccessLevel().read.obs;

  late Rx<AssociatedLinksModel> associate;

  AssociateLawyerController(AssociatedLinksModel associate){
    this.associate = associate.obs;
  }

  List<CaseModel> get casesWithoutAccess {
    return CasesData.cases.where((caseItem) {
      if(associate.value.caseAccesses.isEmpty) return true;
      return associate.value.caseAccesses.any((access) => access.kase.id != caseItem.id);
    }).toList();
  }

  List<CaseAccess> get activeCaseAccesses {
    return associate.value.caseAccesses.where((access) {
      return (access.expiresAt == null || access.expiresAt!.isAfter(DateTime.now()));
    }).toList();
  }

  void setAccessLevel(String level) {
    selectedAccessLevel.value = level;
  }

  Future<void> grantCaseAccess(CaseModel caseItem, String accessLevel) async {
    final currentUser = await UserModel.currentUser;

    final newAccess = CaseAccess(
      caseId: caseItem.id,
      accessLevel: accessLevel,
      grantedAt: DateTime.now(),
      grantedBy: currentUser.id,
    );
    log("Created New Case");

    // Remove existing access if any
    associate.value.caseAccesses.removeWhere((access) => access.kase.id == caseItem.id);
    log("Removed Access if any");

    // Add new access
    associate.value.caseAccesses.add(newAccess);
    log("Added New Case");
    associate.refresh();
    log("Refresh Done");

    Get.snackbar(
      'Access Granted',
      '$accessLevel access granted for "${caseItem.title}"',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    log("Msg Printed.....");
  }

  void updateCaseAccess(String caseId, String newAccessLevel) {
    final accessIndex = associate.value.caseAccesses.indexWhere((access) => access.kase.id == caseId);

    if (accessIndex != -1) {
      associate.value.caseAccesses[accessIndex] = CaseAccess(
        caseId: caseId,
        accessLevel: newAccessLevel,
        grantedAt: associate.value.caseAccesses[accessIndex].grantedAt,
        grantedBy: associate.value.caseAccesses[accessIndex].grantedBy.id,
        expiresAt: associate.value.caseAccesses[accessIndex].expiresAt,
      );
      associate.refresh();

      Get.snackbar(
        'Permissions Updated',
        'Access changed to $newAccessLevel',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  void revokeCaseAccess(String caseId) {
    associate.value.caseAccesses.removeWhere((access) => access.kase.id == caseId);
    associate.refresh();

    Get.snackbar(
      'Access Revoked',
      'Case access has been revoked',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void removeAssociateLawyer() {
    Get.defaultDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      backgroundColor: AppColors.dialogBg,
      titleStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: TextStyle(
        color: Colors.black,
      ),
      title: 'Remove Associate Lawyer',
      middleText: 'Are you sure you want to remove "${associate.value.id}" from your team? This will revoke all case accesses.',
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(result: 'removed'); // Return to previous screen
        Get.snackbar(
          'Removed',
          '${associate.value.id} has been removed from your team',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Color getAccessLevelColor(String accessLevel) {
    CaseAccessLevel level = CaseAccessLevel();
    if(accessLevel == level.write) return Color(0xFF48BB78); // Green
    if(accessLevel == level.read) return Color(0xFFED8936); // Orange
    if(accessLevel == level.none) return Color(0xFFF56565); // Red
    return Color(0xFFCBD5E0);
  }

  String getAccessLevelText(String accessLevel) {
    CaseAccessLevel level = CaseAccessLevel();
    if(accessLevel == level.write) return 'Read & Write';
    if(accessLevel == level.read) return 'Read Only';
    if(accessLevel == level.none) return 'No Access';
    return accessLevel.capitalizeFirst!;
  }

  String getRoleBadge(String role) {
    switch (role.toLowerCase()) {
      case 'senior associate':
        return 'Senior';
      case 'junior associate':
        return 'Junior';
      case 'partner':
        return 'Partner';
      default:
        return role;
    }
  }

  Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'senior associate':
        return Color(0xFF805AD5); // Purple
      case 'junior associate':
        return Color(0xFF4299E1); // Blue
      case 'partner':
        return Color(0xFFD69E2E); // Gold
      default:
        return Color(0xFF718096);
    }
  }

  void showGrantAccessSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grant Case Access',
                  style: Get.textTheme.titleLarge?.copyWith(color: Color(0xFF1A365D)),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => NavigatorService.pop(),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Access Level Selector
            _buildAccessLevelSelector(),
            SizedBox(height: 16),

            // Available Cases List
            Expanded(
              child: _buildAvailableCasesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessLevelSelector() {
    CaseAccessLevel level = CaseAccessLevel();
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildAccessLevelOption('Read Only', level.read),
          _buildAccessLevelOption('Read & Write', level.write),
        ],
      ),
    );
  }

  Widget _buildAccessLevelOption(String label, String level) {
    return Obx(() => Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setAccessLevel(level),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selectedAccessLevel.value == level
                  ? getAccessLevelColor(level)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                label,
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: selectedAccessLevel.value == level
                      ? Colors.white
                      : Color(0xFF4A5568),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildAvailableCasesList() {
    List<CaseModel> casesWithoutAccess = this.casesWithoutAccess;
    return ListView.builder(
      itemCount: casesWithoutAccess.length,
      itemBuilder: (context, index) {
        final caseItem = casesWithoutAccess[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF1A365D).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.folder_open, color: Color(0xFF1A365D)),
          ),
          title: Text(caseItem.title, style: Get.textTheme.bodyLarge),
          subtitle: Text('${caseItem.caseNumber} • ${caseItem.court}'),
          trailing: ElevatedButton(
            onPressed: () {
              grantCaseAccess(caseItem, selectedAccessLevel.value);
              NavigatorService.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonBg,
              foregroundColor: AppColors.buttonForeground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Grant'),
          ),
        );
      },
    );
  }
}