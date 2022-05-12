import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Model/userDeliveryInformationModel.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';
import 'package:shop_app/admin/adminUtils.dart';
import 'package:shop_app/utils/magic_strings.dart';
import 'package:shop_app/utils/widgets.dart';

class Cancelled extends StatefulWidget {
  const Cancelled({Key? key}) : super(key: key);

  @override
  State<Cancelled> createState() => _CancelledState();
}

class _CancelledState extends State<Cancelled> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();

  String? encrpytedPassword;

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferenceData;
  }

  get getSharedPreferenceData async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() => encrpytedPassword =
        sharedPreferences.getString(SharedPreferencesNames.password));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Cancelled Orders")
              .orderBy("date made")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Center(
                child: Text("No orders have to be cancelled"),
              );
            return Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot keyword = snapshot.data!.docs[index];
                  UserDeliveryModel userDeliveryModel =
                      UserDeliveryModel.fromJson(
                          keyword.data() as Map<String, dynamic>);

                  return InkWell(
                    onLongPress: userDeliveryModel.refunded == "true"
                        ? (() => Fluttertoast.showToast(
                            msg: "Item Already Refunded",
                            toastLength: Toast.LENGTH_LONG))
                        : (() =>
                            refundConfirmDialog(context, userDeliveryModel)),
                    onTap: (() => details(
                        context, snapshot, index, userDeliveryModel, size)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        child: Card(
                          elevation: 17.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: size.width * 0.50),
                                      child: Text(
                                          'Client Name: ${userDeliveryModel.clientName}',
                                          maxLines: 1),
                                    ),
                                    if (userDeliveryModel.refunded ==
                                        'true') ...[
                                      Container(
                                        color: Colors.green,
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Refunded",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  'Address: ${userDeliveryModel.address}',
                                  maxLines: 1,
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                    Text(
                                        'Date Cancelled: ${DateFormat.yMMMEd().format(userDeliveryModel.dateMade!.toDate())}',
                                        maxLines: 1),
                                    Text(
                                        ' @ ${DateFormat('K:mm a').format(userDeliveryModel.dateMade!.toDate())}',
                                        maxLines: 1),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> refundConfirmDialog(
      BuildContext context, UserDeliveryModel userDeliveryModel) {
    return showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Enter Password"),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: TextFormField(
                    decoration: textFieldInputDecorationForLoginPagePassword(
                      context,
                      "Enter Password",
                      IconButton(
                        iconSize: 28,
                        color: Theme.of(context).primaryColor,
                        icon: Icon(_obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    controller: _passwordController,
                    validator: (value) =>
                        value!.isEmpty ? "Enter Password" : null),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var isCorrect = new DBCrypt().checkpw(
                        _passwordController.text.trim(), encrpytedPassword!);

                    if (isCorrect == true) {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Confirm Order Refunded"),
                              content: SingleChildScrollView(
                                  child: Text(
                                      "By clicking confirm, you're agreeing that this client has recieved a refund.")),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection("Cancelled Orders")
                                          .doc(userDeliveryModel.compoundKey)
                                          .update({'refunded': true}).then(
                                              (value) {
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg: "Confirmation Saved");
                                      });
                                    },
                                    child: Text("Confirm"))
                              ],
                            );
                          });
                    } else
                      Fluttertoast.showToast(
                          msg: "Password Incorrect",
                          toastLength: Toast.LENGTH_LONG);
                  }
                },
                child: Text("Confirm and Proceed"),
              ),
            ],
          );
        });
      },
    );
  }

  Future<dynamic> details(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      int index,
      UserDeliveryModel userDeliveryModel,
      Size size) {
    return showDialog(
      context: context,
      builder: (context) {
        double total = 0;
        for (var i in snapshot.data!.docs[index]['products infor']) {
          total += double.parse(i['price']) * double.parse(i['Quantity']);
        }
        return AlertDialog(
          title: Text("Cancelled Orders"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    constraintBox(
                      Text('Client Name: ${userDeliveryModel.clientName}'),
                      context,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    constraintBox(
                      Text('Address: ${userDeliveryModel.address}'),
                      context,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    constraintBox(
                      Text(
                          'Delivery Personnel: ${userDeliveryModel.deliveryProgress}'),
                      context,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    constraintBox(
                      Text(""),
                      context,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    constraintBox(
                      Text('Delivered to: ${userDeliveryModel.directions}'),
                      context,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Products",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    for (var i in snapshot.data!.docs[index]['products infor'])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Image(
                              image: NetworkImage(i['img']),
                              loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : Center(
                                        child: CircularProgressIndicator());
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Icon(Icons.broken_image_outlined),
                                );
                              },
                              fit: BoxFit.cover,
                              height: size.height * 0.06,
                              width: size.width * 0.10,
                            ),
                            Text(
                              i['name'],
                            ),
                            Text(
                              "\t\$${i['price']}",
                            ),
                            Text(
                              "\t * ${i['Quantity']}",
                            ),
                          ],
                        ),
                      )
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('\$${total.toString()}'),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Ok"))
          ],
        );
      },
    );
  }
}
