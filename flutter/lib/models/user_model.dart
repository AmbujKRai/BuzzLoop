class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? bio;
  final String? location;
  final List<String>? interests;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.bio,
    this.location,
    this.interests,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<String>? interestsList;
    if (json['interests'] != null) {
      interestsList = List<String>.from(json['interests'].map((x) => x.toString()));
    }

    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      bio: json['bio'],
      location: json['location'],
      interests: interestsList,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'bio': bio,
      'location': location,
      'interests': interests,
      'token': token,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? bio,
    String? location,
    List<String>? interests,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      token: token ?? this.token,
    );
  }
}