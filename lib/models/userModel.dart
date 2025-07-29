class UserModel {
  final String name;
  final String email;
  final String about;
  final String uid;

  UserModel({required this.name, required this.email, required this.about , required this.uid});



  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      about: map['about'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

    UserModel copyWith({String? name, String? email, String? about , String? uid}) {
      return UserModel(
        name: name ?? this.name,
        email: email ?? this.email,
        about: about ?? this.about,
        uid: uid ?? this.uid,
      );
    }


}
