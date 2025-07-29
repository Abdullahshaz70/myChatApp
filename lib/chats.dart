import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'friends.dart';
import 'chatScren.widget.dart';
import 'profile.dart';
import 'providers/userProvider.dart';



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
          PopupMenuItem(child: Text("Profile") , value: 'profile',),
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
      else if(value=="profile"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
      }

    });
  }

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



    // @override
    // void initState() {
    //   super.initState();
    //   fetchFriends();
    // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUserData();
      fetchFriends();
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

      body: Center(
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
            ),
          ],
        ),
      ),
      
    );
  }

}