import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_services.dart';
import '../../utils/app_urls.dart';

class AdminDoctorsController extends GetxController {
  var isLoading = false.obs;
  var doctors = <Map<String, dynamic>>[].obs;
  var filteredDoctors = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        url: AppUrls.getDoctorsList,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List fetchedList = List.from(data['users'] ?? []);
        doctors.value = fetchedList
            .map(
              (u) => {
                'id': u['_id'] ?? 'N/A',
                'name': u['name'] ?? 'N/A',
                'email': u['email'] ?? 'N/A',
                'role': u['role'] ?? 'N/A',
                'status': u['approvalStatus'] ?? 'N/A',
              },
            )
            .toList();

        // Initialize filtered list
        filteredDoctors.value = List.from(doctors);
      }
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.value = List.from(doctors);
    } else {
      filteredDoctors.value = doctors
          .where(
            (d) => d['name'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    }
  }
}
