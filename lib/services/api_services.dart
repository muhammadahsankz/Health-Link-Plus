import 'dart:convert';
import 'package:health_link_plus/helpers/auth_helper.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  // POST Request
  static Future<http.Response> postRequest({
    required String url,
    required Map<String, dynamic> payload,
  }) async {
    final endpoint = Uri.parse(url);

    final token = AuthHelper.getToken();

    return await http.post(
      endpoint,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(payload),
    );
  }

  /// GET request
  static Future<http.Response> getRequest({
    required String url,
    Map<String, String>? queryParams,
  }) async {
    final uri = queryParams != null
        ? Uri.parse(url).replace(queryParameters: queryParams)
        : Uri.parse(url);

    final token = AuthHelper.getToken();

    return await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }

  /// PUT request
  static Future<http.Response> putRequest({
    required String url,
    required Map<String, dynamic> payload,
  }) async {
    final endpoint = Uri.parse(url);

    final token = AuthHelper.getToken();

    return await http.put(
      endpoint,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(payload),
    );
  }
}
