class User {
  final String username;
  final String email;
  final String phone;
  final String password;

  User({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}
