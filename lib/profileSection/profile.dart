
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'profileName.dart';
import 'ProfileAbout.dart';

class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {



  File? _imageFile;

  bool showError = false;
  double opacity = 0.0;

  void triggerError() {

    if(showError) return;

    setState(() {
      showError = true;
      opacity = 0.0;
    });


    Future.delayed(Duration(milliseconds: 30), () {
      if (mounted) {
        setState(() {
          opacity = 1.0;
        });
      }
    });

// Stay visible for 500ms, then fade out
    Timer(Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          opacity = 0.0;
        });
      }
    });

// Remove from widget tree after fade-out (200ms)
    Timer(Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          showError = false;
        });
      }
    });


  }


  Future<void> _pickFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }



  @override
  void initState() {
    super.initState();
    // fetchData();
  }


  void dispose(){
    super.dispose();
  }

  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;


    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;


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
                            color: Color.fromRGBO(0, 0, 0, 0.6), // RGB + opacity

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


              ListTile(
                  leading: Icon(Icons.person_2_outlined),
                  title: Text("Name"),
                  subtitle: Text(user!.name),

                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileName()));
                  },

                ),



              ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("About"),
                  subtitle: Text(user.about),

                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAbout()));
                  },

                ),


              GestureDetector(
                onTap: ()=> triggerError(),
                child: ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text("Email"),
                  subtitle: Text(user.email),

                ),
              ),

              if (showError)
                Center(
                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        color: Colors.grey[850], // dark gray background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Email is read only for now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }


}