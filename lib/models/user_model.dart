class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String photoUrl;
  final String role;
  final String token;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime lastLogin;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.photoUrl,
    required this.role,
    required this.token,
    required this.isEmailVerified,
    required this.createdAt,
    required this.lastLogin,
  });

  // Deserialización desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      token: json['token'] as String? ?? '',
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: json.containsKey('lastLogin')
          ? DateTime.parse(json['lastLogin'] as String)
          : DateTime.now(),
    );
  }

  // Serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role,
      'token': token,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  // Método para crear un usuario vacío o placeholder
  factory UserModel.empty() {
    return UserModel(
      id: '',
      name: '',
      email: '',
      phoneNumber: null,
      photoUrl: '',
      role: 'guest',
      token: '',
      isEmailVerified: false,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
  }
}