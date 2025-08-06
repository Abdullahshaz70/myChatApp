import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/userModel.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  List<Map<String, dynamic>> _friends = [];

  UserModel? get user => _user;
  List<Map<String, dynamic>> get friends => _friends;

  Future<void> fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;


    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .get();



    if (doc.exists) {
      _user = UserModel.fromMap(doc.data()!);
    }


    final friendsSnap = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .collection('friends')
        .get();

    _friends = friendsSnap.docs.map((doc) => doc.data()).toList();

    notifyListeners();

  }

  void setName(String name) {
    if (_user != null) {
      _user = _user!.copyWith(name: name);
      notifyListeners();
    }
  }

  void setAbout(String about) {
    if (_user != null) {
      _user = _user!.copyWith(about: about);
      notifyListeners();
    }
  }

  void setPhoto( String photoURL){

    if(_user != null){
      _user = _user!.copyWith(photoURL: photoURL);
      notifyListeners();

    }

  }


}
