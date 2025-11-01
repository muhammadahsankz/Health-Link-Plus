import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/controllers/patient_home_controller.dart';
import 'package:health_link_plus/utils/app_colors.dart';
import 'package:health_link_plus/views/patient_appointments_page.dart';
import 'package:health_link_plus/views/patient_find_doctors_page.dart';
import 'package:health_link_plus/views/profile_page.dart';

class PatientHomepage extends StatelessWidget {
  const PatientHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientHomeController());

    final pages = [
      // _DashboardSection(controller),
      PatientFindDoctorsPage(),
      PatientAppointmentPage(controller: controller),
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
                  "Patient Panel",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                // _buildNavItem(controller, 0, Icons.dashboard, "Dashboard"),
                _buildNavItem(controller, 0, Icons.search, "Find Doctors"),
                _buildNavItem(controller, 1, Icons.event, "My Appointments"),
                _buildNavItem(controller, 2, Icons.person, "Profile"),
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
    PatientHomeController controller,
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

// 🩵 Dashboard Section
class _DashboardSection extends StatelessWidget {
  final PatientHomeController controller;
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
            "Welcome!",
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Search for doctors and book appointments easily.",
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
                  "Quick Actions:",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("✔ Search for your doctor"),
                const Text("✔ Book appointment online"),
                const Text("✔ Manage your upcoming visits"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
