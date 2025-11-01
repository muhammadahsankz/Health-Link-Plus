import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/controllers/doctor_home_controller.dart';
import 'package:health_link_plus/utils/app_colors.dart';
import 'package:health_link_plus/views/doctor_add_clinic_page.dart';
import 'package:health_link_plus/views/doctor_appointments_page.dart';
import 'package:health_link_plus/views/doctor_complete_your_profile_page.dart';
import 'package:health_link_plus/views/profile_page.dart';

class DoctorHomepage extends StatelessWidget {
  const DoctorHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorHomeController());

    final pages = [
      // _DashboardSection(controller),
      DoctorAppointmentsPage(),
      DoctorCompleteYourProfilePage(),
      DoctorAddClinicPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: AppColors.blue,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  "Doctor Panel",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                // _buildNavItem(controller, 0, Icons.dashboard, "Dashboard"),
                _buildNavItem(controller, 0, Icons.event, "Appointments"),
                _buildNavItem(controller, 1, Icons.person, "Complete Profile"),
                _buildNavItem(
                  controller,
                  2,
                  Icons.local_hospital,
                  "Add Clinic",
                ),
                _buildNavItem(controller, 3, Icons.person, "Profile"),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pages[controller.selectedIndex.value],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    DoctorHomeController controller,
    int index,
    IconData icon,
    String title,
  ) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return InkWell(
        onTap: () => controller.changePage(index),
        child: Container(
          color: isSelected
              ? AppColors.white.withOpacity(0.1)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.white),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DashboardSection extends StatelessWidget {
  final DoctorHomeController controller;
  const _DashboardSection(this.controller);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('Dashboard'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Doctor!",
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Complete your profile and add your clinic details to start accepting appointments.",
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(blurRadius: 5, color: Colors.black12),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Next Steps:",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("✔ Fill your profile details"),
                const Text("✔ Add your clinic & timings"),
                const Text("✔ Accept patient appointments"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
