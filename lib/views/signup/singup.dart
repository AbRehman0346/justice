import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'signup-controller.dart';

class SignupScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: Get.height,
          child: Stack(
            children: [
              // Background Design Elements
              _buildBackground(),

              // Content
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Back Button and Title
                      _buildHeader(),

                      SizedBox(height: 30),

                      // Signup Form
                      _buildSignupForm(),

                      SizedBox(height: 30),

                      // Signup Button
                      _buildSignupButton(),

                      SizedBox(height: 20),

                      // Login Link
                      _buildLoginLink(),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Color(0xFFE8F4FD),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF2D3748)),
          ),
        ),

        SizedBox(width: 10),

        Text(
          'Create Account',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A365D),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Obx(() => Column(
      children: [
        _buildTextField(
          icon: Icons.person_outline,
          hintText: 'Full Name',
          prefixIcon: Icons.person,
        ),

        SizedBox(height: 16),

        _buildTextField(
          icon: Icons.phone_outlined,
          hintText: 'Phone Number',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),

        SizedBox(height: 16),

        _buildTextField(
          icon: Icons.email_outlined,
          hintText: 'Email Address',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: 16),

        _buildTextField(
          icon: Icons.badge_outlined,
          hintText: 'Assigned Number',
          prefixIcon: Icons.numbers,
          keyboardType: TextInputType.number,
        ),

        SizedBox(height: 16),

        // User Type Dropdown
        _buildDropdown(
          value: controller.selectedUserType.value,
          items: controller.userTypes,
          hint: 'Select Type',
          icon: Icons.work_outline,
          onChanged: controller.setUserType,
        ),

        SizedBox(height: 16),

        // Country Dropdown
        _buildDropdown(
          value: controller.selectedCountry.value,
          items: controller.countriesCities.keys.toList(),
          hint: 'Select Country',
          icon: Icons.public_outlined,
          onChanged: controller.setCountry,
        ),

        SizedBox(height: 16),

        // City Dropdown
        _buildDropdown(
          value: controller.selectedCity.value,
          items: controller.countriesCities[controller.selectedCountry.value] ?? [],
          hint: 'Select City',
          icon: Icons.location_city_outlined,
          onChanged: controller.setCity,
        ),

        SizedBox(height: 16),

        // Password Field
        _buildPasswordField(),
      ],
    ));
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFFF8FAFD),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Color(0xFFA0AEC0)),
          prefixIcon: Icon(prefixIcon, color: Color(0xFF4A5568)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFFF8FAFD),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        obscureText: !controller.isPasswordVisible.value,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: GoogleFonts.poppins(color: Color(0xFFA0AEC0)),
          prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF4A5568)),
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF4A5568),
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    ));
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xFFF8FAFD),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        icon: Icon(Icons.arrow_drop_down, color: Color(0xFF4A5568)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF4A5568)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: GoogleFonts.poppins(fontSize: 16)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }

  Widget _buildSignupButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.signUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2D3748),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Color(0xFF2D3748).withOpacity(0.3),
        ),
        child: controller.isLoading.value
            ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        )
            : Text(
          'Create Account',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ));
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => controller.pop(),
        child: RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            style: GoogleFonts.poppins(
              color: Color(0xFF718096),
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: 'Sign In',
                style: GoogleFonts.poppins(
                  color: Color(0xFF2D3748),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}