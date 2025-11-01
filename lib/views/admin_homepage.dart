import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/controllers/admin_home_controller.dart';
import 'package:health_link_plus/views/admin_doctors_page.dart';
import 'package:health_link_plus/views/admin_patients_page.dart';
import 'package:health_link_plus/utils/app_colors.dart';
import 'package:health_link_plus/views/profile_page.dart';
import 'package:health_link_plus/widgets/button_widget.dart';

class AdminHomepage extends StatelessWidget {
  const AdminHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminHomeController());

    final pages = [
      _DashboardSection(controller),
      // const AdminAppointmentsPage(),
      AdminDoctorsPage(),
      AdminPatientsPage(),
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
                  "Admin Panel",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _buildNavItem(controller, 0, Icons.dashboard, "Dashboard"),
                // _buildNavItem(controller, 1, Icons.event, "Appointments"),
                _buildNavItem(
                  controller,
                  1,
                  Icons.medical_information,
                  "Doctors",
                ),
                _buildNavItem(controller, 2, Icons.people, "Patients"),
                _buildNavItem(controller, 3, Icons.person, "Profile"),
              ],
            ),
          ),

          // Main content area
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
    AdminHomeController controller,
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
  final AdminHomeController controller;
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
            "Users Overview",
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () =>
                _buildUserTable("Pending Users", controller.pendingUsers, true),
          ),
          const SizedBox(height: 30),
          Obx(
            () => _buildUserTable(
              "Approved Users",
              controller.approvedUsers,
              false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTable(
    String title,
    List<Map<String, dynamic>> data,
    bool isPendingUserList,
  ) {
    // if (data.isEmpty) {
    //   return Text("No users found.", style: TextStyle(color: AppColors.black));
    // }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          data.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Icon(
                        Icons.group_off,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No users found",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Email")),
                      DataColumn(label: Text("Role")),
                      DataColumn(label: Text("Status")),
                      if (isPendingUserList) DataColumn(label: Text("Action")),
                    ],
                    rows: data
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(Text(e['name'] ?? 'N/A')),
                              DataCell(Text(e['email'] ?? 'N/A')),
                              DataCell(Text(e['role'] ?? 'N/A')),
                              DataCell(Text(e['approvalStatus'] ?? 'N/A')),
                              if (isPendingUserList)
                                DataCell(
                                  ButtonWidget(
                                    text: 'Approve',
                                    isLoading: controller.isLoading,
                                    onPressed: () async {
                                      await controller.approveUser(e['id']);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }
}
