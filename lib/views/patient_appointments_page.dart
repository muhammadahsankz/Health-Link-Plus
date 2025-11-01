import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:health_link_plus/controllers/patient_home_controller.dart';
import 'package:health_link_plus/utils/app_colors.dart';

class PatientAppointmentPage extends StatelessWidget {
  final PatientHomeController controller;
  const PatientAppointmentPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('Appointments'),
      padding: const EdgeInsets.all(24),
      child: 1 == 1
          ? const Center(
              child: Text(
                "Coming Soon !",
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Appointments",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Obx(() {
                  if (controller.appointments.isEmpty) {
                    return const Center(child: Text("No appointments yet."));
                  }
                  return Column(
                    children: controller.appointments.map((appt) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(blurRadius: 5, color: Colors.black12),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Doctor: ${appt['doctor']}"),
                                Text("Date: ${appt['date']}"),
                                Text("Time: ${appt['time']}"),
                              ],
                            ),
                            Text(
                              appt['status'],
                              style: TextStyle(
                                color: appt['status'] == "Accepted"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
    );
  }
}
