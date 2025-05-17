class ApiConstants {
  static const String baseUrl = 'http://192.168.0.101:5000/api';

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String profile = '/auth/profile';
  static const String updateRole = '/auth/update-role';

  static const String events = '/events';
  static const String myEvents = '/events/my-events';
  static const String registerEvent = '/events/register';
  static const String myRegistrations = '/events/my-registrations';

  static const String adminUsers = '/admin/users';
  static const String adminEvents = '/admin/events';

  static const String tokenKey = 'token';
  static const String userKey = 'user';
}