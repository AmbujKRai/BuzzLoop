import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, authenticating, error }

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  // Getters
  AuthStatus get status => _status;

  User? get user => _user;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Constructor
  AuthProvider() {
    _checkAuth();
  }

  // Initialize - check if user is already logged in
  Future<void> _checkAuth() async {
    try {
      final isValidToken = await _authService.isTokenValid();

      if (isValidToken) {
        _user = await _authService.getCurrentUser();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  // Register a new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      _user = await _authService.register(
        name: name,
        email: email,
        password: password,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _status = AuthStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      _user = await _authService.login(
        email: email,
        password: password,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // Refresh user profile
  Future<void> refreshProfile() async {
    try {
      if (_status != AuthStatus.authenticated) return;

      _user = await _authService.getUserProfile();
      notifyListeners();
    } catch (e) {
      // If getting profile fails due to invalid token, logout
      if (e.toString().contains('Authentication')) {
        await logout();
      }
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? bio,
    String? location,
    List<String>? interests,
    String? profileImage,
  }) async {
    try {
      _user = await _authService.updateProfile(
        name: name,
        email: email,
        bio: bio,
        location: location,
        interests: interests,
        profileImage: profileImage,
      );

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}