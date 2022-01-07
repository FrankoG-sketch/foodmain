import 'package:flutter/material.dart';

class Popularitems extends StatelessWidget {
  const Popularitems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Popular items'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
