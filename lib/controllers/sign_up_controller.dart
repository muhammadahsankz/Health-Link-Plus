import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:health_link_plus/views/otp_page.dart';
import 'package:health_link_plus/widgets/toast_widget.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool obsecurePassword = true.obs;
  RxBool obsecureConfirmPassword = true.obs;
  // Controllers for text fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Selected role
  var selectedRole = 'Patient'.obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  /// Placeholder function to send OTP
  Future<void> sendOtp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;

      final response = await ApiServices.postRequest(
        url: AppUrls.sendOtp,
        payload: {"email": email.trim()},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 400) {
        ToastWidget.show(
          Get.context!,
          message: data['message'],
          type: ToastType.error,
        );
        return;
      }

      if (response.statusCode == 200) {
        // Navigate to OTP page
        Get.to(
          () =>
              OtpPage(name: name, email: email, password: password, role: role),
        );
        ToastWidget.show(
          Get.context!,
          message: 'Otp sent successfully',
          type: ToastType.success,
        );
      }
    } catch (error) {
      ToastWidget.show(
        Get.context!,
        message: 'Error sending OTP',
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// On Sign Up button pressed
  void onSignUp() {
    if (formKey.currentState!.validate()) {
      sendOtp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedRole.value,
      );
    }
  }

  /// Change role selection
  void setRole(String role) => selectedRole.value = role;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Field validators
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty)
      return "Please enter your full name";
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Please enter your email";
    if (!EmailValidator.validate(value.trim()))
      return "Please enter a valid email";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter a password";
    if (value.length < 6) return "Password must be at least 6 characters";
    // if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)').hasMatch(value)) {
    //   return "Password must contain uppercase, lowercase, and a number";
    // }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return "Please confirm your password";
    if (value != passwordController.text) return "Passwords do not match";
    return null;
  }
}
