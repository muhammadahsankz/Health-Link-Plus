import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:health_link_plus/widgets/toast_widget.dart';

class DoctorCompleteProfileController extends GetxController {
  var specialization = ''.obs;
  var phone = ''.obs;
  var experience = ''.obs;
  var qualifications = ''.obs;
  var gender = ''.obs;
  var age = ''.obs;
  var bio = ''.obs;

  var isLoading = false.obs;
  var isFetching = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctorProfile();
  }

  Future<void> fetchDoctorProfile() async {
    try {
      isFetching.value = true;
      final userId = AuthHelper.getUserId();

      final response = await ApiServices.postRequest(
        url: AppUrls.getDoctorProfile,
        payload: {"userId": userId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final doctor = data['doctor'];

        if (doctor != null) {
          specialization.value = doctor['specialization'] ?? '';
          phone.value = doctor['phone'] ?? '';
          experience.value = doctor['experience'] ?? '';
          qualifications.value = doctor['qualifications'] ?? '';
          gender.value = doctor['gender'] ?? '';
          age.value = doctor['age'] ?? '';
          bio.value = doctor['bio'] ?? '';
        }
      } else {
        debugPrint("Failed to fetch doctor details");
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> saveProfileToServer() async {
    try {
      isLoading.value = true;

      final payload = {
        "userId": AuthHelper.getUserId(),
        "specialization": specialization.value,
        "qualifications": qualifications.value,
        "experience": experience.value,
        "phone": phone.value,
        "age": age.value,
        "gender": gender.value,
        "bio": bio.value,
      };

      final response = await ApiServices.postRequest(
        url: AppUrls.completeDoctorProfile,
        payload: payload,
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          Get.context!,
          message: "Profile updated successfully",
          type: ToastType.success,
        );
      } else {
        ToastWidget.show(
          Get.context!,
          message: "Failed to update profile",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error saving profile: $e");
      ToastWidget.show(
        Get.context!,
        message: "Error Updating Profile.",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
