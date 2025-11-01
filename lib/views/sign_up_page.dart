import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/controllers/sign_up_controller.dart';
import 'package:health_link_plus/views/login_page.dart';
import 'package:health_link_plus/widgets/button_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: FadeTransition(
          opacity: AlwaysStoppedAnimation(1),
          child: Container(
            width: screenWidth > 600 ? 480 : screenWidth * 0.9,
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Name
                    _buildTextField(
                      controller: controller.nameController,
                      label: "Full Name",
                      icon: Icons.person_outline,
                      validator: controller.validateName,
                    ),
                    const SizedBox(height: 18),

                    // Email
                    _buildTextField(
                      controller: controller.emailController,
                      label: "Email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                    ),
                    const SizedBox(height: 18),

                    // Password
                    _buildTextField(
                      controller: controller.passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      isPassword: controller.obsecurePassword.value,
                      isObscure: controller.obsecurePassword,
                      validator: controller.validatePassword,
                      onSuffixIconPressed: () {
                        controller.obsecurePassword.value =
                            !controller.obsecurePassword.value;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Confirm Password
                    _buildTextField(
                      controller: controller.confirmPasswordController,
                      label: "Confirm Password",
                      icon: Icons.lock_outline,
                      isPassword: controller.obsecureConfirmPassword.value,
                      validator: controller.validateConfirmPassword,
                      isObscure: controller.obsecureConfirmPassword,
                      onSuffixIconPressed: () {
                        controller.obsecureConfirmPassword.value =
                            !controller.obsecureConfirmPassword.value;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Role Selector
                    Obx(() => _buildRoleSelector(controller)),
                    const SizedBox(height: 30),

                    // Sign Up Button
                    ButtonWidget(
                      text: 'Sign Up',
                      isLoading: controller.isLoading,
                      onPressed: controller.onSignUp,
                    ),

                    const SizedBox(height: 20),

                    // Already have account
                    GestureDetector(
                      onTap: () => Get.to(() => const LoginPage()),
                      child: const Text(
                        "Already have an account? Log In",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ UPDATED: Handles both normal and password fields correctly
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    RxBool? isObscure,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onSuffixIconPressed,
  }) {
    // Inner field builder
    Widget buildField(bool obscure) {
      return TextFormField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onSuffixIconPressed,
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.blueAccent,
                  ),
                )
              : null,
        ),
      );
    }

    // ✅ Use Obx only if it’s a reactive password field
    if (isPassword && isObscure != null) {
      return Obx(() => buildField(isObscure.value));
    } else {
      return buildField(false);
    }
  }

  Widget _buildTextField1({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onSuffixIconPressed,
  }) {
    return Obx(() {
      return TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onSuffixIconPressed,
                  icon: const Icon(Icons.remove_red_eye_outlined),
                )
              : null,
        ),
      );
    });
  }

  Widget _buildRoleSelector(SignUpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Role",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),

        // Role Cards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRoleCard(
              role: "Patient",
              icon: Icons.person_outline,
              controller: controller,
              color: Colors.blueAccent,
            ),
            _buildRoleCard(
              role: "Doctor",
              icon: Icons.medical_services_outlined,
              controller: controller,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String role,
    required IconData icon,
    required SignUpController controller,
    required Color color,
  }) {
    final bool isSelected = controller.selectedRole.value == role;

    return GestureDetector(
      onTap: () => controller.setRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade600,
              size: 34,
            ),
            const SizedBox(height: 10),
            Text(
              role,
              style: TextStyle(
                color: isSelected ? color : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector1(SignUpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Role",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ["Patient", "Doctor"].map((role) {
            final bool isSelected = controller.selectedRole.value == role;
            return GestureDetector(
              onTap: () => controller.setRole(role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 25,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueAccent, width: 1.5),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
