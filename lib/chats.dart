import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';


class Chats extends StatefulWidget{
  @override
  State<Chats> createState() => _Chats();
}

class _Chats extends State<Chats>{

  @override

  void Logout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
    );
  }

  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(
          onPressed: (){Logout();}, child: Text("Logout"),
      ),
    );
  }
}