import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _username = '';

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get username => _username;

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');
    if (savedUsername != null && savedPassword != null) {
      await login(savedUsername, savedPassword, saveCredentials: false);
    }
  }

  Future<bool> login(String username, String password, {bool saveCredentials = true}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await _api.login(username, password);

    if (result['success'] == true) {
      _isAuthenticated = true;
      _username = username;

      if (saveCredentials) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['error'] ?? 'Неизвестная ошибка';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _api.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    _isAuthenticated = false;
    _username = '';
    _errorMessage = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
