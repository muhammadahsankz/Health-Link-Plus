import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/controllers/video_call_controller.dart';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:health_link_plus/utils/app_constants.dart';
import 'package:health_link_plus/views/video_call_page.dart';
import 'package:health_link_plus/widgets/button_widget.dart';
import 'package:intl/intl.dart';
import '../../controllers/doctor_appointments_controller.dart';
import '../../utils/app_colors.dart';

class DoctorAppointmentsPage extends StatelessWidget {
  const DoctorAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorAppointmentsController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(blurRadius: 5, color: Colors.black12),
                    ],
                  ),
                  child: controller.appointments.isEmpty
                      ? const Center(
                          child: Text(
                            "No appointments found.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              AppColors.blue.withOpacity(0.1),
                            ),
                            columns: const [
                              DataColumn(label: Text("Patient")),
                              DataColumn(label: Text("Date")),
                              DataColumn(label: Text("Time")),
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: controller.appointments.map((appt) {
                              final apptId = appt['id'] ?? '';
                              final status = appt['status'] ?? '';
                              final patientName = appt['patient'] ?? 'Unknown';
                              final dateStr = appt['date'] ?? '';
                              final timeStr = appt['time'] ?? '';

                              // Parse the appointment DateTime
                              DateTime? appointmentDateTime;
                              try {
                                appointmentDateTime = DateTime.parse(dateStr);
                                final parts = timeStr.split(':');
                                if (parts.length == 2) {
                                  appointmentDateTime = DateTime(
                                    appointmentDateTime.year,
                                    appointmentDateTime.month,
                                    appointmentDateTime.day,
                                    int.parse(parts[0]),
                                    int.parse(parts[1]),
                                  );
                                }
                              } catch (_) {
                                appointmentDateTime = null;
                              }

                              final now = DateTime.now();

                              // Determine action button
                              Widget actionWidget;
                              if (status ==
                                  AppConstants.appointmentStatus.pending) {
                                actionWidget = ButtonWidget(
                                  text: "Accept",
                                  isLoading:
                                      (controller.acceptLoadingMap[apptId] ??
                                              false)
                                          .obs,
                                  height: 30,
                                  width: 150,
                                  onPressed: () {
                                    if (apptId.isNotEmpty) {
                                      controller.acceptAppointment(apptId);
                                    }
                                  },
                                );
                              } else if (status ==
                                      AppConstants.appointmentStatus.approved &&
                                  appointmentDateTime != null &&
                                  now.isAfter(appointmentDateTime) &&
                                  now.isBefore(
                                    appointmentDateTime.add(
                                      const Duration(hours: 1),
                                    ),
                                  )) {
                                actionWidget = ButtonWidget(
                                  text: "Start Call",
                                  isLoading: controller.isCreateMeetingLoading,
                                  color: AppColors.green,
                                  height: 30,
                                  width: 150,
                                  onPressed: () async {
                                    // Get.to(
                                    //   () => VideoCallPage(channelName: apptId),
                                    // );
                                    // In doctor appointment page start zoom meeting button
                                    final meetingId = await controller
                                        .createZoomMeeting(
                                          apptId,
                                          AuthHelper.getEmail() ??
                                              'doctor@healthlinkplus.com',
                                          AuthHelper.getFullName() ?? 'Doctor',
                                        );
                                    if (meetingId != null) {
                                      Get.to(
                                        () => VideoCallPage(
                                          meetingId: meetingId,
                                          role: "1", // host role
                                          userName:
                                              AuthHelper.getFullName() ??
                                              'Doctor',
                                          userEmail:
                                              AuthHelper.getEmail() ??
                                              'doctor@healthlinkplus.com',
                                        ),
                                      );
                                    }
                                  },
                                );
                              } else {
                                actionWidget = const Text(
                                  "Accepted",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }

                              return DataRow(
                                cells: [
                                  DataCell(Text(patientName)),
                                  DataCell(Text(formatDate(dateStr))),
                                  DataCell(Text(formatTime(timeStr))),
                                  DataCell(Text(status)),
                                  DataCell(actionWidget),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return DateFormat('EEE, MMM d, yyyy').format(date);
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
