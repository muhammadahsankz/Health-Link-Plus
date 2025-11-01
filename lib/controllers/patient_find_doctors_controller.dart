import 'dart:convert';
import 'package:get/get.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:health_link_plus/widgets/toast_widget.dart';

class PatientFindDoctorsController extends GetxController {
  var doctors = <Map<String, dynamic>>[].obs;
  var filteredDoctors = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        url: AppUrls.getAllDoctorsListForPatient,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        doctors.value = List<Map<String, dynamic>>.from(data['doctors']);
        filteredDoctors.assignAll(doctors);
      }
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.assignAll(doctors);
    } else {
      final lower = query.toLowerCase();
      filteredDoctors.assignAll(
        doctors.where((doc) {
          final name = (doc['name'] ?? '').toLowerCase();
          final specialization = (doc['specialization'] ?? '').toLowerCase();
          return name.contains(lower) || specialization.contains(lower);
        }),
      );
    }
  }

  void bookAppointment(Map<String, dynamic> doctor) {
    ToastWidget.show(
      Get.context!,
      message: "Booking with ${doctor['name']} coming soon!",
      type: ToastType.success,
    );
  }
}
