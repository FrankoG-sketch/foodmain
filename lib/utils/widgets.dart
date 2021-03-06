import 'package:flutter/material.dart';

IconData? selectedIcon;

SnackBar snackBarWidget(Widget content, Color color) {
  return SnackBar(content: content, backgroundColor: color);
}

InputDecoration textFieldInputDecoration(
    BuildContext context, String labelText) {
  return InputDecoration(
    labelText: labelText,
    border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.white),
    ),
    fillColor: Colors.white,
    filled: true,
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
    border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.white),
    ),
    suffixIcon: suffixIcon,
    focusColor: Theme.of(context).primaryColor,
    hintText: labelText,
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(
      fontFamily: 'PlayfairDisplay-Regular',
      fontSize: 15.0,
    ),
  );
}

Widget structurePageHomePage(Widget widget) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: widget,
  );
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(Colors.black45, BlendMode.darken),
          image: AssetImage("assets/images/loginCover.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Image signInMethod(imageLink) {
  return Image(
    image: AssetImage(imageLink),
    height: 30,
    width: 30,
  );
}

SizedBox completedTaskButton(size, task) {
  return SizedBox(
    height: size.height * 0.10,
    width: double.infinity,
    child: task,
  );
}
