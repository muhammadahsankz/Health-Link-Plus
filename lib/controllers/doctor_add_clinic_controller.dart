import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_urls.dart';
import 'package:health_link_plus/widgets/toast_widget.dart';

class DoctorAddClinicController extends GetxController {
  // Rx values
  var clinicName = ''.obs;
  var clinicAddress = ''.obs;
  var clinicContact = ''.obs;
  var clinicCity = ''.obs;
  var clinicNotes = ''.obs;

  var weeklyTimings = <String, Map<String, TimeOfDay?>>{
    'Monday': {'open': null, 'close': null},
    'Tuesday': {'open': null, 'close': null},
    'Wednesday': {'open': null, 'close': null},
    'Thursday': {'open': null, 'close': null},
    'Friday': {'open': null, 'close': null},
    'Saturday': {'open': null, 'close': null},
    'Sunday': {'open': null, 'close': null},
  }.obs;

  // Loading flags
  var isLoading = false.obs;
  var isFetching = false.obs;

  // TextControllers
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController contactController;
  late TextEditingController cityController;
  late TextEditingController notesController;

  @override
  void onInit() {
    super.onInit();

    // Initialize controllers
    nameController = TextEditingController();
    addressController = TextEditingController();
    contactController = TextEditingController();
    cityController = TextEditingController();
    notesController = TextEditingController();

    // Listen to text changes to update Rx values
    nameController.addListener(() => clinicName.value = nameController.text);
    addressController.addListener(
      () => clinicAddress.value = addressController.text,
    );
    contactController.addListener(
      () => clinicContact.value = contactController.text,
    );
    cityController.addListener(() => clinicCity.value = cityController.text);
    notesController.addListener(() => clinicNotes.value = notesController.text);

    fetchClinicDetails();
  }

  void updateTiming(String day, String type, TimeOfDay time) {
    weeklyTimings[day]![type] = time;
    weeklyTimings.refresh();
  }

  Future<void> fetchClinicDetails() async {
    try {
      isFetching.value = true;
      final doctorId = AuthHelper.getUserId();

      final response = await ApiServices.postRequest(
        url: AppUrls.getClinicData,
        payload: {"doctorId": doctorId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final clinic = data['clinic'];

        if (clinic != null) {
          clinicName.value = clinic['clinicName'] ?? '';
          clinicAddress.value = clinic['clinicAddress'] ?? '';
          clinicContact.value = clinic['clinicContact'] ?? '';
          clinicCity.value = clinic['clinicCity'] ?? '';
          clinicNotes.value = clinic['clinicNotes'] ?? '';

          nameController.text = clinicName.value;
          addressController.text = clinicAddress.value;
          contactController.text = clinicContact.value;
          cityController.text = clinicCity.value;
          notesController.text = clinicNotes.value;

          if (clinic['weeklyTimings'] != null) {
            clinic['weeklyTimings'].forEach((day, timings) {
              weeklyTimings[day] = {
                'open': _parseTime(timings['open']),
                'close': _parseTime(timings['close']),
              };
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching clinic: $e");
    } finally {
      isFetching.value = false;
    }
  }

  TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    final parts = timeString.split(":");
    if (parts.length < 2) return null;
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> saveClinic() async {
    try {
      isLoading.value = true;
      final doctorId = AuthHelper.getUserId();

      final Map<String, Map<String, String?>> timingMap = {};
      weeklyTimings.forEach((day, value) {
        timingMap[day] = {
          'open': value['open'] != null
              ? "${value['open']!.hour}:${value['open']!.minute}"
              : null,
          'close': value['close'] != null
              ? "${value['close']!.hour}:${value['close']!.minute}"
              : null,
        };
      });

      final payload = {
        "doctorId": doctorId,
        "clinicName": clinicName.value,
        "clinicAddress": clinicAddress.value,
        "clinicContact": clinicContact.value,
        "clinicCity": clinicCity.value,
        "clinicNotes": clinicNotes.value,
        "weeklyTimings": timingMap,
      };

      final response = await ApiServices.postRequest(
        url: AppUrls.saveClinicData,
        payload: payload,
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          Get.context!,
          message: "Clinic saved successfully",
          type: ToastType.success,
        );
      } else {
        final body = jsonDecode(response.body);
        ToastWidget.show(
          Get.context!,
          message: body['message'] ?? "Failed to save clinic",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("Error saving clinic: $e");
      ToastWidget.show(
        Get.context!,
        message: "Error saving clinic",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    contactController.dispose();
    cityController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
