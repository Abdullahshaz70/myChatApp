import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class addFriendsTab extends StatefulWidget{

  @override
  State<addFriendsTab> createState() => _addFriendsTab();
}

class _addFriendsTab extends State<addFriendsTab>{

  TextEditingController _searchController = TextEditingController();

  List<Map<String , dynamic>> searchUsers = [];



  void dispose(){
    _searchController.dispose();
    super.dispose();

  }
  void searchUser() async{

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    String search;
    search = _searchController.text.trim();
    if(search.isEmpty) return;



    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('name', isGreaterThanOrEqualTo: search)
          .where('name', isLessThan: search + 'z')
          .get();

      List<Map<String, dynamic>> results = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((user) => user['uid'] != currentUser.uid) // 👈 Skip self
          .toList();

      setState(() {
        searchUsers = results;
      });

    } catch(e){

    }

  }

  void sendReq(String friendName) async {
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;

    if (user == null || friendName.isEmpty) return;

    try {
      final targetQuery = await firestore
          .collection('user')
          .where('name', isEqualTo: friendName)
          .get();

      if (targetQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not found.")),
        );
        return;
      }

      final targetDoc = targetQuery.docs.first;
      final targetUid = targetDoc.id;
      final currentUid = user.uid;

      if (targetUid == currentUid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You can't send a request to yourself.")),
        );
        return;
      }

      // ✅ Fetch current user info
      final currentUserDoc = await firestore.collection('user').doc(currentUid).get();
      final currentUserData = currentUserDoc.data();
      final currentUserName = currentUserData?['name'] ?? '';
      final currentUserEmail = currentUserData?['email'] ?? '';

      final alreadySent = await firestore
          .collection('user')
          .doc(currentUid)
          .collection('friendReqSent')
          .doc(targetUid)
          .get();

      if (alreadySent.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request already sent.")),
        );
        return;
      }

      // Save to sender
      await firestore
          .collection('user')
          .doc(currentUid)
          .collection('friendReqSent')
          .doc(targetUid)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
        'name': targetDoc['name'],
        'uid': targetUid,
        'email': targetDoc['email'],
        'status': 'pending',

      });


      await firestore
          .collection('user')
          .doc(targetUid)
          .collection('friendReqRec')
          .doc(currentUid)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
        'name': currentUserName,
        'uid': currentUid,
        'email': currentUserEmail,
        'status': 'pending',
      });

      _searchController.clear();
      setState(() {
        searchUsers.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }


  // void sendReq(String friendName) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final firestore = FirebaseFirestore.instance;
  //
  //   if (user == null || friendName.isEmpty) return;
  //
  //   try {
  //
  //     final targetQuery = await firestore
  //         .collection('user')
  //         .where('name', isEqualTo: friendName)
  //         .get();
  //
  //     if (targetQuery.docs.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("User not found.")),
  //       );
  //       return;
  //     }
  //
  //     final targetDoc = targetQuery.docs.first;
  //     final targetUid = targetDoc.id;
  //     final currentUid = user.uid;
  //
  //     if (targetUid == currentUid) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("You can't send a request to yourself.")),
  //       );
  //       return;
  //     }
  //
  //
  //     final alreadySent = await firestore
  //         .collection('user')
  //         .doc(currentUid)
  //         .collection('friendReqSent')
  //         .doc(targetUid)
  //         .get();
  //
  //     if (alreadySent.exists) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Request already sent.")),
  //       );
  //       return;
  //     }
  //
  //
  //     await firestore
  //         .collection('user')
  //         .doc(currentUid)
  //         .collection('friendReqSent')
  //         .doc(targetUid)
  //         .set({
  //       'timestamp': FieldValue.serverTimestamp(),
  //       'name': targetDoc['name'],
  //       'uid': targetUid,
  //       'email': targetDoc['email'], // if available
  //       'status': 'pending'
  //     });
  //
  //
  //     await firestore
  //         .collection('user')
  //         .doc(targetUid)
  //         .collection('friendReqRec')
  //         .doc(currentUid)
  //         .set({
  //       'timestamp': FieldValue.serverTimestamp(),
  //       'name': user.displayName ?? '', // or pass it manually
  //       'uid': currentUid,
  //       'email': user.email ?? '',
  //       'status': 'pending'
  //     });
  //
  //
  //     _searchController.clear();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: ${e.toString()}")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20,),

          Container(
              width: 300,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed: (){searchUser();}, icon: Icon(Icons.search)),
                    border: OutlineInputBorder()
                ),
              )


          ),
          SizedBox(height: 20,),

          Expanded(
            child: searchUsers.isEmpty
                ? Center(child: Text('No users found.'))
                : ListView.builder(
              itemCount: searchUsers.length,
              itemBuilder: (context, index) {
                final user = searchUsers[index];
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // background color
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],

                    ),
                    width: 300,
                    child: ListTile(
                      title: Text(
                        user['name'],
                        textAlign: TextAlign.center,
                      ),
                      leading: Icon(Icons.person),
                      trailing: IconButton(onPressed: (){ sendReq(user['name']);}, icon: Icon(Icons.add)),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}