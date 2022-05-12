import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/CartModel.dart';
import 'package:shop_app/utils/store_provider.dart';

import '../utils/magic_strings.dart';

class DeliveryCheckOut extends ConsumerStatefulWidget {
  DeliveryCheckOut({required this.documents});
  final List<CartModel> documents;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryCheckOutState();
}

class _DeliveryCheckOutState extends ConsumerState<DeliveryCheckOut> {
  bool isloading = false;

  var addressSaved;

  bool pageLoad = true;

  get getCartData async {}

  get getSharedPreferenceData async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        addressSaved =
            sharedPreferences.getString(SharedPreferencesNames.address);
        address.text = '$addressSaved';
        pageLoad = false;
      });
  }

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController directions = TextEditingController();
  TextEditingController address = TextEditingController();

  //..text = '$addressSaved';

  String? itemName;
  Timestamp date = Timestamp.now();
  String? img;
  String? price;
  String? supermarket;
  String? userName;
  String? uid;
  String? quantity;

  late String _currentSupermarket;

  @override
  void initState() {
    super.initState();
    getSharedPreferenceData;

    _currentSupermarket = ref.read(storeProvider);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.documents.runtimeType);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot<CartModel>>(
        stream: FirebaseFirestore.instance
            .collection("Cart")
            .where("uid", isEqualTo: uid)
            .withConverter<CartModel>(
                fromFirestore: (snapshots, _) =>
                    CartModel.fromJson(snapshots.data()!),
                toFirestore: (cop, _) => cop.toJson())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<CartModel>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('Delivery Check Out'),
            ),
            body: pageLoad
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Container(
                      child: Form(
                        key: _formkey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: SizedBox(
                                  //width: MediaQuery.of(context).size.width - 50,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(10.0))),
                                        labelText: "Enter directions details",
                                        hintStyle: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
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
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(10.0))),
                                      labelText: "Enter address",
                                      labelStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    validator: (value) => value!.isEmpty
                                        ? 'Please enter a valid address'
                                        : null,
                                    //  initialValue: addressSaved,
                                    keyboardType: TextInputType.text,
                                    controller: address,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: SizedBox(
                                  //  width: MediaQuery.of(context).size.width - 50,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(10.0))),
                                        labelText: "Enter Card Number",
                                        labelStyle: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
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
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  child: isloading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                Theme.of(context).primaryColor),
                                          ),
                                        )
                                      : SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          width: double.infinity,
                                          child: MaterialButton(
                                            onPressed: () async {
                                              if (_formkey.currentState!
                                                  .validate()) {
                                                try {
                                                  if (mounted) {
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                  }
                                                  var uid =
                                                      await getCurrentUID();

                                                  final FirebaseAuth _auth =
                                                      FirebaseAuth.instance;
                                                  double total = 0;

                                                  snapshot.data!.docs
                                                      .forEach((element) {
                                                    quantity = element
                                                        .data()
                                                        .quantity!;
                                                    itemName = element
                                                        .data()
                                                        .productName!;
                                                    img = element.data().img!;
                                                    date = element.data().date!;
                                                    price =
                                                        element.data().price!;
                                                    supermarket = element
                                                        .data()
                                                        .supermarket!;
                                                    userName =
                                                        element.data().userName;
                                                    total += double.parse(
                                                            price!) *
                                                        double.parse(quantity!);

                                                    var ordersObject = {
                                                      "date": date,
                                                      "quantity": quantity,
                                                      "imageUrl": img,
                                                      "product name": itemName,
                                                      "price": price,
                                                      "supermarket":
                                                          supermarket,
                                                      "uid": uid,
                                                      "client name": userName,
                                                      "delivery": true,
                                                    };
                                                    FirebaseFirestore.instance
                                                        .collection("Orders")
                                                        .add(ordersObject);
                                                  });

                                                  FirebaseFirestore.instance
                                                      .collection('Delivery')
                                                      .doc(uid)
                                                      .set({
                                                    'directions':
                                                        directions.text,
                                                    'address': address.text,
                                                    "Delivery Progress":
                                                        'pending',
                                                    "Client name": _auth
                                                        .currentUser!
                                                        .displayName,
                                                    "uid": uid,
                                                    "date": date,
                                                    "products infor": this
                                                        .widget
                                                        .documents
                                                        .map<
                                                                Map<String,
                                                                    dynamic>>(
                                                            (e) => e.toJson())
                                                        .toList(),
                                                    "supermarket":
                                                        _currentSupermarket,
                                                    "selected personal": null
                                                  }).then((value) {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "We will validate this transaction then send you an Order ID shortly.",
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.grey[700],
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      textColor: Colors.white,
                                                    );
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            RouteNames.homePage,
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  });
                                                } catch (e) {
                                                  print(e);
                                                }
                                              }
                                            },
                                            color:
                                                Theme.of(context).primaryColor,
                                            textColor: Colors.white,
                                            child: new Text("Confirm & Pay",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            splashColor: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Divider(thickness: 3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        });
  }
}

// class DeliveryCheckOut extends StatefulWidget {
//   DeliveryCheckOut({required this.documents});
//   final documents;

//   @override
//   State<DeliveryCheckOut> createState() => _DeliveryCheckOutState();
// }

// class _DeliveryCheckOutState extends State<DeliveryCheckOut> {
//   bool isloading = false;

//   var addressSaved;

//   bool pageLoad = true;

//   get getCartData async {}

//   get getSharedPreferenceData async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     if (mounted)
//       setState(() {
//         addressSaved =
//             sharedPreferences.getString(SharedPreferencesNames.address);
//         address.text = '$addressSaved';
//         pageLoad = false;
//       });
//   }

//   GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   TextEditingController directions = TextEditingController();
//   TextEditingController address = TextEditingController();

//   //..text = '$addressSaved';

//   late String _currentSupermarket;

//   @override
//   void initState() {
//     super.initState();
//     getSharedPreferenceData;

//     _currentSupermarket = ref.read(storeProvider);
//   }

//   // @override
//   // void dispose() {
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         title: Text('Delivery Check Out'),
//       ),
//       body: pageLoad
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Container(
//                 child: Form(
//                   key: _formkey,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 35.0),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 50.0),
//                           child: SizedBox(
//                             //width: MediaQuery.of(context).size.width - 50,
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                       borderRadius: new BorderRadius.all(
//                                           new Radius.circular(10.0))),
//                                   labelText: "Enter directions details",
//                                   hintStyle: TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.bold)),
//                               validator: (value) => value!.isEmpty
//                                   ? 'Please enter your card details'
//                                   : null,
//                               keyboardType: TextInputType.text,
//                               controller: directions,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 50.0),
//                           child: SizedBox(
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                     borderRadius: new BorderRadius.all(
//                                         new Radius.circular(10.0))),
//                                 labelText: "Enter address",
//                                 labelStyle: TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               validator: (value) => value!.isEmpty
//                                   ? 'Please enter a valid address'
//                                   : null,
//                               //  initialValue: addressSaved,
//                               keyboardType: TextInputType.text,
//                               controller: address,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 50.0),
//                           child: SizedBox(
//                             //  width: MediaQuery.of(context).size.width - 50,
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                       borderRadius: new BorderRadius.all(
//                                           new Radius.circular(10.0))),
//                                   labelText: "Enter Card Number",
//                                   labelStyle: TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.bold)),
//                               validator: (value) => value!.isEmpty
//                                   ? 'Please enter your card details'
//                                   : null,
//                               keyboardType: TextInputType.number,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 20.0),
//                           child: Container(
//                             width: MediaQuery.of(context).size.width - 50,
//                             height: MediaQuery.of(context).size.height / 15,
//                             child: isloading
//                                 ? Center(
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 3,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                           Theme.of(context).primaryColor),
//                                     ),
//                                   )
//                                 : SizedBox(
//                                     height:
//                                         MediaQuery.of(context).size.height / 15,
//                                     width: double.infinity,
//                                     child: MaterialButton(
//                                       onPressed: () async {
//                                         if (_formkey.currentState!.validate()) {
//                                           try {
//                                             if (mounted) {
//                                               setState(() {
//                                                 isloading = true;
//                                               });
//                                             }
//                                             var uid = await getCurrentUID();

//                                             var date = DateTime.now();

//                                             final FirebaseAuth _auth =
//                                                 FirebaseAuth.instance;

//                                             FirebaseFirestore.instance
//                                                 .collection('Delivery')
//                                                 .doc(uid)
//                                                 .set({
//                                               'directions': directions.text,
//                                               'address': address.text,
//                                               "Delivery Progress": 'pending',
//                                               "Client name": _auth
//                                                   .currentUser!.displayName,
//                                               "uid": uid,
//                                               "date": date,
//                                               "products infor":
//                                                   this.widget.documents,
//                                               "selected personal": null
//                                             }).then((value) {
//                                               Fluttertoast.showToast(
//                                                 msg:
//                                                     "We will validate this transaction then send you an Order ID shortly.",
//                                                 gravity: ToastGravity.CENTER,
//                                                 backgroundColor:
//                                                     Colors.grey[700],
//                                                 toastLength: Toast.LENGTH_LONG,
//                                                 textColor: Colors.white,
//                                               );
//                                               Navigator.of(context)
//                                                   .pushNamedAndRemoveUntil(
//                                                       RouteNames.homePage,
//                                                       (Route<dynamic> route) =>
//                                                           false);
//                                             });
//                                           } catch (e) {
//                                             print(e);
//                                           }
//                                         }
//                                       },
//                                       color: Theme.of(context).primaryColor,
//                                       textColor: Colors.white,
//                                       child: new Text("Confirm & Pay",
//                                           style:
//                                               TextStyle(color: Colors.white)),
//                                       splashColor: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         SizedBox(height: 15.0),
//                         Divider(thickness: 3),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
