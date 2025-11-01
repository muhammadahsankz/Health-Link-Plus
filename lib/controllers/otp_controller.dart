import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:health_link_plus/views/login_page.dart';
import 'package:health_link_plus/widgets/toast_widget.dart';

class OtpController extends GetxController {
  RxBool isLoading = false.obs;

  final TextEditingController otpCodeController = TextEditingController();

  // This function will handle OTP verification (mock for now)
  void verifyOtp({
    required String email,
    required String otp,
    required String name,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      final response = await ApiServices.postRequest(
        url: AppUrls.verifyOtp,
        payload: {"email": email.trim(), "otp": otp.trim()},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 400) {
        ToastWidget.show(
          Get.context!,
          message: data['message'] ?? 'Error Verifying OTP',
          type: ToastType.error,
        );
        return;
      }

      if (response.statusCode == 200) {
        final bool isAccountCreated = await createAccount(
          name: name,
          email: email,
          password: password,
          role: role,
        );
        if (isAccountCreated) {
          ToastWidget.show(
            Get.context!,
            message: 'Account Created Successfully.',
            type: ToastType.success,
          );
          Get.offAll(() => const LoginPage());
        } else {
          ToastWidget.show(
            Get.context!,
            message: 'Error Creating Account, Try again later.',
            type: ToastType.error,
          );
          Get.offAll(() => const LoginPage());
        }
      } else {
        ToastWidget.show(
          Get.context!,
          message: 'Error Verifying OTP',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint(error.toString());
      ToastWidget.show(
        Get.context!,
        message: 'Error Verifying OTP',
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  void resendOtp({required String email}) async {
    try {
      final response = await ApiServices.postRequest(
        url: AppUrls.sendOtp,
        payload: {"email": email.trim()},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 400) {
        ToastWidget.show(
          Get.context!,
          message: data['message'] ?? 'Error sending OTP',
          type: ToastType.error,
        );
        return;
      }

      if (response.statusCode == 200) {
        ToastWidget.show(
          Get.context!,
          message: 'Sent OTP again, check your email to verify.',
          type: ToastType.success,
        );
      } else {
        ToastWidget.show(
          Get.context!,
          message: 'Error sending OTP',
          type: ToastType.error,
        );
      }
    } catch (error) {
      ToastWidget.show(
        Get.context!,
        message: 'Error sending OTP',
        type: ToastType.error,
      );
    }
  }

  /// ✅ Create account function
  Future<bool> createAccount({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await ApiServices.postRequest(
        url: AppUrls.signup,
        payload: {
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void onClose() {
    otpCodeController.dispose();
    super.onClose();
  }
}
