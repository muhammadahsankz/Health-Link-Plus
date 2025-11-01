import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AdminAppointmentsPage extends StatelessWidget {
  const AdminAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('Appointments'),
      child: Text(
        "Appointments Page",
        style: TextStyle(color: AppColors.blue, fontSize: 22),
      ),
    );
  }
}
