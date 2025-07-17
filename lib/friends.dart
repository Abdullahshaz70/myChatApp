import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        children: [
          Text("Request Tab"),
        ],
      ),
    );
  }
}


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
                      
                      trailing: IconButton(onPressed: (){}, icon: Icon(Icons.add)),
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