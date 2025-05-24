class Login {
  final String id;
  final String email;
  final String role;
  final String token;

  Login({
    required this.id,
    required this.email,
    required this.role,
    required this.token,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'token': token,
    };
  }
}
