import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Authentication/auth.dart';

class DeliveryCheckOut extends StatefulWidget {
  DeliveryCheckOut({required this.documents});
  final documents;

  @override
  State<DeliveryCheckOut> createState() => _DeliveryCheckOutState();
}

class _DeliveryCheckOutState extends State<DeliveryCheckOut> {
  var addressSaved;
  bool isloading = false;

  get getCartData async {}

  get getSharedPreferenceData async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      addressSaved = sharedPreferences.getString('address');
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferenceData;

    print(this.widget.documents);
    // this.widget.documents.map((doc) {
    //   print(doc.data()['name']);
    // });
  }

  @override
  void dispose() {
    super.dispose();
    getSharedPreferenceData;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    TextEditingController directions = TextEditingController();
    TextEditingController address = TextEditingController()
      ..text = '$addressSaved';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Delivery Check Out'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formkey,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(10.0))),
                              labelText: "Enter directions details",
                              hintStyle: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your card details'
                              : null,
                          keyboardType: TextInputType.text,
                          controller: directions,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(10.0))),
                            labelText: "Enter address",
                            labelStyle: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a valid address'
                              : null,
                          // initialValue: addressSaved,
                          keyboardType: TextInputType.text,
                          controller: address,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(10.0))),
                              labelText: "Enter Card Number",
                              labelStyle: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your card details'
                              : null,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: MediaQuery.of(context).size.height / 15,
                        child: isloading
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                ),
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width - 50,
                                child: MaterialButton(
                                  onPressed: () async {
                                    if (_formkey.currentState!.validate()) {
                                      try {
                                        if (mounted) {
                                          setState(() {
                                            isloading = true;
                                          });
                                        }
                                        var uid = await getCurrentUID();

                                        var date = DateTime.now();

                                        final FirebaseAuth _auth =
                                            FirebaseAuth.instance;

                                        FirebaseFirestore.instance
                                            .collection('Delivery')
                                            .add({
                                          'directions': directions.text,
                                          'address': address.text,
                                          "Delivery Progress": 'pending',
                                          "Client name":
                                              _auth.currentUser!.displayName,
                                          "uid": uid,
                                          "date": date,
                                          "products infor":
                                              this.widget.documents
                                        }).then((value) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "We will validate this transaction then send you an Order ID shortly.",
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey[700],
                                            toastLength: Toast.LENGTH_LONG,
                                            textColor: Colors.white,
                                          );
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/homePage',
                                                  (Route<dynamic> route) =>
                                                      false);
                                        });
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                  },
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  child: new Text("Confirm & Pay",
                                      style: TextStyle(color: Colors.white)),
                                  splashColor: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    // Text(
                    //   _errorMessage,
                    //   textAlign: TextAlign.center,
                    // ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Divider(
                      thickness: 3,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
