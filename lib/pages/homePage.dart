import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Home"),
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
