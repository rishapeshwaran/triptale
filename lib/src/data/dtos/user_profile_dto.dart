class UserModel {
  final String bio;
  final DateTime createdAt;
  final String dob;
  final String email;
  final String name;
  final String profileUrl;
  final String uid;
  final String username;

  UserModel({
    required this.bio,
    required this.createdAt,
    required this.dob,
    required this.email,
    required this.name,
    required this.profileUrl,
    required this.uid,
    required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      bio: json['bio'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      dob: json['dob'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileUrl: json['profile_url'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'dob': dob,
      'email': email,
      'name': name,
      'profile_url': profileUrl,
      'uid': uid,
      'username': username,
    };
  }
}
