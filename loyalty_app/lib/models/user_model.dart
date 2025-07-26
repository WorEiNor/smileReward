class User {

  final String firstname;
  final String lastname;
  final String email;
  final int points;

  const User({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.points,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstname: json['firstname'] ?? '',
        lastname: json['lastname'] ?? '',
        email: json['email'] ?? '',
        points: json['points'] ?? 0
    );
  }

  User copyWith({
    String? firstname,
    String? lastname,
    String? email,
    int? points,
  }) {
    return User(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      points: points ?? this.points,
    );
  }
}

