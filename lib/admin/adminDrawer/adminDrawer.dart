import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';

class AdminDrawerClass extends StatelessWidget {
  const AdminDrawerClass({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
