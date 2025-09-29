import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justice/res/colors/app-colors.dart';
import 'add-contact-controller.dart';

class AddContactScreen extends StatelessWidget {
  final AddContactController controller = Get.put(AddContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      appBar: AppBar(
        title: Text('Add Contact', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1A365D)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Contact Information'),

            _buildTextField('Full Name', 'Enter full name', controller.name, isRequired: true),
            SizedBox(height: 16),

            _buildTextField('Contact Number', 'Enter phone number', controller.contactNumber,
                isRequired: true, keyboardType: TextInputType.phone),
            SizedBox(height: 16),

            _buildTextField('Email (Optional)', 'Enter email address', controller.email,
                keyboardType: TextInputType.emailAddress),
            SizedBox(height: 16),

            _buildDropdown('Contact Type', controller.type.value,
                controller.contactTypes, controller.setContactType, false),

            SizedBox(height: 40),
            _buildSaveButton(),
            SizedBox(height: 20),
          ],
        )),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A365D),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, RxString value,
      {bool isRequired = false, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
            if (isRequired) Text(' *', style: GoogleFonts.poppins(color: Colors.red)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: TextField(
            onChanged: (text) => value.value = text,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String label,
      String value,
      List<String> options,
      Function(String) onChanged,
      [
        bool enabled = true,
  ]
    ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option.capitalizeFirst!),
              );
            }).toList(),
            onChanged: !enabled ? null : (newValue) => onChanged(newValue!),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: controller.saveContact,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bg[0],
          foregroundColor: AppColors.foreground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Obx(() => controller.isLoading.value
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
            : Text('Save Contact', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600))),
      ),
    );
  }
}