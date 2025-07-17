import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class RequestsTab extends StatefulWidget{

  @override
  State<RequestsTab> createState() => _RequestsTab();
}

class _RequestsTab extends State<RequestsTab>{

  List<Map<String , dynamic>> req =[];

  void fetchReq() async {

    User ? user = await FirebaseAuth.instance.currentUser;

    if(user==null) return;

    try {
      final query = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('friendReqRec')
          .get();

      List<Map<String, dynamic>> tempList = [];

      for (var doc in query.docs) {
        final data = doc.data();
        tempList.add({
          'uid': data['uid'] ?? doc.id,
          'name': data['name'] ?? '',
          'email': data['email'] ?? '',
          'timestamp': data['timestamp'],
          'status': data['status'] ?? 'pending',
        });
      }

      setState(() {
        req = tempList;
      });

    } catch(e){

    }


  }

  void acceptRequest(Map<String, dynamic> friendData) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;

    if (currentUser == null) return;

    final currentUid = currentUser.uid;
    final friendUid = friendData['uid'];

    try {
      // Add each other as friends
      await firestore
          .collection('user')
          .doc(currentUid)
          .collection('friends')
          .doc(friendUid)
          .set({
        'name': friendData['name'],
        'email': friendData['email'],
        'uid': friendUid,
        'since': FieldValue.serverTimestamp()
      });

      // Add current user to friend's friend list
      await firestore
          .collection('user')
          .doc(friendUid)
          .collection('friends')
          .doc(currentUid)
          .set({
        'name': currentUser.displayName ?? '',
        'email': currentUser.email ?? '',
        'uid': currentUid,
        'since': FieldValue.serverTimestamp()
      });

      // Remove request from friendReqRec
      await firestore
          .collection('user')
          .doc(currentUid)
          .collection('friendReqRec')
          .doc(friendUid)
          .delete();

      // Remove request from friendReqSent
      await firestore
          .collection('user')
          .doc(friendUid)
          .collection('friendReqSent')
          .doc(currentUid)
          .delete();

      // Optionally update UI
      setState(() {
        req.removeWhere((element) => element['uid'] == friendUid);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Friend added successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override

  void initState(){
    super.initState();
    fetchReq();
  }

  Widget build(BuildContext context){
    return Center(
      child: Column(
        children: [

          Expanded(
            child: req.isEmpty
                ? Center(child: Text('No users found.'))
                : ListView.builder(
              itemCount: req.length,
              itemBuilder: (context, index) {
                final user = req[index];
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      trailing: IconButton(onPressed: (){ acceptRequest(user); }, icon: Icon(Icons.check)),
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


