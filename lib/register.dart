import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _conformPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  bool _isVerifying = false;

  bool _isObsecure = true;
  bool _isObsecureConfirm = true;

  String name = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  Future<bool> isNameTaken(String name) async {
    final result = await FirebaseFirestore.instance
        .collection('user')
        .where('name', isEqualTo: name)
        .get();
    return result.docs.isNotEmpty;
  }

  void validateForm() async {
    if (_formKey.currentState!.validate()) {
      name = _nameController.text.trim();
      email = _mailController.text.trim();
      password = _passwordController.text.trim();
      confirmPassword = _conformPasswordController.text.trim();

      if (await isNameTaken(name)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This name is already taken")),
        );
        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        User? user = userCredential.user;

        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification email sent. Please verify and then tap the button below.")),
          );

          setState(() {
            _isVerifying = true;
            _isLoading = false;
          });
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Registration failed")),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void saveInfoIfVerified() async {
    setState(() {
      _isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
        'email': email,
        'name': name,
        'uid': user.uid,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Successful")),
      );

      await FirebaseAuth.instance.signOut();

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please verify your email first")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(50),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Create your Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField("Name", _nameController, Icons.person),
                      SizedBox(height: 20),
                      buildTextField("Email", _mailController, Icons.email, isEmail: true),
                      SizedBox(height: 20),
                      buildPasswordField("Password", _passwordController, _isObsecure, () {
                        setState(() => _isObsecure = !_isObsecure);
                      }),
                      SizedBox(height: 20),
                      buildPasswordField("Confirm Password", _conformPasswordController, _isObsecureConfirm, () {
                        setState(() => _isObsecureConfirm = !_isObsecureConfirm);
                      }),
                      SizedBox(height: 20),
                      if (!_isVerifying)
                        buildActionButton("Sign Up", validateForm)
                      else
                        buildActionButton("I have verified", saveInfoIfVerified),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon , {bool isEmail = false}) {
    return Container(
      width: 250,
      child: TextFormField(
        controller: controller,
        autofillHints: [
          isEmail ? AutofillHints.email : AutofillHints.name
        ],
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter your $label';
          if (isEmail && (!value.contains('@') || !value.contains('.'))) return 'Enter a valid email';
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Enter Your $label",
          labelText: label,
          suffixIcon: Icon(icon, color: Color.fromRGBO(55, 32, 209, 1.0)),
        ),
      ),
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller, bool isObscure, VoidCallback toggle) {
    return Container(
      width: 250,
      child: TextFormField(
        controller: controller,
        autofillHints: [AutofillHints.newPassword],
        obscureText: isObscure,
        validator: (value) {
          if (value == null || value.isEmpty) return "Password is required";
          if (value.length < 8) return "Password must be at least 8 characters";
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: label,
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
            color: Color.fromRGBO(55, 32, 209, 1.0),
          ),
        ),
      ),
    );
  }

  Widget buildActionButton(String text, VoidCallback onPressed) {
    return Container(
      width: 150,
      child: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color.fromRGBO(55, 32, 209, 1.0)))
          : ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16),
          backgroundColor: Color.fromRGBO(55, 32, 209, 1.0),
          foregroundColor: Colors.white,
        ),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
