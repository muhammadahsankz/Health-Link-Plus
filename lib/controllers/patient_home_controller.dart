import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientHomeController extends GetxController {
  var selectedIndex = 0.obs;
  void changePage(int index) => selectedIndex.value = index;

  final TextEditingController searchController = TextEditingController();

  // Dummy doctor data
  final List<Map<String, dynamic>> allDoctors = [
    {
      'name': 'Dr. Ahsan Khan',
      'specialization': 'Cardiologist',
      'clinic': 'City Heart Clinic',
    },
    {
      'name': 'Dr. Sara Malik',
      'specialization': 'Dermatologist',
      'clinic': 'Glow Skin Center',
    },
    {
      'name': 'Dr. Imran Rafiq',
      'specialization': 'Dentist',
      'clinic': 'Smile Dental Care',
    },
  ];

  var filteredDoctors = <Map<String, dynamic>>[].obs;
  var appointments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    filteredDoctors.assignAll(allDoctors);
    super.onInit();
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.assignAll(allDoctors);
    } else {
      filteredDoctors.assignAll(
        allDoctors
            .where(
              (doctor) =>
                  doctor['name'].toLowerCase().contains(query.toLowerCase()) ||
                  doctor['specialization'].toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList(),
      );
    }
  }

  void bookAppointment(Map<String, dynamic> doctor) {
    appointments.add({
      'doctor': doctor['name'],
      'date': '2025-11-02',
      'time': '10:30 AM',
      'status': 'Pending',
    });

    Get.snackbar(
      "Appointment Requested",
      "Your appointment with ${doctor['name']} is pending approval.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
    );
  }
}
