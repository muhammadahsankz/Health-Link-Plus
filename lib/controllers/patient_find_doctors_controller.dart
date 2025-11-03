import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:health_link_plus/widgets/toast_widget.dart';
import 'package:health_link_plus/utils/app_colors.dart';

class PatientFindDoctorsController extends GetxController {
  var doctors = <Map<String, dynamic>>[].obs;
  var filteredDoctors = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isRequestAppointmentLoading = false.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        url: AppUrls.getAllDoctorsListForPatient,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        doctors.value = List<Map<String, dynamic>>.from(data['doctors']);
        filteredDoctors.assignAll(doctors);
      }
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.assignAll(doctors);
    } else {
      final lower = query.toLowerCase();
      filteredDoctors.assignAll(
        doctors.where((doc) {
          final name = (doc['name'] ?? '').toLowerCase();
          final specialization = (doc['specialization'] ?? '').toLowerCase();
          return name.contains(lower) || specialization.contains(lower);
        }),
      );
    }
  }

  /// 🩺 Request Appointment Flow
  Future<void> requestAnAppointment(Map<String, dynamic> doctor) async {
    final context = Get.context!;
    final clinic = doctor['clinic'];
    if (clinic == null || clinic['weeklyTimings'] == null) {
      ToastWidget.show(
        context,
        message: "Doctor has no available timings.",
        type: ToastType.error,
      );
      return;
    }

    // 1️⃣ Pick a date
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.blue),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return;

    // 2️⃣ Pick a time
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.blue),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null) return;

    // 3️⃣ Validate time against doctor's weeklyTimings
    final weekday = _getWeekdayName(selectedDate.weekday); // e.g., "Monday"
    final timings = clinic['weeklyTimings'][weekday];

    if (timings == null ||
        timings['open'] == null ||
        timings['close'] == null) {
      ToastWidget.show(
        context,
        message: "Doctor is not available on $weekday.",
        type: ToastType.error,
      );
      return;
    }

    final isValid = _isWithinDoctorTime(
      selectedTime,
      timings['open'],
      timings['close'],
    );

    if (!isValid) {
      ToastWidget.show(
        context,
        message: "Selected time is outside doctor's availability.",
        type: ToastType.error,
      );
      return;
    }

    // 4️⃣ Combine date + time and convert to UTC
    final appointmentDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    final appointmentDateUtc = appointmentDateTime.toUtc();

    // 5️⃣ Send Appointment API request
    await _sendAppointmentRequest(
      doctor['_id'],
      appointmentDateUtc,
      "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}",
    );
  }

  // 🕓 Check if selected time lies between open and close
  bool _isWithinDoctorTime(TimeOfDay selected, String open, String close) {
    try {
      final openParts = open.split(':');
      final closeParts = close.split(':');
      final openTime = TimeOfDay(
        hour: int.parse(openParts[0]),
        minute: int.parse(openParts[1]),
      );
      final closeTime = TimeOfDay(
        hour: int.parse(closeParts[0]),
        minute: int.parse(closeParts[1]),
      );

      final selectedMinutes = selected.hour * 60 + selected.minute;
      final openMinutes = openTime.hour * 60 + openTime.minute;
      final closeMinutes = closeTime.hour * 60 + closeTime.minute;

      return selectedMinutes >= openMinutes && selectedMinutes <= closeMinutes;
    } catch (e) {
      return false;
    }
  }

  // 🗓️ Convert weekday integer → String (match backend naming)
  String _getWeekdayName(int weekday) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return days[weekday - 1];
  }

  // 🚀 Send Appointment API request
  Future<void> _sendAppointmentRequest(
    String doctorId,
    DateTime appointmentDateUtc,
    String appointmentTime,
  ) async {
    final context = Get.context!;
    try {
      isRequestAppointmentLoading.value = true;

      final patientId = AuthHelper.getUserId();
      final body = {
        "doctorId": doctorId,
        "patientId": patientId,
        "appointmentDate": appointmentDateUtc.toIso8601String(),
        "appointmentTime": appointmentTime,
        "notes": "Consultation request",
      };

      final response = await ApiServices.postRequest(
        url: AppUrls.requestAnAppointment,
        payload: body,
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context,
          message: "Appointment requested successfully!",
          type: ToastType.success,
        );
      } else {
        final data = jsonDecode(response.body);
        ToastWidget.show(
          context,
          message: data['message'] ?? "Failed to request appointment.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context,
        message: "Error requesting appointment.",
        type: ToastType.error,
      );
    } finally {
      isRequestAppointmentLoading.value = false;
    }
  }
}
