import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_constants.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:health_link_plus/views/account_approval_page.dart';
import 'package:health_link_plus/views/admin_homepage.dart';
import 'package:health_link_plus/views/doctor_homepage.dart';
import 'package:health_link_plus/views/login_page.dart';
import 'package:health_link_plus/views/patient_homepage.dart';
import 'package:health_link_plus/widgets/toast_widget.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool obsecurePassword = true.obs;

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;

      final response = await ApiServices.postRequest(
        url: AppUrls.login,
        payload: {"email": email.trim(), "password": password.trim()},
      );

      final data = jsonDecode(response.body);

      debugPrint(data.toString());

      // If account does not exist
      if (response.statusCode == 401) {
        ToastWidget.show(
          Get.context!,
          message: "No Account found with these credentials.",
          type: ToastType.error,
        );
        return; // 🚫 Stop here, don’t save token
      }

      /// ⚠️ If Doctor account is pending approval
      if (response.statusCode == 403 ||
          data['user']['approvalStatus'] ==
              AppConstants.approvalStatus.pending) {
        ToastWidget.show(
          Get.context!,
          message: "Your account is awaiting admin approval.",
          type: ToastType.error,
        );
        Get.offAll(() => const AccountApprovalPage());
        return; // 🚫 Stop here, don’t save token
      }

      /// ✅ If login successful
      if (response.statusCode == 200) {
        final user = data['user'];

        // Save token and user info
        await AuthHelper.saveLogin(
          token: data['token'],
          role: user['role'],
          userId: user['id'],
          name: user['name'],
          email: user['email'],
        );

        ToastWidget.show(
          Get.context!,
          message: "Login successful",
          type: ToastType.success,
        );

        // Navigate based on user role
        if (user['role'] == AppConstants.roles.admin) {
          Get.offAll(() => const AdminHomepage());
        } else if (user['role'] == AppConstants.roles.doctor) {
          Get.offAll(() => const DoctorHomepage());
        } else if (user['role'] == AppConstants.roles.patient) {
          Get.offAll(() => const PatientHomepage());
        } else {
          Get.offAll(() => const LoginPage());
        }
      } else {
        /// ❌ Handle general error
        ToastWidget.show(
          Get.context!,
          message: "Login failed.",
          type: ToastType.error,
        );
      }
    } catch (error) {
      if (kDebugMode) print("🔥 Login error: $error");
      ToastWidget.show(
        Get.context!,
        message: "Something went wrong. Please try again later.",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
