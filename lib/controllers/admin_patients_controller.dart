import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_services.dart';
import '../../utils/app_urls.dart';

class AdminPatientsController extends GetxController {
  var isLoading = false.obs;
  var patients = <Map<String, dynamic>>[].obs;
  var filteredPatients = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        url: AppUrls.getPatientsList,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List fetchedList = List.from(data['users'] ?? []);
        patients.value = fetchedList
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
        filteredPatients.value = List.from(patients);
      }
    } catch (e) {
      debugPrint("Error fetching patients: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterPatients(String query) {
    if (query.isEmpty) {
      filteredPatients.value = List.from(patients);
    } else {
      filteredPatients.value = patients
          .where(
            (p) => p['name'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    }
  }
}
