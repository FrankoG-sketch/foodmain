import 'package:flutter/material.dart';

Widget constraintBox(take, context) {
  return ConstrainedBox(
      child: take,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.60,
      ));
}

InputDecoration adminTextField(BuildContext context, String labelText) {
  return InputDecoration(
    labelText: labelText,
    border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.white),
    ),
    fillColor: Colors.white,
    filled: true,
    labelStyle: TextStyle(
      fontSize: 15.0,
    ),
    focusColor: Theme.of(context).primaryColor,
  );
}

InputDecoration adminTextFieldForPassword(
    BuildContext context, String labelText, IconButton suffixIcon) {
  return InputDecoration(
    border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.white),
    ),
    suffixIcon: suffixIcon,
    focusColor: Theme.of(context).primaryColor,
    labelText: labelText,
    fillColor: Colors.white,
    filled: true,
    labelStyle: TextStyle(
      fontSize: 15.0,
    ),
  );
}
