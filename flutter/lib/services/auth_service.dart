import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../constants/api_constants.dart';
import '../models/user_model.dart';
import '../utils/secure_storage.dart';

class AuthService {
  final SecureStorage _secureStorage = SecureStorage();

  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final userData = User.fromJson(jsonDecode(response.body));
        
        await _secureStorage.saveToken(userData.token!);
        await _secureStorage.saveUser(userData);
        
        return userData;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final userData = User.fromJson(jsonDecode(response.body));
        
        await _secureStorage.saveToken(userData.token!);
        await _secureStorage.saveUser(userData);
        
        return userData;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await _secureStorage.clearAll();
  }

  Future<User?> getCurrentUser() async {
    return await _secureStorage.getUser();
  }

  Future<bool> isTokenValid() async {
    final token = await _secureStorage.getToken();
    if (token == null) return false;
    
    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }

  Future<User> getUserProfile() async {
    try {
      final token = await _secureStorage.getToken();
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      
      final response = await http.get(
        Uri.parse(ApiConstants.profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = User.fromJson(jsonDecode(response.body));
        final currentUser = await _secureStorage.getUser();
        
        final updatedUser = userData.copyWith(token: currentUser?.token);
        await _secureStorage.saveUser(updatedUser);
        
        return updatedUser;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  Future<User> updateProfile({
    String? name,
    String? email,
    String? bio,
    String? location,
    List<String>? interests,
    String? profileImage,
  }) async {
    try {
      final token = await _secureStorage.getToken();
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      
      final Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (bio != null) updateData['bio'] = bio;
      if (location != null) updateData['location'] = location;
      if (interests != null) updateData['interests'] = interests;
      if (profileImage != null) updateData['profileImage'] = profileImage;
      
      final response = await http.put(
        Uri.parse(ApiConstants.profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        final updatedUser = User.fromJson(jsonDecode(response.body));
        await _secureStorage.saveUser(updatedUser);
        return updatedUser;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}