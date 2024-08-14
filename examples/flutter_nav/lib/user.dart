class User {
  final String? firstName;
  final String? lastName;
  final String? email;

  User({
    this.firstName,
     this.lastName,
     this.email,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    return User(
      firstName: json?['firstName'] as String?,
      lastName: json?['lastName'] as String?,
      email: json?['email'] as String?,
    );
  }
}