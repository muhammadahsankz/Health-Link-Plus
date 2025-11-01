import 'package:get/get.dart';
import 'package:health_link_plus/utils/shared_prefs_helper.dart';
import 'package:health_link_plus/views/login_page.dart';
import 'package:health_link_plus/widgets/toast_widget.dart';

class AuthHelper {
  /// ✅ Save login info (token, role, etc.)
  static Future<void> saveLogin({
    required String userId,
    required String token,
    required String role,
    required String name,
    required String email,
  }) async {
    await SharedPrefsHelper.setString(SharedPrefsHelper.userIdKey, userId);
    await SharedPrefsHelper.setString(SharedPrefsHelper.tokenKey, token);
    await SharedPrefsHelper.setString(SharedPrefsHelper.roleKey, role);
    await SharedPrefsHelper.setString(SharedPrefsHelper.userNameKey, name);
    await SharedPrefsHelper.setString(SharedPrefsHelper.emailKey, email);
    await SharedPrefsHelper.setBool(SharedPrefsHelper.isLoggedInKey, true);
  }

  /// 🚪 Logout (clear all saved data)
  static Future<void> logout() async {
    await SharedPrefsHelper.clearAll();
    Get.offAll(() => const LoginPage());
    ToastWidget.show(Get.context!, message: "Logged out successfully");
  }

  /// 🔍 Check if logged in (by verifying token)
  static bool isLoggedIn() {
    final token = SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// 🧩 Get stored userId
  static String? getUserId() {
    return SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey);
  }

  /// 🧩 Get stored token
  static String? getToken() {
    return SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey);
  }

  /// 🧩 Get stored name
  static String? getFullName() {
    return SharedPrefsHelper.getString(SharedPrefsHelper.userNameKey);
  }

  /// 🧩 Get stored email
  static String? getEmail() {
    return SharedPrefsHelper.getString(SharedPrefsHelper.emailKey);
  }

  /// 🧩 Get stored role
  static String? getRole() {
    return SharedPrefsHelper.getString(SharedPrefsHelper.roleKey);
  }

  /// 🧩 Get stored member since
  static String? getMemberSince() {
    return SharedPrefsHelper.getString(SharedPrefsHelper.memberSinceKey);
  }
}
