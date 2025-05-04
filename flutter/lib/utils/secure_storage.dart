import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import '../models/user_model.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save JWT token
  Future<void> saveToken(String token) async {
    await _storage.write(key: ApiConstants.tokenKey, value: token);
  }

  // Get JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: ApiConstants.tokenKey);
  }

  // Delete JWT token
  Future<void> deleteToken() async {
    await _storage.delete(key: ApiConstants.tokenKey);
  }

  // Save user data
  Future<void> saveUser(User user) async {
    await _storage.write(
      key: ApiConstants.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  // Get user data
  Future<User?> getUser() async {
    final userData = await _storage.read(key: ApiConstants.userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Delete user data
  Future<void> deleteUser() async {
    await _storage.delete(key: ApiConstants.userKey);
  }

  // Clear all data (for logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}