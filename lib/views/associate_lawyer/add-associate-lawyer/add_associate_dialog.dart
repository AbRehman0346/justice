import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:justice/models/user-model.dart';
import 'package:justice/res/navigation_service/NavigatorService.dart';
import 'package:justice/res/utils/xutils.dart';
import 'package:justice/temp_data/associatedCases.dart';
import '../../../models/associate_lawyer_model.dart';
import '_controller.dart';

class AddAssociateDialog extends StatelessWidget {
  final AddAssociateController controller = Get.put(AddAssociateController());
  final Function(AssociatedLinksModel)? afterAssociateAdded;

  AddAssociateDialog({super.key,
    this.afterAssociateAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(),

              // Search Section
              _buildSearchSection(),

              // User Found Section
              _buildUserFoundSection(),

              // Role Selection
              _buildRoleSection(),

              // Actions
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A365D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Add Associate Lawyer',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.close, color: Colors.white, size: 20),
          //   onPressed: () => Get.back(),
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find by Email or Phone',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A365D),
            ),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => controller.searchQuery.value = value,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter email address or phone number',
                      hintStyle: GoogleFonts.poppins(color: Color(0xFFA0AEC0)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                Obx(() => controller.isLoading.value
                    ? Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                    : IconButton(
                  icon: Icon(Icons.search, color: Color(0xFF1A365D)),
                  onPressed: controller.searchUser,
                )),
              ],
            ),
          ),
          Obx(() => controller.searchError.isNotEmpty
              ? Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              controller.searchError.value,
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          )
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildUserFoundSection() {
    return Obx(() => controller.foundUser.value != null
        ? Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF0FFF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF9AE6B4)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF1A365D).withOpacity(0.1),
              child: Icon(Icons.person, color: Color(0xFF1A365D)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.foundUser.value!.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A365D),
                    ),
                  ),
                  SizedBox(height: 4),
                  if (controller.foundUser.value!.email != null)
                    Text(
                      controller.foundUser.value!.email!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  if (controller.foundUser.value!.phoneNumber != null)
                    Text(
                      controller.foundUser.value!.phoneNumber!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  // Text(
                  //   controller.foundUser.value!.id,
                  //   style: GoogleFonts.poppins(
                  //     fontSize: 12,
                  //     color: Color(0xFF48BB78),
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red, size: 18),
              onPressed: controller.clearSearch,
            ),
          ],
        ),
      ),
    )
        : SizedBox.shrink());
  }

  Widget _buildRoleSection() {
    return Obx(() => controller.foundUser.value != null
        ? Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assign Role',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A365D),
            ),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonFormField<String>(
              initialValue: controller.selectedRole.value,
              items: controller.roleOptions.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (newValue) => controller.setRole(newValue!),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    )
        : SizedBox.shrink());
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Color(0xFF4A5568),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Obx(() => ElevatedButton(
              onPressed: controller.canAddAssociate ? _addAssociate : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A365D),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add Associate',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  void _addAssociate() {
    try{
      final associatedLink = controller.createAssociatedLink();

      if(associatedLink.associateLawyerId == UserModel.currentUser.id){
        throw Exception("You can't add yourself as an associate lawyer");
      }

      if(AssociatedCases().doesAssociationExists(associatedLink.lawyerId, associatedLink.associateLawyerId)){
        throw Exception("You have already added this lawyer as associate");
      }

      AssociatedCases.associatedCases.add(associatedLink);
      if(afterAssociateAdded != null){
        afterAssociateAdded!(associatedLink);
      }
      NavigatorService.pop();
      Get.snackbar(
        'Success',
        '${controller.foundUser.value!.name} added as ${controller.selectedRole.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }catch(e){
      XUtils().printSuppressedError(e, "AddAssociateDialog");
      Get.snackbar(
        'Error',
        e.toString().replaceFirst("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}