import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/controllers/patient_appointments_controller.dart';
import 'package:health_link_plus/controllers/video_call_controller.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_colors.dart';
import 'package:health_link_plus/utils/app_constants.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:health_link_plus/views/video_call_page.dart';
import 'package:intl/intl.dart';

class PatientAppointmentsPage extends StatelessWidget {
  const PatientAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<PatientAppointmentsController>(
      PatientAppointmentsController(),
    );

    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.appointments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "No appointments found.",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                    // boxShadow: const [
                    //   BoxShadow(blurRadius: 5, color: Colors.black12),
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Appointments",
                      //   style: TextStyle(
                      //     color: AppColors.blue,
                      //     fontSize: 22,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStatePropertyAll(
                            AppColors.blue.withOpacity(0.1),
                          ),
                          columns: const [
                            DataColumn(label: Text("Doctor")),
                            DataColumn(label: Text("Clinic")),
                            DataColumn(label: Text("Date")),
                            DataColumn(label: Text("Time")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Action")),
                          ],
                          rows: controller.appointments.map((appt) {
                            return DataRow(
                              cells: [
                                DataCell(Text(appt['doctor'] ?? '')),
                                DataCell(Text(appt['clinic'] ?? '')),
                                DataCell(
                                  Text(
                                    formatDate(appt['date']),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    formatTime(appt['time']),
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    appt['status'] ?? '',
                                    style: TextStyle(
                                      color:
                                          appt['status'] ==
                                              AppConstants
                                                  .appointmentStatus
                                                  .approved
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  TextButton(
                                    onPressed: () async {
                                      // Get.to(
                                      //   () => VideoCallPage(
                                      //     channelName: appt['id'] ?? '',
                                      //   ),
                                      // );

                                      // In patient appointment page
                                      // if (appointment.meetingId != null) {

                                      // ✅ FIRST GET MEETING ID FROM APPOINTMENT
                                      final response =
                                          await ApiServices.postRequest(
                                            url: AppUrls.getMeetingDetails,
                                            payload: {
                                              "appointmentId": appt['id'],
                                            },
                                          );

                                      if (response.statusCode == 200) {
                                        final data = jsonDecode(response.body);
                                        final meetingId =
                                            data['meeting']['meetingId']
                                                .toString();

                                        Get.to(
                                          () => VideoCallPage(
                                            meetingId: meetingId,
                                            role: "0", // attendee role
                                            userName:
                                                appt['patient'] ?? 'patient',
                                            userEmail:
                                                appt['patientEmail'] ??
                                                'patient@healthlinkplus.com',
                                          ),
                                        );
                                      } else {
                                        Get.snackbar(
                                          "Not Ready",
                                          "Doctor has not started the meeting yet",
                                        );
                                      }
                                      // } else {
                                      //   Get.snackbar("Not Ready", "Doctor has not started the meeting yet");
                                      // }
                                    },
                                    child: const Text("Start Call"),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  String formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final date = DateTime.parse(isoDate);
      final formatter = DateFormat(
        'EEE, MMM d, yyyy',
      ); // Example: Sat, Nov 2, 2025
      return formatter.format(date);
    } catch (_) {
      return isoDate;
    }
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return '';
    try {
      // If time already has AM/PM just return it
      if (time.toUpperCase().contains("AM") ||
          time.toUpperCase().contains("PM")) {
        return time;
      }

      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      final dt = DateTime(0, 1, 1, hour, minute);
      final formatter = DateFormat('hh:mm a'); // Example: 10:00 AM
      return formatter.format(dt);
    } catch (_) {
      return time;
    }
  }
}
