import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final saved = await AuthService.getSavedUser();
      if (saved != null) {
        _user = saved;
      } else {
        // Default to demo client for immediate experience
        _user = UserModel.defaultDemoClient();
        await AuthService.saveUser(_user!);
      }
    } catch (_) {
      _user = UserModel.defaultDemoClient();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await AuthService.login(email: email, password: password);
      _user = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await AuthService.register(data);
      _user = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.clearAuth();
    _user = null;
    notifyListeners();
  }

  void switchDemoAccount(bool asAdmin) {
    _user = asAdmin ? UserModel.defaultDemoAdmin() : UserModel.defaultDemoClient();
    AuthService.saveUser(_user!);
    notifyListeners();
  }

  void updateUserTenantKey(String newKey) {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        companyName: _user!.companyName,
        phone: _user!.phone,
        gstin: _user!.gstin,
        billingAddress: _user!.billingAddress,
        role: _user!.role,
        erpCustomerId: _user!.erpCustomerId,
        apiToken: newKey,
      );
      AuthService.saveUser(_user!);
      notifyListeners();
    }
  }
}
