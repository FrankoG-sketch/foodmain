import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';

class DeliveryPanel extends StatefulWidget {
  const DeliveryPanel({Key? key}) : super(key: key);

  @override
  State<DeliveryPanel> createState() => _DeliveryPanelState();
}

class _DeliveryPanelState extends State<DeliveryPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0),
              child: ListTile(
                title: Text("Logout "),
                trailing: Icon(Icons.exit_to_app),
                onTap: () => Authentication().signOut(context),
              ),
            ),
          ],
        ),
      ),
      body: Center(child: Text('Delivery')),
    );
  }
}
