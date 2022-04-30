import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/utils/widgets.dart';

import '../../utils/magic_strings.dart';

class RegisterAddress extends StatefulWidget {
  const RegisterAddress({Key? key}) : super(key: key);

  @override
  State<RegisterAddress> createState() => _RegisterAddressState();
}

class _RegisterAddressState extends State<RegisterAddress> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
            child: Form(
              key: _formkey,
              child: TextFormField(
                controller: addressController,
                maxLength: 250,
                maxLines: 5,
                decoration: textFieldInputDecoration(context, 'Enter Address'),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.10),
          SizedBox(
            height: size.height * 0.10,
            width: size.width * 0.80,
            child: MaterialButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                "Save Address",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  setState(
                    () => isloading = true,
                  );

                  FocusScope.of(context).requestFocus(FocusNode());

                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();

                  var uid = await getCurrentUID();

                  sharedPreferences.setString(
                      SharedPreferencesNames.address, addressController.text);

                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(uid)
                      .update({"address": addressController.text}).then(
                          (value) {
                    Fluttertoast.showToast(
                        msg: 'Address saved',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.grey[700],
                        textColor: Colors.white);

                    callBack();

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/homePage', (Route<dynamic> route) => false);
                  }).timeout(Duration(minutes: 2), onTimeout: () {
                    setState(() {
                      print("Error");
                      Fluttertoast.showToast(
                          msg: "Could not complete task at this moment"
                              " when reconnected to a stable network connection, this task will be completed.",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey[700],
                          textColor: Colors.white);
                    });
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void callBack() {
    setState(() {
      isloading = false;
    });
  }
}
