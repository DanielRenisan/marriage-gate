import 'package:http/http.dart' as http;
import 'package:matrimony_flutter/services/auth_service.dart';

class HttpInterceptor {
  static final AuthService _authService = AuthService();

  static Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final authHeaders = await _getAuthHeaders(headers);
    return http.get(Uri.parse(url), headers: authHeaders);
  }

  static Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final authHeaders = await _getAuthHeaders(headers);
    return http.post(Uri.parse(url), headers: authHeaders, body: body);
  }

  static Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final authHeaders = await _getAuthHeaders(headers);
    return http.put(Uri.parse(url), headers: authHeaders, body: body);
  }

  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final authHeaders = await _getAuthHeaders(headers);
    return http.delete(Uri.parse(url), headers: authHeaders, body: body);
  }

  static Future<Map<String, String>> _getAuthHeaders(Map<String, String>? headers) async {
    final defaultHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    // Add authorization header if user is logged in
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      final token = await _authService.getAuthToken();
      if (token != null) {
        defaultHeaders['Authorization'] = 'Bearer $token';
      }
    }

    return defaultHeaders;
  }
}
