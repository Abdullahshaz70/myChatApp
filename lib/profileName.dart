import 'package:flutter/material.dart';

class ProfileName extends StatefulWidget {
  @override
  State<ProfileName> createState() => _ProfileName();
}

class _ProfileName extends State<ProfileName> {
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
        title: Text("Name"),
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
                            maxLength: 25,
                            controller: _controller,
                            decoration: InputDecoration(
                              label: Text("Name"),
                              suffixIcon: Icon(Icons.face_2_outlined),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 8),

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
