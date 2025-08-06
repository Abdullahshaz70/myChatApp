import 'package:cached_network_image/cached_network_image.dart';

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'profileName.dart';
import 'ProfileAbout.dart';

class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {

final Color pp = Color.fromRGBO(55, 32, 209, 1.0);


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


  final picker = ImagePicker();

  Future<void> pickAndUploadImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile==null) return;

    final file = File(pickedFile.path);
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dr3gd4rob/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'desktopPics'
      ..fields['folder'] = 'userPhotos'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));


    final response = await request.send();

    if (response.statusCode == 200) {
      final respData = await response.stream.bytesToString();
      final decoded = json.decode(respData);
      final imageUrl = decoded['secure_url'];
      print('Image uploaded: $imageUrl');

      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'photoURL': imageUrl});


      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setPhoto(imageUrl);


    } else {
      print('Upload failed: ${response.statusCode}');
    }

  }


  @override
  void initState() {
    super.initState();

  }

void didChangeDependencies() {
  super.didChangeDependencies();

  final user = Provider.of<UserProvider>(context).user;
  if (user?.photoURL != null) {
    precacheImage(NetworkImage(user!.photoURL!), context);
  }
}


  void dispose(){
    super.dispose();
  }

  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    final screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: pp,
        foregroundColor: Colors.white,
        title: Text("Profile"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20,),



              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(user!.photoURL)  ,
                    ),


                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: (){pickAndUploadImage();},
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: pp,

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

              const SizedBox(height: 20,),

              ListTile(
                  leading: Icon(Icons.person_2_outlined , color: pp,),
                  title: Text("Name",
                  style: TextStyle(color: pp),),
                  subtitle: Text(user!.name),

                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileName()));
                  },

                ),

              const SizedBox(height: 20,),


              ListTile(
                  leading: Icon(Icons.info_outline,color: pp,),
                  title: Text("About",
                    style: TextStyle(color: pp),),
                  subtitle: Text(user.about),

                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAbout()));
                  },

                ),

              const SizedBox(height: 20,),

              GestureDetector(
                onTap: ()=> triggerError(),
                child: ListTile(
                  leading: Icon(Icons.email_outlined,color: pp,),
                  title: Text("Email",
                    style: TextStyle(color: pp),),
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

