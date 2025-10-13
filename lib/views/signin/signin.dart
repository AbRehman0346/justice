import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'signin-controller.dart';

class SigninScreen extends StatelessWidget {
  final SignInController controller = Get.put(SignInController());
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          child: Stack(
            children: [
              // Background Design Elements
              _buildBackground(),

              // Content
              SafeArea(
                child: SizedBox(
                  height: Get.height,
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Welcome Back Section
                        _buildWelcomeSection(),

                        // upper part, form and signup button.
                        Column(
                          children: [
                            SizedBox(height: 70),

                            // Signin Form
                            _buildSigninForm(),

                            SizedBox(height: 16),

                            // Remember Me & Forgot Password
                            _buildRememberForgotSection(),

                            SizedBox(height: 16),

                            // Signin Button
                            _buildSigninButton(),
                          ],
                        ),
                        // lower part, divider, social logins and signup page button.
                        Column(
                          children: [
                            SizedBox(height: 30),

                            // Social Login Options
                            _buildSocialLogin(),

                            SizedBox(height: 30),

                            // Signup Link
                            _buildSignupLink(),

                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
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
    return Column(
      children: [
        // Top curved background
        Container(
          height: Get.height * 0.25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A365D),
                Color(0xFF2D3748),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Justice Logo/Badge
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.gavel_rounded,
                size: 28,
                color: Color(0xFF1A365D),
              ),
            ),
            SizedBox(width: 20),
            Text(
              'Welcome Back,',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        Text(
          'Sign in to continue your legal journey',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),

        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSigninForm() {
    return Obx(() => Column(
      children: [
        // Email/Phone Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: emailPhoneController,
            onChanged: (value) => controller.emailOrPhone.value = value,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.poppins(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Email or Phone Number',
              hintStyle: GoogleFonts.poppins(color: Color(0xFFA0AEC0)),
              prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF4A5568)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),

        SizedBox(height: 20),

        // Password Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: passwordController,
            onChanged: (value) => controller.password.value = value,
            obscureText: !controller.isPasswordVisible.value,
            style: GoogleFonts.poppins(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: GoogleFonts.poppins(color: Color(0xFFA0AEC0)),
              prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF4A5568)),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value ?
                  Icons.visibility : Icons.visibility_off,
                  color: Color(0xFF4A5568),
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildRememberForgotSection() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember Me
        Row(
          children: [
            GestureDetector(
              onTap: controller.toggleRememberMe,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Color(0xFFCBD5E0)),
                  color: controller.isRememberMe.value ?
                  Color(0xFF1A365D) : Colors.transparent,
                ),
                child: controller.isRememberMe.value
                    ? Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Remember me',
              style: GoogleFonts.poppins(
                color: Color(0xFF4A5568),
                fontSize: 14,
              ),
            ),
          ],
        ),

        // Forgot Password
        GestureDetector(
          onTap: controller.navigateToForgotPassword,
          child: Text(
            'Forgot Password?',
            style: GoogleFonts.poppins(
              color: Color(0xFF1A365D),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildSigninButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: controller.signIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1A365D),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Color(0xFF1A365D).withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(color: Color(0xFFCBD5E0)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or continue with',
                style: GoogleFonts.poppins(
                  color: Color(0xFF718096),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: Color(0xFFCBD5E0)),
            ),
          ],
        ),

        SizedBox(height: 20),

        // Social Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: FontAwesome.google,
              color: Color(0xFFDB4437),
            ),
            SizedBox(width: 20),
            _buildSocialButton(
              icon: FontAwesome.apple,
              color: Color(0xFF000000),
            ),
            SizedBox(width: 20),
            _buildSocialButton(
              icon: FontAwesome.linkedin,
              color: Color(0xFF0077B5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({required IconData icon, required Color color}) {
    return GestureDetector(
      onTap: () {
        // Handle social login
        Get.snackbar(
          'Coming Soon',
          'Social login feature will be available soon',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(color: Color(0xFFE2E8F0)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildSignupLink() {
    return Center(
      child: GestureDetector(
        onTap: controller.navigateToSignup,
        child: RichText(
          text: TextSpan(
            text: 'Don\'t have an account? ',
            style: GoogleFonts.poppins(
              color: Color(0xFF718096),
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: 'Sign Up',
                style: GoogleFonts.poppins(
                  color: Color(0xFF1A365D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailPhoneController.dispose();
    passwordController.dispose();
  }
}