import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'friendsTab.dart';
import 'requestTab.dart';
import 'onlyFreindsTab.dart';

class Friends extends StatefulWidget{
  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends>{
  @override


  Widget build(BuildContext context){
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(55, 32, 209, 1.0),
            foregroundColor: Colors.white,
            title: Text("Connect",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 28),),
            
            bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Friends", icon: Icon(Icons.people)),
                  Tab(text: "Requests", icon: Icon(Icons.person_add)),
                  Tab(text: "Add", icon: Icon(Icons.search)),
                ]
            ),
          ),
          
          body: TabBarView(
              children: [
                FriendsTab(),
                RequestsTab(),
                addFriendsTab(),
              ]
          ),
        )
    );
  }
}


