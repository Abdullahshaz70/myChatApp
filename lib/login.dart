import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'chats.dart';


class Login extends StatefulWidget{
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login>{

  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _mailController = TextEditingController();

  bool _imageLoaded = false;
  bool _isObsecure = true;
  bool _isLoading = false;

  String email ="";
  String password = "";



  @override

  void dispose(){
    super.dispose();
    _passwordController.dispose();
    _mailController.dispose();
  }

  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        NetworkImage("https://i.pinimg.com/1200x/4a/ca/fe/4acafecd9b6e8bf88b2b80b971e338eb.jpg"),
        context,
      ).then((_) {
        setState(() {
          _imageLoaded = true;
        });
      });
    });
  }


  void validate(){

    if(_formKey.currentState!.validate()){
      email = _mailController.text.trim();
      password = _passwordController.text.trim();

      setState(() {
        _isLoading = true;
      });

      login();


    }

  }
  void login() async{

    try {

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful"))
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) => Chats()));

    }
    on FirebaseAuthException catch (e) {
      String error = "Login failed";
      if (e.code == 'user-not-found') {
        error = "No user found with this email.";
      } else if (e.code == 'wrong-password') {
        error = "Incorrect password.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred")),
      );
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

  }

  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar(
      centerTitle: true,
    ),

      body: _imageLoaded ? GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child:SafeArea(

            child:SingleChildScrollView(

                child: Column(
                  children: [

                    Center(
                      child: Image.network(
                        "https://i.pinimg.com/1200x/4a/ca/fe/4acafecd9b6e8bf88b2b80b971e338eb.jpg",
                        height: 250,
                      ),
                    ),
                    SizedBox(height: 20,),

                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              width: 250,
                              child:TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@') || !value.contains('.')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                                controller: _mailController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Enter Your Email",
                                    labelText: "Email",
                                    suffixIcon: Icon(Icons.email, color: Color.fromRGBO(55, 32, 209, 1.0),)
                                ),
                              ) ,
                            ),
                            SizedBox(height: 20,),


                            Container(
                              width: 250,
                              child:TextFormField(
                                obscureText: _isObsecure,
                                validator:(value){
                                  if(value==null || value.isEmpty){
                                    return " Password is Required";
                                  }
                                  if(value.length < 8){
                                    return "Enter a valid Password";
                                  }
                                  return null;
                                },
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Enter Your Password",
                                    labelText: "Password",
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObsecure ? Icons.visibility_off : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObsecure = !_isObsecure;
                                        });
                                      },
                                      color: Color.fromRGBO(55, 32, 209, 1.0),
                                    ),
                                ),
                              )
                              // Icon(Icons.password, color: Color.fromRGBO(55, 32, 209, 1.0),)
                            ),
                            SizedBox(height: 20,),

                            Container(
                                width: 150,
                                child: _isLoading ? Center(child: CircularProgressIndicator(color: Color.fromRGBO(55, 32, 209, 1.0))): ElevatedButton(
                                  onPressed: (){ validate(); },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(16),
                                    backgroundColor:Color.fromRGBO(55, 32, 209, 1.0),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(),
                                  ),
                                  child: Text("LOGIN",style: TextStyle(fontSize: 16),),


                                )
                            ),


                          ],
                        )
                    ),
                    SizedBox(height: 20,),

                    Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dont have an acount?" , style: TextStyle(fontSize: 12 , color: Colors.grey),),
                          GestureDetector(

                            onTap:() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register())
                              );
                            },
                            child: Text("Sign up" , style: TextStyle(color: Color.fromRGBO(55, 32, 209, 1.0)),),
                          )

                        ],
                      ),



                  ],
                )
            )

        ),
      ) : Center(child: CircularProgressIndicator()),


    );
  }
}