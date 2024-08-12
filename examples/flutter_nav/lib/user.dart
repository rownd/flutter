class User {
  final String? firstName;
  final String? lastName;
  final String? email;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    return User(
      firstName: json?['first_name'] as String?,
      lastName: json?['last_name'] as String?,
      email: json?['email'] as String?,
    );
  }
}