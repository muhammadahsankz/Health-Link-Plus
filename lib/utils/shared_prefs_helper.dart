import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static SharedPreferences? _prefs;

  /// 🏁 Initialize this before using it (in main.dart)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 🔑 Common keys (define here for easy reuse)
  static const String userIdKey = 'user_id';
  static const String tokenKey = 'token';
  static const String roleKey = 'role';
  static const String isLoggedInKey = 'is_logged_in';
  static const String userNameKey = 'user_name';
  static const String emailKey = 'user_email';
  static const String memberSinceKey = 'member_since';

  // ─────────────────────────────────────────────
  // 🧩 SET METHODS
  // ─────────────────────────────────────────────
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  // ─────────────────────────────────────────────
  // 🔍 GET METHODS
  // ─────────────────────────────────────────────
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  // ─────────────────────────────────────────────
  // 🚪 REMOVE / CLEAR METHODS
  // ─────────────────────────────────────────────
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
