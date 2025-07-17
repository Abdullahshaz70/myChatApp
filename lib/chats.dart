import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class Chats extends StatefulWidget{
  @override
  State<Chats> createState() => _Chats();
}

class _Chats extends State<Chats>{
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Text("data"),
    );
  }
}