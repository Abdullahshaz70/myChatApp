import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profileName.dart';

class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {

  @override

  void dispose(){
    super.dispose();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Replace with user photo URL or leave blank
                  ),
                ),
              ),

              Container(
                child: ListTile(
                  leading: Icon(Icons.person_2_outlined),
                  title: Text("Name"),
                  subtitle: Text("Abdullah Shahzad"),

                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileName()));
                  },

                ),
              ),

              Container(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("About"),
                  subtitle: Text("."),

                ),
              ),

              Container(
                child: ListTile(
                  leading: Icon(Icons.local_phone_outlined),
                  title: Text("Phone Number"),
                  subtitle: Text("Abdullah Shahzad"),

                ),
              ),


            ],
          ),
        ),
      ),


    );

  }
}