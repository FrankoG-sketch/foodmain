import 'package:flutter/material.dart';

class Specialitems extends StatelessWidget {
  const Specialitems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Special items'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
