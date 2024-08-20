class User {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    return User(
      userId: json?['user_id'] as String?,
      firstName: json?['first_name'] as String?,
      lastName: json?['last_name'] as String?,
      email: json?['email'] as String?,
    );
  }
}
