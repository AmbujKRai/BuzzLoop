class User {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? token;
  final Map<String, dynamic>? profile;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.token,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      token: json['token'],
      profile: json['profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'token': token,
      'profile': profile,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? role,
    String? token,
    Map<String, dynamic>? profile,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      profile: profile ?? this.profile,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isOrganizer => role == 'organizer' || role == 'admin';
  bool get isUser => role == 'user' || role == 'organizer' || role == 'admin';
}