class ApiConstants {
  // Base URL - change to your backend URL when deployed
  static const String baseUrl = 'http://192.168.2.107:5000/api'; // For Android emulator
  // static const String baseUrl = 'http://localhost:5000/api'; // For iOS simulator

  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String profile = '$baseUrl/auth/profile';
  
  // Token key for secure storage
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}