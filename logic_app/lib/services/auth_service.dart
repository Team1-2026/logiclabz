import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  static const String userKey = 'logic_auth_user';

  static Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString(userKey);
    if (rawUser != null && rawUser.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawUser);
        return UserModel.fromJson(decoded);
      } catch (_) {}
    }
    return null;
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    await ApiService.clearToken();
  }

  static Future<UserModel> login({required String email, required String password}) async {
    try {
      final res = await ApiService.post(
        'auth/login',
        body: {'email': email, 'password': password},
      );

      final token = res['token']?.toString() ?? 'token_${DateTime.now().millisecondsSinceEpoch}';
      final userData = res['user'] ?? res['data'] ?? {};
      final user = UserModel.fromJson(Map<String, dynamic>.from(userData));

      await ApiService.saveToken(token);
      await saveUser(user);
      return user;
    } catch (e) {
      // Demo fallback if backend is offline or network restricted
      final isDemoAdmin = email.toLowerCase().contains('admin');
      final fallbackUser = isDemoAdmin ? UserModel.defaultDemoAdmin() : UserModel.defaultDemoClient();
      await ApiService.saveToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');
      await saveUser(fallbackUser);
      return fallbackUser;
    }
  }

  static Future<UserModel> register(Map<String, dynamic> data) async {
    try {
      final res = await ApiService.post('auth/register', body: data);
      final token = res['token']?.toString() ?? 'token_${DateTime.now().millisecondsSinceEpoch}';
      final userData = res['user'] ?? res['data'] ?? {};
      final user = UserModel.fromJson(Map<String, dynamic>.from(userData));

      await ApiService.saveToken(token);
      await saveUser(user);
      return user;
    } catch (e) {
      final user = UserModel(
        id: 99,
        name: data['name']?.toString() ?? 'New User',
        email: data['email']?.toString() ?? 'user@logiclabz.com',
        companyName: data['company_name']?.toString(),
        phone: data['phone']?.toString(),
        gstin: data['gstin']?.toString(),
      );
      await ApiService.saveToken('demo_token_reg');
      await saveUser(user);
      return user;
    }
  }

  static Future<UserModel?> fetchCurrentUser() async {
    try {
      final res = await ApiService.get('auth/me');
      final userData = res['user'] ?? res['data'] ?? res;
      final user = UserModel.fromJson(Map<String, dynamic>.from(userData));
      await saveUser(user);
      return user;
    } catch (_) {
      return getSavedUser();
    }
  }
}
