import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/widgets/button_widget.dart';
import '../../controllers/doctor_complete_profile_controller.dart';
import '../../utils/app_colors.dart';

class DoctorCompleteYourProfilePage extends StatelessWidget {
  DoctorCompleteYourProfilePage({super.key});

  final DoctorCompleteProfileController controller = Get.put(
    DoctorCompleteProfileController(),
  );
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Professional Information"),
                  const SizedBox(height: 12),
                  _buildTextField("Specialization", controller.specialization),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Qualifications (e.g. MBBS, FCPS)",
                    controller.qualifications,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Years of Experience",
                    controller.experience,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle("Personal Information"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Phone Number",
                    controller.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Age",
                    controller.age,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderDropdown(),

                  const SizedBox(height: 20),
                  _sectionTitle("About You"),
                  const SizedBox(height: 12),
                  _buildMultilineTextField(
                    "Short Bio (Describe your background, experience, and expertise)",
                    controller.bio,
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: ButtonWidget(
                      text: "Save Profile",
                      isLoading: controller.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await controller.saveProfileToServer();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(
    String label,
    RxString value, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    final textController = TextEditingController(text: value.value);
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );

    return Obx(
      () => TextFormField(
        controller: textController..text = value.value,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (val) => value.value = val,
        validator: (val) =>
            val == null || val.isEmpty ? "Please enter $label" : null,
      ),
    );
  }

  Widget _buildMultilineTextField(String label, RxString value) {
    final textController = TextEditingController(text: value.value);
    return Obx(
      () => TextFormField(
        controller: textController..text = value.value,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (val) => value.value = val,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: controller.gender.value.isEmpty ? null : controller.gender.value,
        items: const [
          DropdownMenuItem(value: "Male", child: Text("Male")),
          DropdownMenuItem(value: "Female", child: Text("Female")),
          DropdownMenuItem(value: "Other", child: Text("Other")),
        ],
        onChanged: (val) => controller.gender.value = val ?? '',
        validator: (val) =>
            val == null || val.isEmpty ? "Please select your gender" : null,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.blue,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
