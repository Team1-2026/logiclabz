import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static const String tokenKey = 'logic_auth_token';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  static Future<dynamic> request({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final token = await getToken();
    final baseUrl = ApiConfig.baseUrl;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    final url = endpoint.startsWith('http') ? Uri.parse(endpoint) : Uri.parse('$baseUrl/$cleanEndpoint');

    final requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (headers != null) ...headers,
    };

    http.Response response;
    try {
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(
            url,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(
            url,
            headers: requestHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'GET':
        default:
          response = await http.get(url, headers: requestHeaders);
          break;
      }

      final responseBody = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        final message = responseBody is Map ? (responseBody['message'] ?? responseBody['error'] ?? 'Request failed') : 'Request failed (${response.statusCode})';
        throw Exception(message);
      }
    } catch (e) {
      // Re-throw exception with context
      rethrow;
    }
  }

  static Future<dynamic> get(String endpoint, {Map<String, String>? headers}) =>
      request(endpoint: endpoint, method: 'GET', headers: headers);

  static Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) =>
      request(endpoint: endpoint, method: 'POST', body: body, headers: headers);

  static Future<dynamic> put(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) =>
      request(endpoint: endpoint, method: 'PUT', body: body, headers: headers);

  static Future<dynamic> delete(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) =>
      request(endpoint: endpoint, method: 'DELETE', body: body, headers: headers);
}
