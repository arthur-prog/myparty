
class User {
  late String userId;
  late String userName;
  late String email;
  late String? firstName;
  late String? lastName;
  late String? birthDate;

  User({
    required this.userId,
    required this.userName,
    required this.email,
    this.firstName,
    this.lastName,
    this.birthDate
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        userId: map['userId'],
        userName: map['userName'],
        email: map['email'],
        firstName: map['firstName'] ?? "",
        lastName: map['lastName'] ?? "",
        birthDate: map['birthDate'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'firstName': firstName ?? "",
      'lastName': lastName  ?? "",
      'birthDate': birthDate  ?? "",
    };
  }
}
