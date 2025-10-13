import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice/res/colors/app-colors.dart';
import '../../../models/associate_lawyer_model.dart';
import '../../../models/case-model.dart';

class AssociateLawyerController extends GetxController {
  var isLoading = false.obs;
  var isEditingPermissions = false.obs;
  var selectedAccessLevel = 'read'.obs;

  // Sample associate lawyer data
  final associateLawyer = AssociateLawyerModel(
    lawyerId: "6",
    associateLawyerId: "1",
    id: 'AL001',
    role: 'Senior Associate',
    joinedDate: DateTime(2023, 1, 15),
    caseAccesses: [
      CaseAccess(
        caseId: '1',
        accessLevel: 'write',
        grantedAt: DateTime(2024, 1, 10),
        grantedBy: 'Robert Wilson',
      ),
      CaseAccess(
        caseId: '2',
        accessLevel: 'read',
        grantedAt: DateTime(2024, 1, 15),
        grantedBy: 'Robert Wilson',
      ),
      CaseAccess(
        caseId: '3',
        accessLevel: 'none',
        grantedAt: DateTime(2024, 1, 5),
        grantedBy: 'Robert Wilson',
      ),
    ],
  ).obs;

  // Sample cases that can be shared
  final availableCases = [
    CaseModel(
      id: '1',
      title: 'Smith vs Johnson Property Dispute',
      court: 'Supreme Court',
      city: 'New York',
      status: 'active',
      priority: 'high',
      proceedingsDetails: 'Property dispute case',
      caseStage: 'First Hearing',
      createdAt: DateTime.now(),
      caseNumber: 'SC-2024-001',
    ),
    CaseModel(
      id: '2',
      title: 'Corporate Merger Approval',
      court: 'High Court',
      city: 'Los Angeles',
      status: 'active',
      priority: 'medium',
      proceedingsDetails: 'Merger approval case',
      caseStage: 'Arguments',
      createdAt: DateTime.now(),
      caseNumber: 'HC-2024-045',
    ),
    CaseModel(
      id: '3',
      title: 'Intellectual Property Rights',
      court: 'District Court',
      city: 'Chicago',
      status: 'active',
      priority: 'high',
      proceedingsDetails: 'IP rights infringement case',
      caseStage: 'Evidence',
      createdAt: DateTime.now(),
      caseNumber: 'DC-2024-123',
    ),
    CaseModel(
      id: '4',
      title: 'Employment Contract Dispute',
      court: 'Labor Court',
      city: 'Houston',
      status: 'disposed-off',
      priority: 'low',
      proceedingsDetails: 'Employment dispute case',
      caseStage: 'Mediation',
      createdAt: DateTime.now(),
      caseNumber: 'LC-2024-078',
    ),
  ].obs;

  List<CaseModel> get casesWithoutAccess {
    return availableCases.where((caseItem) {
      return !associateLawyer.value.caseAccesses.any((access) => access.caseId == caseItem.id);
    }).toList();
  }

  List<CaseAccess> get activeCaseAccesses {
    return associateLawyer.value.caseAccesses.where((access) {
      return access.accessLevel != 'none' &&
          (access.expiresAt == null || access.expiresAt!.isAfter(DateTime.now()));
    }).toList();
  }

  void setAccessLevel(String level) {
    selectedAccessLevel.value = level;
  }

  void grantCaseAccess(CaseModel caseItem, String accessLevel) {
    final newAccess = CaseAccess(
      caseId: caseItem.id,
      accessLevel: accessLevel,
      grantedAt: DateTime.now(),
      grantedBy: 'You', // Current user
    );

    // Remove existing access if any
    associateLawyer.value.caseAccesses.removeWhere((access) => access.caseId == caseItem.id);

    // Add new access
    associateLawyer.value.caseAccesses.add(newAccess);
    associateLawyer.refresh();

    Get.snackbar(
      'Access Granted',
      '$accessLevel access granted for "${caseItem.title}"',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void updateCaseAccess(String caseId, String newAccessLevel) {
    final accessIndex = associateLawyer.value.caseAccesses.indexWhere((access) => access.caseId == caseId);

    if (accessIndex != -1) {
      associateLawyer.value.caseAccesses[accessIndex] = CaseAccess(
        caseId: caseId,
        accessLevel: newAccessLevel,
        grantedAt: associateLawyer.value.caseAccesses[accessIndex].grantedAt,
        grantedBy: associateLawyer.value.caseAccesses[accessIndex].grantedBy,
        expiresAt: associateLawyer.value.caseAccesses[accessIndex].expiresAt,
      );
      associateLawyer.refresh();

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
    associateLawyer.value.caseAccesses.removeWhere((access) => access.caseId == caseId);
    associateLawyer.refresh();

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
      middleText: 'Are you sure you want to remove "${associateLawyer.value.id}" from your team? This will revoke all case accesses.',
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(result: 'removed'); // Return to previous screen
        Get.snackbar(
          'Removed',
          '${associateLawyer.value.id} has been removed from your team',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Color getAccessLevelColor(String accessLevel) {
    switch (accessLevel) {
      case 'write':
        return Color(0xFF48BB78); // Green
      case 'read':
        return Color(0xFFED8936); // Orange
      case 'none':
        return Color(0xFFF56565); // Red
      default:
        return Color(0xFFCBD5E0);
    }
  }

  String getAccessLevelText(String accessLevel) {
    switch (accessLevel) {
      case 'write':
        return 'Read & Write';
      case 'read':
        return 'Read Only';
      case 'none':
        return 'No Access';
      default:
        return accessLevel.capitalizeFirst!;
    }
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
                  onPressed: () => Get.back(),
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
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildAccessLevelOption('Read Only', 'read'),
          _buildAccessLevelOption('Read & Write', 'write'),
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
    return Obx(() => ListView.builder(
      itemCount: casesWithoutAccess.length,
      itemBuilder: (context, index) {
        final caseItem = casesWithoutAccess[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF1A365D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.folder_open, color: Color(0xFF1A365D)),
          ),
          title: Text(caseItem.title, style: Get.textTheme.bodyLarge),
          subtitle: Text('${caseItem.caseNumber} • ${caseItem.court}'),
          trailing: ElevatedButton(
            onPressed: () {
              grantCaseAccess(caseItem, selectedAccessLevel.value);
              Get.back();
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
    ));
  }
}