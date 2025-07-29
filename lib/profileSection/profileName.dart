import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import '../providers/userProvider.dart';


class ProfileName extends StatefulWidget {
  @override
  State<ProfileName> createState() => _ProfileName();
}

class _ProfileName extends State<ProfileName> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      if (user != null) {
        _controller.text = user.name;
      }

      FocusScope.of(context).requestFocus(_focusNode);

    });



  }
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Name"),
      ),
      body: GestureDetector(

        onTap: ()=> FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              maxLength: 25,
                              controller: _controller,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                label: Text("Name"),
                                border: OutlineInputBorder(),
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              "People will see this name",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async{

                      final name = _controller.text.trim();

                      if(name.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Name can't be empty")),
                        );
                        return;
                      }

                      final user = Provider.of<UserProvider>(context, listen: false).user;
                      if (user == null) return;

                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(user.uid)
                          .update({'name': name});

                      Provider.of<UserProvider>(context, listen: false).setName(name);

                      Navigator.pop(context);

                    },
                    child: Text("Save"),
                  ),
                ),
              ),
            ],
          ),
        ),
      )



    );
  }
}
