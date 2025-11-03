import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/controllers/patient_find_doctors_controller.dart';
import 'package:health_link_plus/utils/app_colors.dart';
import 'package:health_link_plus/widgets/button_widget.dart';

class PatientFindDoctorsPage extends StatelessWidget {
  PatientFindDoctorsPage({super.key});

  final controller = Get.put(PatientFindDoctorsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          key: const ValueKey('FindDoctors'),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Find Doctors",
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // 🔍 Search Bar
              TextField(
                controller: controller.searchController,
                onChanged: controller.filterDoctors,
                decoration: InputDecoration(
                  hintText: "Search by name or specialization",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.blue, width: 1.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 👩‍⚕️ Doctor List
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final doctors = controller.filteredDoctors;
                if (doctors.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No doctors found.",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: doctors.map((doctor) {
                    final clinic = doctor['clinic'];
                    final timings = clinic != null
                        ? clinic['weeklyTimings']
                        : null;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 👤 Avatar
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppColors.blue.withOpacity(
                                    0.1,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: AppColors.blue,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Doctor Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor['name'] ?? 'Unknown',
                                        style: TextStyle(
                                          color: AppColors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        doctor['specialization'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${doctor['experience'] ?? '0'} years experience",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        doctor['qualifications'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 25),

                            // 🏥 Clinic Info
                            if (clinic != null) ...[
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_hospital_outlined,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      clinic['clinicName'] ?? 'N/A',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${clinic['clinicAddress'] ?? ''}, ${clinic['clinicCity'] ?? ''}",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: Colors.blueGrey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(clinic['clinicContact'] ?? ''),
                                ],
                              ),

                              // ⏰ Timings Expansion
                              const SizedBox(height: 12),
                              ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                title: const Text(
                                  "View Weekly Timings",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                children: [
                                  if (timings != null)
                                    ...timings.entries.map((entry) {
                                      final day = entry.key;
                                      // final open =
                                      //     entry.value['open'] ?? '--:--';
                                      // final close =
                                      //     entry.value['close'] ?? '--:--';
                                      final open = formatTime(
                                        entry.value['open'],
                                      );
                                      final close = formatTime(
                                        entry.value['close'],
                                      );
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(day),
                                            Text("$open - $close"),
                                          ],
                                        ),
                                      );
                                    }).toList()
                                  else
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("No timings available"),
                                    ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 12),
                            Center(
                              child: ButtonWidget(
                                text: 'Request an Appointment',
                                isLoading:
                                    controller.isRequestAppointmentLoading,
                                onPressed: () =>
                                    controller.requestAnAppointment(doctor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Function
  String formatTime(String? time) {
    if (time == null || time.isEmpty) return 'Closed';
    try {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour == 0) hour = 12;
      if (hour > 12) hour -= 12;

      final minuteStr = minute.toString().padLeft(2, '0');
      return '$hour:$minuteStr $period';
    } catch (_) {
      return 'Closed';
    }
  }
}
