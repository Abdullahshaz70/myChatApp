import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class Register extends StatefulWidget{
  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register>{

  final _formKey = GlobalKey<FormState>();
  TextEditingController _conformPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;

  bool _isObsecure = true;
  bool _isObsecureConfirm = true;
  String name ="";
  String email = "";
  String password = "";
  String confirmPassword = "";

  @override


  void validateForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      name = _nameController.text.trim();
      email = _mailController.text.trim();
      password = _passwordController.text.trim();
      confirmPassword = _conformPasswordController.text.trim();

      if (password == confirmPassword) {
        saveInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void saveInfo() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'name': name,
        'uid': userCredential.user!.uid,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Successful")),
      );

      Navigator.pop(context);
    } catch (e) {
      String errorMessage = "Registration failed.";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "This email is already registered.";
            break;
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'operation-not-allowed':
            errorMessage = "Email/password accounts are not enabled.";
            break;
          case 'weak-password':
            errorMessage = "The password is too weak.";
            break;
          default:
            errorMessage = e.message ?? errorMessage;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        behavior: HitTestBehavior.opaque,
        
        child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  
                  Center(
                    child: Text("Create your Account" , style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold, color: Colors.grey) ,),
                  ),
                  SizedBox(height: 10,),

                  Form(
                    key: _formKey,

                    child: Column(
                      children: [

                        Container(
                          width: 250,
                          child:TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Name';
                              }
                              return null;
                            },
                            controller: _nameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter Your Name",
                                labelText: "Name",
                                suffixIcon: Icon(Icons.person, color: Color.fromRGBO(55, 32, 209, 1.0),)
                            ),
                          ) ,
                        ),
                        SizedBox(height: 20,),

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
                                  }
                                  , color: Color.fromRGBO(55, 32, 209, 1.0),
                                ),
                              ),
                            )
                          // Icon(Icons.password, color: Color.fromRGBO(55, 32, 209, 1.0),)
                        ),
                        SizedBox(height: 20,),

                        Container(
                            width: 250,
                            child:TextFormField(
                              obscureText: _isObsecureConfirm,
                              validator:(value){
                                if(value==null || value.isEmpty){
                                  return " Password is Required";
                                }
                                if(value.length < 8){
                                  return "Enter a valid Password";
                                }
                                return null;
                              },
                              controller: _conformPasswordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Confirm Your Password",
                                labelText: "Confirm Password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObsecureConfirm ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObsecureConfirm = !_isObsecureConfirm;
                                    });
                                  }
                                  , color: Color.fromRGBO(55, 32, 209, 1.0),
                                ),
                              ),
                            )
                          // Icon(Icons.password, color: Color.fromRGBO(55, 32, 209, 1.0),)
                        ),
                        SizedBox(height: 20,),

                        Container(
                            width: 150,
                            child: _isLoading ? Center(child: CircularProgressIndicator(color: Color.fromRGBO(55, 32, 209, 1.0))): ElevatedButton(
                              onPressed: (){
                                validateForm();
                                },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(16),
                                backgroundColor:Color.fromRGBO(55, 32, 209, 1.0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(),
                              ),
                              child: Text("Sign up",style: TextStyle(fontSize: 16),),


                            )
                        ),
                      ],
                    ),
                  )
                  
                ],
              ),
            )
        ),
      ),
    );
  }
}