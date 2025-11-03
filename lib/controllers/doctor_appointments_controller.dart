import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'dart:convert';
import 'package:health_link_plus/widgets/toast_widget.dart';
import 'package:http/http.dart' as http;

class DoctorAppointmentsController extends GetxController {
  var appointments = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  RxBool isCreateMeetingLoading = false.obs;
  var acceptLoadingMap = <String, bool>{}.obs;

  final String doctorId = AuthHelper.getUserId() ?? "";

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.postRequest(
        url: AppUrls.getDoctorAppointmentsList,
        payload: {"doctorId": doctorId},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        appointments.assignAll(
          List<Map<String, dynamic>>.from(data["appointments"] ?? []),
        );
      }
    } catch (e) {
      debugPrint("Error fetching appointments: $e");
      ToastWidget.show(
        Get.context!,
        message: "Error fetching appointments",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptAppointment(String appointmentId) async {
    if (appointmentId.isEmpty) return;

    try {
      acceptLoadingMap[appointmentId] = true;
      final response = await ApiServices.postRequest(
        url: AppUrls.acceptAppointment,
        payload: {"appointmentId": appointmentId, "doctorId": doctorId},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        ToastWidget.show(
          Get.context!,
          message: "Appointment accepted successfully",
          type: ToastType.success,
        );
        fetchAppointments();
      } else {
        ToastWidget.show(
          Get.context!,
          message: data["message"] ?? "Failed to accept appointment",
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        Get.context!,
        message: "Something went wrong",
        type: ToastType.error,
      );
    } finally {
      acceptLoadingMap[appointmentId] = false;
      acceptLoadingMap.refresh();
    }
  }

  // Create zoom meeting
  Future<String?> createZoomMeeting(
    String appointmentId,
    String doctorEmail,
    String doctorName,
  ) async {
    try {
      isCreateMeetingLoading.value = true;
      final response = await http.post(
        Uri.parse(AppUrls.createMeeting),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'topic': 'Consultation for Appointment $appointmentId',
          'start_time': DateTime.now().toUtc().toIso8601String(),
          'duration': 30,
          'doctorEmail': doctorEmail,
          'appointmentId': appointmentId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final meetingId = data['meetingId'].toString();

        // ✅ Optionally save this meetingId in DB for the patient
        return meetingId;
      } else {
        Get.snackbar("Error", "Failed to create meeting");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    } finally {
      isCreateMeetingLoading.value = false;
    }
  }
}
