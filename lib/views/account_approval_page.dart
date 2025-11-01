import 'package:flutter/material.dart';
import 'package:health_link_plus/utils/app_colors.dart';

class AccountApprovalPage extends StatelessWidget {
  const AccountApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue.withValues(alpha: 0.05),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_empty,
                color: AppColors.blueAccent,
                size: 70,
              ),
              SizedBox(height: 20),
              Text(
                "Waiting for Admin Approval",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Your account has been created successfully.\nOnce approved, you'll be able to log in.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
