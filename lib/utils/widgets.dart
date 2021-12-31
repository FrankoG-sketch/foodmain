import 'package:flutter/material.dart';

SnackBar snackBarWidget(Widget content, Color color) {
  return SnackBar(content: content, backgroundColor: color);
}

InputDecoration textFieldInputDecoration(
    BuildContext context, String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      fontFamily: 'PlayfairDisplay-Regular',
      fontSize: 15.0,
    ),
    focusColor: Theme.of(context).primaryColor,
  );
}

InputDecoration textFieldInputDecorationForLoginPagePassword(
    BuildContext context, String labelText, IconButton suffixIcon) {
  return InputDecoration(
    suffixIcon: suffixIcon,
    focusColor: Theme.of(context).primaryColor,
    labelText: labelText,
    labelStyle: TextStyle(
      fontFamily: 'PlayfairDisplay-Regular',
      fontSize: 15.0,
    ),
  );
}
