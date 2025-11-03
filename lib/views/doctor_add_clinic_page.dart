import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctor_add_clinic_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/button_widget.dart';

class DoctorAddClinicPage extends StatelessWidget {
  DoctorAddClinicPage({super.key});

  final controller = Get.put(DoctorAddClinicController());
  final _formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Clinic",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTextFormField(
                  "Clinic Name",
                  controller.nameController,
                  validator: (v) => v == null || v.isEmpty
                      ? "Please enter clinic name"
                      : null,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  "Clinic Address",
                  controller.addressController,
                  validator: (v) => v == null || v.isEmpty
                      ? "Please enter clinic address"
                      : null,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  "Contact Number",
                  controller.contactController,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return "Please enter contact number";
                    if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(v)) {
                      return "Please enter a valid phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  "City / Location",
                  controller.cityController,
                  validator: (v) => v == null || v.isEmpty
                      ? "Please enter city/location"
                      : null,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  "Notes (optional)",
                  controller.notesController,
                  maxLines: 3,
                ),

                const SizedBox(height: 20),
                Text(
                  "Weekly Timings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Column(
                    children: controller.weeklyTimings.keys
                        .map((day) => _buildDayTimingCard(context, day))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ButtonWidget(
                    text: "Save Clinic",
                    isLoading: controller.isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await controller.saveClinic();
                      } else {
                        scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextFormField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }

  Widget _buildDayTimingCard(BuildContext context, String day) {
    final openTime = controller.weeklyTimings[day]!['open'];
    final closeTime = controller.weeklyTimings[day]!['close'];

    String formatTime(TimeOfDay? time) {
      if (time == null) return '--:--';
      final hour = time.hourOfPeriod.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime:
                        openTime ?? const TimeOfDay(hour: 9, minute: 0),
                  );
                  if (picked != null)
                    controller.updateTiming(day, 'open', picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("Open: ${formatTime(openTime)}"),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime:
                        closeTime ?? const TimeOfDay(hour: 17, minute: 0),
                  );
                  if (picked != null)
                    controller.updateTiming(day, 'close', picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("Close: ${formatTime(closeTime)}"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
