import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'friendsTab.dart';

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


class FriendsTab extends StatefulWidget{

  @override
  State<FriendsTab> createState() => _FriendsTab();
}

class _FriendsTab extends State<FriendsTab>{

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        children: [
          Text("Friends Tab"),
        ],
      ),
    );
  }
}


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
                      trailing: IconButton(onPressed: (){ }, icon: Icon(Icons.check)),
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


