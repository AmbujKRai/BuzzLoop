import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import '../models/user_model.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: ApiConstants.tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: ApiConstants.tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: ApiConstants.tokenKey);
  }

  static Future<void> saveUser(User user) async {
    await _storage.write(
      key: ApiConstants.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  static Future<User?> getUser() async {
    final userData = await _storage.read(key: ApiConstants.userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  static Future<void> deleteUser() async {
    await _storage.delete(key: ApiConstants.userKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}