import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'friends.dart';

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

  void Menu(){
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(1000, 80, 0, 0),
        items: [
          PopupMenuItem(child: Text("Friends") , value: 'friends',),
          PopupMenuItem(child: Text("Log Out") , value: 'logout',),
        ]
    ).then((value){
      if(value=="logout"){
        showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('Confirm Logout'),
                content: Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {

                      Navigator.pop(context);
                      Logout();
                    },
                    child: Text('Logout'),
                  ),
                ],
              );
            }
        );

      }
      else if(value=="friends"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Friends()));
      }

    });
  }

  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(55, 32, 209, 1.0),
        foregroundColor: Colors.white,
        title: Text("ΦChat" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 28),),
        actions: [
          IconButton(onPressed: (){Menu();}, icon: Icon(Icons.more_vert)),
        ],
      ),
      
    );
  }
}