import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:health_link_plus/utils/app_colors.dart';
import 'package:health_link_plus/utils/app_constants.dart';
import 'package:health_link_plus/utils/shared_prefs_helper.dart';
import 'package:health_link_plus/views/admin_homepage.dart';
import 'package:health_link_plus/views/doctor_homepage.dart';
import 'package:health_link_plus/views/login_page.dart';
import 'package:health_link_plus/views/patient_homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.init();

  final bool isLoggedIn = AuthHelper.isLoggedIn();
  final String role = AuthHelper.getRole() ?? '';
  runApp(MyApp(role: role, isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final String role;
  final bool isLoggedIn;
  const MyApp({super.key, required this.role, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white, // ✅ Default background
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white, // ✅ AppBar background
          foregroundColor: AppColors.black, // ✅ AppBar text/icons
          elevation: 0, // flat look
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white, // ✅ BottomSheet background
        ),
        dialogTheme: DialogThemeData(backgroundColor: AppColors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          surface: AppColors.white, // ✅ general background
          brightness: Brightness.light,
        ),
      ),
      home: isLoggedIn
          ? (role == AppConstants.roles.admin
                ? const AdminHomepage()
                : role == AppConstants.roles.doctor
                ? const DoctorHomepage()
                : const PatientHomepage())
          : const LoginPage(),
    );
  }
}
