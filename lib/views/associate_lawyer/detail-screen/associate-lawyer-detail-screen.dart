import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/res/utils/xutils.dart';
import '../../../models/associate_lawyer_model.dart';
import '../../../res/xwidgets/xtext.dart';
import 'associate-lawyer-detail-controller.dart';

class AssociateLawyerDetailsScreen extends StatelessWidget {
  AssociatedLinksModel associate;

  AssociateLawyerDetailsScreen(this.associate, {super.key});

  late AssociateLawyerController controller;

  _init(){
    controller = Get.put(AssociateLawyerController(associate));
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      body: Obx(() => CustomScrollView(
        slivers: [
          // App Bar with Lawyer Info
          _buildAppBar(),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Contact Information
                  _buildContactSection(),
                  SizedBox(height: 20),

                  // Case Access Header with Grant Button
                  _buildCaseAccessHeader(),
                  SizedBox(height: 16),

                  // Case Access List
                  _buildCaseAccessList(),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Color(0xFF1A365D),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red),
          onPressed: controller.removeAssociateLawyer,
          tooltip: 'Remove Lawyer',
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          controller.associate.value.associateLawyerDetails.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A365D),
                Color(0xFF2D3748),
              ],
            ),
          ),
          child: Obx(() => Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Profile Image/Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                // Text(
                //   controller.associateLawyer.value.name,
                //   style: GoogleFonts.poppins(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
                // SizedBox(height: 4),

                // Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.getRoleColor(controller.associate.value.role),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.getRoleBadge(controller.associate.value.role),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                XUtils.height(20),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      color: AppColors.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A365D),
              ),
            ),
            SizedBox(height: 16),
            _buildContactRow(Icons.email, 'Email', controller.associate.value.associateLawyerDetails.email),
            _buildContactRow(Icons.phone, 'Phone', controller.associate.value.associateLawyerDetails.phoneNumber),
            _buildContactRow(Icons.calendar_today, 'Joined',
                '${controller.associate.value.joinedDate.day}/${controller.associate.value.joinedDate.month}/${controller.associate.value.joinedDate.year}'),
            _buildContactRow(Icons.work, 'Role', controller.associate.value.role),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Color(0xFF718096)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseAccessHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Case Access',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A365D),
          ),
        ),
        ElevatedButton.icon(
          onPressed: controller.showGrantAccessSheet,
          icon: Icon(Icons.add, size: 16),
          label: XText('Grant Access', bold: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBg,
            foregroundColor: AppColors.buttonForeground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildCaseAccessList() {
    return Obx(() {
      if (controller.activeCaseAccesses.isEmpty) {
        return _buildEmptyAccessState();
      }

      return Column(
        children: controller.activeCaseAccesses.map((access) => _buildCaseAccessCard(access)).toList(),
      );
    });
  }

  Widget _buildCaseAccessCard(CaseAccess access) {
    return Card(
      color: AppColors.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Case Title and Access Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    access.kase.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A365D),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildAccessBadge(access.accessLevel),
              ],
            ),

            SizedBox(height: 8),

            // Access Details
            _buildAccessDetailRow('Granted by', access.grantedBy.name),
            _buildAccessDetailRow('Granted on',
                '${access.grantedAt.day}/${access.grantedAt.month}/${access.grantedAt.year}'),

            if (access.expiresAt != null)
              _buildAccessDetailRow('Expires on',
                  '${access.expiresAt!.day}/${access.expiresAt!.month}/${access.expiresAt!.year}'),

            SizedBox(height: 12),

            // Action Buttons
            _buildAccessActionButtons(access),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessBadge(String accessLevel) {
    final color = controller.getAccessLevelColor(accessLevel);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        controller.getAccessLevelText(accessLevel),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAccessDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Color(0xFF718096),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessActionButtons(CaseAccess access) {
    return Row(
      children: [
        // Edit Permissions Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showEditPermissionsSheet(access),
            icon: Icon(Icons.edit, size: 16),
            label: Text('Edit Permissions'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF1A365D),
              side: BorderSide(color: Color(0xFF1A365D)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        SizedBox(width: 8),

        // Revoke Access Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => controller.revokeCaseAccess(access.kase.id),
            icon: Icon(Icons.remove_circle_outline, size: 16, color: Colors.red),
            label: Text('Revoke', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditPermissionsSheet(CaseAccess access) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Edit Permissions',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A365D),
              ),
            ),
            SizedBox(height: 8),
            Text(
              access.kase.title,
              style: GoogleFonts.poppins(color: Color(0xFF718096)),
            ),
            SizedBox(height: 20),

            // Permission Options
            _buildPermissionOption('Read Only', 'read', access.accessLevel),
            _buildPermissionOption('Read & Write', 'write', access.accessLevel),
            _buildPermissionOption('No Access', 'none', access.accessLevel),

            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF1A365D),
                      side: BorderSide(color: Color(0xFF1A365D)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateCaseAccess(access.kase.id, controller.selectedAccessLevel.value);
                      NavigatorService.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBg,
                      foregroundColor: AppColors.buttonForeground,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: XText('Update', bold: true),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionOption(String label, String level, String currentLevel) {
    return Obx(() => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.setAccessLevel(level),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: controller.selectedAccessLevel.value == level
                ? controller.getAccessLevelColor(level).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: controller.selectedAccessLevel.value == level
                  ? controller.getAccessLevelColor(level)
                  : Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Icon(
                controller.selectedAccessLevel.value == level
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: controller.selectedAccessLevel.value == level
                    ? controller.getAccessLevelColor(level)
                    : Color(0xFFCBD5E0),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              if (currentLevel == level)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A365D),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Current',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildEmptyAccessState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 80,
            color: Color(0xFFCBD5E0),
          ),
          SizedBox(height: 16),
          Text(
            'No Case Access',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          Text(
            'Grant access to cases for this associate lawyer',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFFA0AEC0),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: controller.showGrantAccessSheet,
            icon: Icon(Icons.add),
            label: Text('Grant First Access'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonBg,
              foregroundColor: AppColors.buttonForeground,
            ),
          ),
        ],
      ),
    );
  }
}