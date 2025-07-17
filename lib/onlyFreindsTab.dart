import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chatScren.widget.dart';

class FriendsTab extends StatefulWidget{

  @override
  State<FriendsTab> createState() => _FriendsTab();
}

class _FriendsTab extends State<FriendsTab>{

  List<Map<String, dynamic>> friends = [];

  void fetchFriends() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .collection('friends')
        .get();

    final List<Map<String, dynamic>> loadedFriends = [];

    for (var doc in snapshot.docs) {
      loadedFriends.add(doc.data());
    }

    setState(() {
      friends = loadedFriends;
    });
  }



  @override

  void initState(){
    super.initState();
    fetchFriends();
  }



  Widget build(BuildContext context){
    return Center(
      child: Column(
        children: [

          Expanded(
            child: friends.isEmpty
                ? Center(child: Text("No friends yet"))
                : ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          friendData: friend,
                        ),
                      ),
                    );
                  },
                  leading: Icon(Icons.person),
                  title: Text(friend['name'] ?? 'No Name'),
                  subtitle: Text(friend['email'] ?? 'No Email'),
                );
              },
            ),
          )


        ],
      ),
    );
  }
}

