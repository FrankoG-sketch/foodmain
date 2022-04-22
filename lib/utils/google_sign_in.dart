import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  // Future googleLogin() async {
  //   final googleUser = await googleSignIn.signIn();
  // }

  static Future<GoogleSignInAccount?> login() => googleSignIn.signIn();
}
