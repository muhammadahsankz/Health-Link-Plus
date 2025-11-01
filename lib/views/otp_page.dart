import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/controllers/otp_controller.dart';
import 'package:health_link_plus/widgets/button_widget.dart';

class OtpPage extends StatelessWidget {
  final String name;
  final String email;
  final String password;
  final String role;
  const OtpPage({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final otpController = Get.put(OtpController());
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Container(
          width: screenWidth > 600 ? 400 : screenWidth * 0.9,
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Enter the OTP sent to your email address",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 25),

              // OTP Text Field
              TextField(
                controller: otpController.otpCodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Enter 6-digit OTP",
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (value) {
                  otpController.verifyOtp(
                    name: name,
                    email: email,
                    password: password,
                    role: role,
                    otp: otpController.otpCodeController.text.trim(),
                  );
                },
              ),
              const SizedBox(height: 25),

              // Verify Button
              ButtonWidget(
                text: "Verify OTP",
                isLoading: otpController.isLoading,
                onPressed: () {
                  otpController.verifyOtp(
                    name: name,
                    email: email,
                    password: password,
                    role: role,
                    otp: otpController.otpCodeController.text.trim(),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Resend Option (for later use)
              TextButton(
                onPressed: () {
                  otpController.resendOtp(email: email);
                },
                child: const Text(
                  "Didn’t receive OTP? Resend",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
