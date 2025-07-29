class UserModel {
  final String name;
  final String email;
  final String about;

  UserModel({required this.name, required this.email, required this.about});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      about: map['about'] ?? '',
    );
  }
}
