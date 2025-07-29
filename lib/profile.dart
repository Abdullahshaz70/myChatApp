import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'profileName.dart';
import 'ProfleAbout.dart';

class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {


  File? _imageFile;

  Future<void> _pickFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  String _name = "";
  String _about = "";
  String _mail = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final docSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) return;

      final data = docSnapshot.data();

      if (data != null) {
        setState(() {
          _name = data['name'] ?? "";
          _mail = data['email'] ?? "";
          _about = data['about'] ?? "";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }


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
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: null,

                      child: _imageFile==null ?  Icon(
                        Icons.person,
                        size: 75,
                        color: Colors.white70,
                      ) : null

                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickFromCamera,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      )


                    ),
                  ],
                ),
              ),


              Container(
                child: ListTile(
                  leading: Icon(Icons.person_2_outlined),
                  title: Text("Name"),
                  subtitle: Text("$_name"),

                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileName()));
                  },

                ),
              ),

              Container(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("About"),
                  subtitle: Text("$_about"),

                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAbout()));
                  },

                ),
              ),

              Container(
                child: ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text("Email"),
                  subtitle: Text("$_mail"),

                ),
              ),


            ],
          ),
        ),
      ),


    );

  }


}