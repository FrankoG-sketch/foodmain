import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Admin HomePage"),
      ),
      drawer: Drawer(
        child: Center(
          child: ListView(
            children: [
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () async {
                  Authentication().signOut(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
