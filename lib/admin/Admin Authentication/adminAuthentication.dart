import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/utils/widgets.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

getCurrentUser() async {
  final User user = _auth.currentUser!;
  return user.uid;
}

getToken() async {
  final token = await FirebaseMessaging.instance.getToken();
  print('token: ' + token!);
  return token;
}

Future<String> getCurrentUID() async {
  return _auth.currentUser!.uid;
}

class AdminAuthentication {
  Future signUp(BuildContext context, String email, String name,
      String password, String address, VoidCallback callBack) async {
    try {
      var token = await getToken();
      FocusScope.of(context).requestFocus(FocusNode());

      UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((error) {
        callBack();
        var snackBar = snackBarWidget(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.80,
                    ),
                    child: Text(
                        "The email address is already in use by another account.",
                        style: TextStyle(color: Colors.white))),
                Icon(
                  Icons.error_outline_sharp,
                  color: Colors.white,
                )
              ],
            ),
            Colors.red);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });

      User user = result.user!;
      var uid = await getCurrentUser();
      var date = DateTime.now();
      double ratings = 0.0;
      String blankPhoto =
          'https://firebasestorage.googleapis.com/v0/b/jmarket-9aa0f.appspot.com/o/profile.png?alt=media&token=43d9378c-3f32-4cf8-b726-1a35f8e18f46';

      String path = '';
      String role = "Delivery";

      var usersObject = {
        'FullName': name,
        'email': email,
        'address': address,
        'imgUrl': blankPhoto,
        'uid': uid,
        'path': path,
        'date': date,
        'role': role,
        'ratings': ratings,
      };

      var userInformationObject = {
        'FullName': name,
        'email': email,
        'Date': date,
        'token': token,
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

      await result.user!.updateDisplayName(name);
      await result.user!.updateEmail(email);
      await result.user!.updatePhotoURL(blankPhoto);
      await result.user!.reload();
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
    } on FirebaseException catch (e) {
      callBack();
      var error = e.message.toString().replaceAll(
          'com.google.firebase.FirebaseException: An internal error has' +
              ' occurred. [ Unable to resolve host "www.googleapis.com":' +
              "No address associated with hostname ]",
          "Please Check Network Connection");

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
      print('error: ${e.toString()}');
      return null;
    }
  }
}
