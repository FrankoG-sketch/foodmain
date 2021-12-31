import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/utils/widgets.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

getCurrentUser() async {
  final User user = _auth.currentUser;
  return user.uid;
}

Future<String> getCurrentUID() async {
  return (_auth.currentUser).uid;
}

class Authentication {
  //SIGN UP.....................................................................
  Future signUp(BuildContext context, String email, String name,
      String password, String address, VoidCallback callBack) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User user = result.user;
      var uid = await getCurrentUser();
      var date = DateTime.now();
      String blankPhoto =
          'https://firebasestorage.googleapis.com/v0/b/jmarket-9aa0f.appspot.com/o/blankprofile.png?alt=media&token=98d1a4fb-ac69-46d9-804a-9bf2d8d9cfb8';

      String path = '';
      String role = "User";

      var usersObject = {
        'FullName': name,
        'email': email,
        'address': address,
        'imgUrl': blankPhoto,
        'uid': uid,
        'path': path,
        'date': date,
        'role': role,
      };

      var userInformationObject = {
        'FullName': name,
        'email': email,
        'Date': date,
      };

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .set(usersObject);

      await FirebaseFirestore.instance
          .collection('userInformation')
          .doc(user.uid)
          .collection("users")
          .add(userInformationObject);

      await result.user.updateDisplayName(name);
      await result.user.updateEmail(email);
      await result.user.updatePhotoURL(blankPhoto);
      await result.user.reload();
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sign Up Successful", style: TextStyle(color: Colors.white)),
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              )
            ],
          ),
          Colors.green);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      callBack();
      var error = e.message.toString().replaceAll(
          'com.google.firebase.FirebaseException: An internal error has' +
              ' occurred. [ Unable to resolve host "www.googleapis.com":' +
              "No address associated with hostname ]",
          "Please Check Network Connection");

      if (e.message.toString() ==
          "The email address is already in use by another account.") {
        Navigator.pop(context);
      }

      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  child: Text("$error", style: TextStyle(color: Colors.white))),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ],
          ),
          Colors.red);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e.toString());
      return null;
    }
  }

  //LOGIN.......................................................................
  Future signIn(BuildContext context, String email, String password,
      VoidCallback callBack) async {


    try {
      FocusScope.of(context).requestFocus(FocusNode());

      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(result.user.uid)
          .get();

      String role = snapshot['role'];

      print("role: " + role);

      FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: result.user.uid)
          .get()
          .then(
        (value) {
          if (role.isNotEmpty) {
            if (role == 'User') {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/homePage', (Route<dynamic> route) => false);
            } else if (role == 'Admin') {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/adminPanel', (Route<dynamic> route) => false);
            }
          }
        },
      );

      prefs.setString('role', role);
    } on FirebaseException catch (e) {
      callBack();
      var error = e.message.toString();

      var snackBar = snackBarWidget(
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                child: Text(
                  "$error",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              ),
            ],
          ),
          Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(error);
      return null;
    }
  }

  //RESET PASSWORD..............................................................
  Future reset(
      BuildContext context, String email, VoidCallback callBack) async {
    try {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) => print("Check your email"));
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Check your email to reset password",
                  style: TextStyle(color: Colors.white)),
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              )
            ],
          ),
          Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);

      //Navigator.pushNamedAndRemoveUntil(context, '/login', (e) => false);
    } catch (e) {
      callBack();
      var error = e.toString();
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$error", style: TextStyle(color: Colors.white)),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ],
          ),
          Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print("$error");
      print("Failed to reset password");
    }
  }

  //SIGN OUT.................................................................
  Future signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      SharedPreferences prfs = await SharedPreferences.getInstance();
      prfs.remove('email');
      prfs.remove('role');
      Navigator.pushNamedAndRemoveUntil(
          context, '/signIn', (Route<dynamic> route) => false);
    } catch (e) {
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Failed to sign out",
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ],
          ),
          Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e.toString());
      return null;
    }
  }
}
