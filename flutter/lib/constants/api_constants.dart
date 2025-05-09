class ApiConstants {
  static const String baseUrl = 'http://192.168.0.101:5000/api';


  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String profile = '$baseUrl/users/profile';

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}