import 'dart:async';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/utils/google_sign_in.dart';
import 'package:shop_app/utils/widgets.dart';

import '../utils/magic_strings.dart';

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

class Authentication {
  //SIGN UP.....................................................................
  Future signUp(BuildContext context, String email, String name,
      String password, String address, VoidCallback callBack) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
      String blankPhoto =
          'https://firebasestorage.googleapis.com/v0/b/jmarket-9aa0f.appspot.com/o/profile.png?alt=media&token=43d9378c-3f32-4cf8-b726-1a35f8e18f46';

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
      sharedPreferences.setString(SharedPreferencesNames.name, name);
      sharedPreferences.setString(SharedPreferencesNames.address, address);
      sharedPreferences.setString(SharedPreferencesNames.email, email);

      Navigator.of(context).pushNamedAndRemoveUntil(
          '/homePage', (Route<dynamic> route) => false);
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
      print('error: ${e.toString()}');
      return null;
    }
  }

  Future facebookSignIn(BuildContext context, VoidCallback callback) async {
    final result = await FacebookAuth.instance.login(permissions: ['email']);
    final userData = await FacebookAuth.instance.getUserData();

    if (result.status == LoginStatus.success) {
      String email = userData['email'];
      String password = userData['id'].toString();

      signIn(context, email, password, () {});
      callback();
    } else if (result.status == LoginStatus.failed) {
      callback();
      var snackBar = snackBarWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  child: Text("Sign in failed",
                      style: TextStyle(color: Colors.white))),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ],
          ),
          Colors.red);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future facebookSignUp(BuildContext context, VoidCallback callBack) async {
    final result = await FacebookAuth.instance.login(permissions: ['email']);
    final userData = await FacebookAuth.instance.getUserData();

    try {
      if (result.status == LoginStatus.success) {
        String email = userData['email'].toString();
        String fullName = userData['name'].toString();
        String password = userData['id'].toString();

        signUp(context, email, fullName, password, '', () {});
        callBack();
      } else if (result.status == LoginStatus.failed) {
        print('error message: ${result.message}');
        print('object');
        callBack();
        var snackBar = snackBarWidget(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.80,
                    ),
                    child: Text("Attempt failed, please try again later",
                        style: TextStyle(color: Colors.white))),
                Icon(
                  Icons.error_outline_sharp,
                  color: Colors.white,
                )
              ],
            ),
            Colors.red);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }

  Future googleSignUp(context, VoidCallback callback) async {
    print("Google login method called");

    Size size = MediaQuery.of(context).size;

    final user = await GoogleSignInApi.login();
    var email = user?.email;
    var fullName = user?.displayName;
    var password = user?.id;

    if (user == null) {
      var error = "Failed to sign up";
      var snackBar = snackBarWidget(
          Wrap(alignment: WrapAlignment.spaceBetween, children: [
            Text(
              error,
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              Icons.error_outline_sharp,
              color: Colors.white,
            )
          ]),
          Colors.red);
      callback();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        showModalBottomSheet(
            context: context,
            builder: (dialogContext1) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(dialogContext1),
                              icon: Icon(Icons.close))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View and Complete Registration",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      SizedBox(height: size.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "FullName: $fullName",
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Email: $email",
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.10),
                      SizedBox(
                        height: size.height * 0.10,
                        width: double.infinity,
                        child: MaterialButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.of(dialogContext1, rootNavigator: true)
                                .pop();
                            signUp(context, email!, fullName!, password!, '',
                                () {});
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
        callback();
      } catch (e) {
        print('error: ${e.toString()}');
      }
    }
  }

  //Google Sign in..............................................................
  Future googleSignIn(BuildContext context, VoidCallback callback) async {
    final user = await GoogleSignInApi.login();
    var email = user?.email;
    var password = user?.id;
    try {
      if (user == null) {
        var error = "Failed to sign up";
        var snackBar = snackBarWidget(
            Wrap(alignment: WrapAlignment.spaceBetween, children: [
              Text(
                error,
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.error_outline_sharp,
                color: Colors.white,
              )
            ]),
            Colors.red);
        callback();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        signIn(context, email!, password!, () {});
      }
    } catch (e) {
      print(e);
    }
  }

  //LOGIN.......................................................................
  Future signIn(BuildContext context, String email, String password,
      VoidCallback callBack) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());

      var token = await getToken();

      var date = DateTime.now();

      var userTokenDataObject = {
        'Email': email,
        'Token': token,
        'Date': date,
      };

      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      await FirebaseFirestore.instance
          .collection('Users Token Data')
          .doc(result.user!.uid)
          .set(userTokenDataObject);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(SharedPreferencesNames.email, email);

      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(result.user!.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? fetchDoc =
            snapshot.data() as Map<String, dynamic>?;
        String role = fetchDoc?['role'];

        var fullName = fetchDoc?['FullName'];

        var address = fetchDoc?['address'];

        print("role: $role");

        print('fullName: $fullName');

        print("address: $address");

        FirebaseFirestore.instance
            .collection("Users")
            .where("uid", isEqualTo: result.user!.uid)
            .get()
            .then(
          (value) {
            if (role.isNotEmpty) {
              if (role == 'User') {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/homePage', (Route<dynamic> route) => false);

                prefs.setString(SharedPreferencesNames.name, fullName);
                prefs.setString(SharedPreferencesNames.address, address);
              } else if (role == 'Admin') {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/adminPanel', (Route<dynamic> route) => false);
                var hashedPassword =
                    new DBCrypt().hashpw(password, DBCrypt().gensalt());
                prefs.setString(
                    SharedPreferencesNames.password, hashedPassword);
              } else if (role == 'Delivery') {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/deliveryPanel', (Route<dynamic> route) => false);
              }
            }
          },
        );

        prefs.setString(SharedPreferencesNames.role, role);
      }
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
      prfs.remove('name');
      prfs.remove('address');
      prfs.remove('password');
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
