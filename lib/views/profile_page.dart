import 'package:flutter/material.dart';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:health_link_plus/utils/app_colors.dart';
import 'package:health_link_plus/widgets/button_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch user info from AuthHelper
    final String name = AuthHelper.getFullName() ?? "User Name";
    final String email = AuthHelper.getEmail() ?? "user@email.com";
    final String role = AuthHelper.getRole() ?? "Role";

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Profile",
                style: TextStyle(
                  color: AppColors.blueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.blueAccent.withOpacity(0.3),
                    child: Text(
                      name.isNotEmpty ? name[0] : "U",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow("Name", name),
                  const SizedBox(height: 10),
                  _buildDetailRow("Email", email),
                  const SizedBox(height: 10),
                  _buildDetailRow("Role", role),
                  const SizedBox(height: 30),
                  ButtonWidget(
                    text: 'Logout',
                    onPressed: () async {
                      await AuthHelper.logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
