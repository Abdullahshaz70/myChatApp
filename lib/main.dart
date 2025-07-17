import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';
import 'chats.dart';

// Color.fromRGBO(55, 32, 209, 1.0))

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? user = FirebaseAuth.instance.currentUser;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: user == null ? Login() : Chats(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      initialRoute: '/',
      routes: {
      '/': (context) => Login(),
       },
    );
  }
}

  // class MyHomePage extends StatefulWidget {
  //   const MyHomePage({super.key});
  //
  //   @override
  //   State<MyHomePage> createState() => _MyHomePageState();
  // }
  //
  // class _MyHomePageState extends State<MyHomePage> {
  //
//   TextEditingController _messageController = TextEditingController();
//
//   @override
//
//   void dispose(){
//     super.dispose();
//     _messageController.dispose();
//   }
//
//
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Username"),
//       ),
//
//       body: Column(
//         children: [
//           Expanded(
//               child: Center(
//                 child: Text("No messages yet....",style: TextStyle(color: Colors.grey),),
//               )
//           ),
//
//           Padding(
//               padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: InputDecoration(
//                         hintText: "Type a message ...",
//                       ),
//                     )
//                 ),
//
//                 IconButton(
//                     onPressed: (){_messageController.clear();},
//                     icon: Icon(Icons.send),
//                 ),
//
//               ],
//             ),
//           ),
//
//         ],
//
//       ),
//
//     );
//
//   }
// }
