import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/secure_storage.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  String _errorMessage = '';

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get errorMessage => _errorMessage; // Added getter for errorMessage

  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isOrganizer => _currentUser?.isOrganizer ?? false;

  AuthProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userData = await SecureStorage.read('user');
      final token = await SecureStorage.read('token');

      if (userData != null && token != null) {
        final Map<String, dynamic> userMap = json.decode(userData);
        _currentUser = User.fromJson({...userMap, 'token': token});
      }
    } catch (e) {
      _error = 'Failed to load user data';
      _errorMessage = 'Failed to load user data';
      debugPrint('Error loading user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? role,
  }) async {
    _isLoading = true;
    _error = null;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await AuthService.register(
        username: username,
        email: email,
        password: password,
        role: role,
      );

      _currentUser = response;
      await SecureStorage.write('user', json.encode(_currentUser!.toJson()));
      await SecureStorage.write('token', _currentUser!.token!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await AuthService.login(email: email, password: password);

      _currentUser = response;
      await SecureStorage.write('user', json.encode(_currentUser!.toJson()));
      await SecureStorage.write('token', _currentUser!.token!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await SecureStorage.delete('user');
    await SecureStorage.delete('token');

    _currentUser = null;
    notifyListeners();
  }

  bool canAccess(List<String> allowedRoles) {
    if (_currentUser == null) return false;

    return allowedRoles.contains(_currentUser!.role);
  }

  bool hasPermission(String requiredRole) {
    if (_currentUser == null) return false;

    switch (requiredRole) {
      case 'admin':
        return _currentUser!.isAdmin;
      case 'organizer':
        return _currentUser!.isOrganizer;
      case 'user':
        return _currentUser!.isUser;
      default:
        return false;
    }
  }

  Future<void> refreshUserData() async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = await AuthService.getUserProfile();
      _currentUser = updatedUser.copyWith(token: _currentUser!.token);
      await SecureStorage.write('user', json.encode(_currentUser!.toJson()));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}