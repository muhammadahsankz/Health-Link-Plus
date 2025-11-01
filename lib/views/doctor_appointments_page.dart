import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctor_home_controller.dart';
import '../../utils/app_colors.dart';

class DoctorAppointmentsPage extends StatelessWidget {
  const DoctorAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorHomeController>();

    return 1 == 1
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
        : Obx(
            () => SingleChildScrollView(
              key: const ValueKey('Appointments'),
              padding: const EdgeInsets.all(24),
              child: Container(
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
                      "Appointments",
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text("Patient")),
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Time")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Action")),
                      ],
                      rows: List.generate(controller.appointments.length, (
                        index,
                      ) {
                        final appt = controller.appointments[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(appt['patient'] ?? '')),
                            DataCell(Text(appt['date'] ?? '')),
                            DataCell(Text(appt['time'] ?? '')),
                            DataCell(Text(appt['status'] ?? '')),
                            DataCell(
                              appt['status'] == 'Pending'
                                  ? ElevatedButton(
                                      onPressed: () =>
                                          controller.acceptAppointment(index),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.blue,
                                      ),
                                      child: const Text(
                                        "Accept",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      "Accepted",
                                      style: TextStyle(color: Colors.green),
                                    ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
