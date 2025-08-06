import 'package:flutter/cupertino.dart';

class UserModel {
  final String name;
  final String email;
  final String about;
  final String uid;
  final String photoURL;


  UserModel({
    required this.name,
    required this.email,
    required this.about,
    required this.uid,
    required this.photoURL,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {

    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      about: map['about'] ?? '',
      uid: map['uid'] ?? '',
      photoURL: map['photoURL'] ?? '',
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? about,
    String? uid,
    String? photoURL,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      about: about ?? this.about,
      uid: uid ?? this.uid,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'about': about,
      'uid': uid,
      'photoURL': photoURL,
    };
  }
}
