import 'package:flutter/material.dart';

class AdminSupermarket extends StatelessWidget {
  const AdminSupermarket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Supermarket"),
      ),
    );
  }
}
