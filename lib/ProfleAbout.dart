
import 'package:flutter/material.dart';


class ProfileAbout extends StatefulWidget {
  @override
  State<ProfileAbout> createState() => _ProfileAbout();
}

class _ProfileAbout extends State<ProfileAbout> {
  final TextEditingController _controller = TextEditingController();


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: SafeArea(
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
                            maxLength: 50,
                            controller: _controller,
                            decoration: InputDecoration(
                              label: Text("About"),
                              suffixIcon: Icon(Icons.edit),
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "People will see this About ",
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
                  onPressed: () {
                    // Save logic
                  },
                  child: Text("Save"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
