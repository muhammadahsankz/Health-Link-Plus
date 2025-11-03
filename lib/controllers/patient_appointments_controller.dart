import 'dart:convert';
import 'package:get/get.dart';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:health_link_plus/widgets/toast_widget.dart';

class PatientAppointmentsController extends GetxController {
  var appointments = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      final patientId = AuthHelper.getUserId();

      final response = await ApiServices.postRequest(
        url: AppUrls.getPatientAppointmentsList,
        payload: {"patientId": patientId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        appointments.value = List<Map<String, dynamic>>.from(
          data['appointments'],
        );
      } else {
        final data = jsonDecode(response.body);
        ToastWidget.show(
          Get.context!,
          message: data['message'] ?? "Failed to fetch appointments.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error fetching appointments: $e");
      ToastWidget.show(
        Get.context!,
        message: "Error fetching appointments.",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
