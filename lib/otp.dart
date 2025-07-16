  // import 'package:flutter/material.dart';
  // import 'package:firebase_auth/firebase_auth.dart';
  //
  //
  // class otpScreen extends StatefulWidget {
  //
  //   final String verificationId;
  //   otpScreen({super.key, required this.verificationId});
  //
  //   @override
  //   State<otpScreen> createState() => _otpScreen();
  // }
  //
  // class _otpScreen extends State<otpScreen> {
  //
  //   @override
  //
  //   void verifyPressed(){
  //
  //   }
  //
  //   Widget build(BuildContext context){
  //     return Scaffold(
  //       appBar: AppBar(),
  //       body:GestureDetector(
  //         behavior: HitTestBehavior.opaque,
  //         onTap: FocusScope.of(context).unfocus,
  //         child:Column(
  //
  //           children: [
  //             Center(child:Text("OTP" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 45),) ,),
  //             Text("You will get a One Time Password",style: TextStyle(color: Colors.grey),),
  //             SizedBox(height: 20,),
  //
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: List.generate(6, (index) {
  //                 return SizedBox(
  //                   width: 40,
  //                   child: TextField(
  //                     textAlign: TextAlign.center,
  //                     keyboardType: TextInputType.number,
  //                     maxLength: 1,
  //                     decoration: InputDecoration(
  //                       counterText: '',
  //                       border: OutlineInputBorder(),
  //                     ),
  //                   ),
  //                 );
  //               }),
  //             ),
  //             SizedBox(height: 15,),
  //
  //             Text("Resend",style: TextStyle(color: Colors.grey ,decoration: TextDecoration.underline),),
  //             SizedBox(height: 20,),
  //
  //             ElevatedButton(
  //               onPressed: (){ verifyPressed();},
  //               style: ElevatedButton.styleFrom(
  //                 padding: EdgeInsets.all(16),
  //                 backgroundColor:Color.fromRGBO(55, 32, 209, 1.0),
  //                 foregroundColor: Colors.white,
  //
  //                 shape: RoundedRectangleBorder(),
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text("VERIFY",style: TextStyle(fontSize: 16 ,),),
  //                   SizedBox(width: 8),
  //                   Icon(Icons.arrow_forward),
  //                 ],
  //               ),
  //             )
  //
  //           ],
  //         ),
  //       )
  //
  //
  //     );
  //   }
  //
  // }






  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  class otpScreen extends StatefulWidget {
    final String verificationId;
    const otpScreen({super.key, required this.verificationId});

    @override
    State<otpScreen> createState() => _otpScreenState();
  }

  class _otpScreenState extends State<otpScreen> {
    final List<TextEditingController> _otpControllers =
    List.generate(6, (_) => TextEditingController());
    bool _isLoading = false;

    void verifyPressed() async {
      final otpCode = _otpControllers.map((c) => c.text).join();

      if (otpCode.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a 6-digit OTP")),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: otpCode,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Phone verified successfully")),
        );

        // Navigate to next screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Verification failed: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    @override
    void dispose() {
      for (var controller in _otpControllers) {
        controller.dispose();
      }
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: FocusScope.of(context).unfocus,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  "OTP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                ),
                Text(
                  "You will get a One Time Password",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _otpControllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 15),
                Text(
                  "Resend",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: verifyPressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: Color.fromRGBO(55, 32, 209, 1.0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("VERIFY", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
