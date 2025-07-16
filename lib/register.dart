import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Register extends StatefulWidget{
  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register>{

  final _formKey = GlobalKey<FormState>();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _mailController = TextEditingController();

  bool _imageLoaded = false;

  @override

  void dispose(){
    super.dispose();
    _numberController.dispose();
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
  print("hehe");
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
                              child:
                              IntlPhoneField(
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                initialCountryCode: 'PK', // Default country
                                onChanged: (phone) {
                                  print(phone.completeNumber); // full number with code
                                },
                              ),
                              // TextFormField(
                              //   // validator:,
                              //   controller: _numberController,
                              //   decoration: InputDecoration(
                              //       border: OutlineInputBorder(),
                              //       hintText: "Enter Your Number",
                              //       labelText: "Number",
                              //       suffixIcon: Icon(Icons.phone, color: Color.fromRGBO(55, 32, 209, 1.0),)
                              //   ),
                              // )

                            ),

                            SizedBox(height: 20,),

                            Container(
                                width: 150,
                                child:ElevatedButton(
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(16),
                                    backgroundColor:Color.fromRGBO(55, 32, 209, 1.0),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(),
                                  ),
                                  child: Text("SEND OTP",style: TextStyle(fontSize: 16),),


                                )
                            ),
                          ],
                        )
                    ),


                  ],
                )
            )

        ),
      ) : Center(child: CircularProgressIndicator()),


    );
  }
}