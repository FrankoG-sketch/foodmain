import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/CartModel.dart';
import 'package:shop_app/pages/cart/cartComponents.dart';
import 'package:shop_app/utils/magic_strings.dart';
import 'package:shop_app/utils/widgets.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Cart"),
      ),
      body: Container(
        // height: size.height,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: FutureBuilder(
            future: getCurrentUID(),
            builder: (context, AsyncSnapshot snapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    //.collection('userInformation')
                    // .doc(snapshot.data)
                    .collection('Cart')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.data!.docs.isEmpty)
                    return Center(
                      child: Text("Nothing added to cart"),
                    );
                  return CartList(documents: snapshot.data!.docs);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class CartList extends StatefulWidget {
  CartList({Key? key, this.documents}) : super(key: key);
  final List<DocumentSnapshot>? documents;

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final formatCurrency = new NumberFormat.simpleCurrency();

  //double checkoutTotal = 0.0;

  Future<void> _getUid() async {
    var uid = await getCurrentUID();
    setState(() {
      uidKey = uid;
    });
  }

  var uidKey;
  var uid;

  @override
  void initState() {
    _getUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder<QuerySnapshot<CartModel>>(
            stream: FirebaseFirestore.instance
                .collection('Cart')
                .where('uid', isEqualTo: uidKey)
                .withConverter<CartModel>(
                  fromFirestore: (snapshots, _) =>
                      CartModel.fromJson(snapshots.data()!),
                  toFirestore: (movie, _) => movie.toJson(),
                )
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<CartModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 15.0),
                      Text("Loading....."),
                    ],
                  ),
                );
              else if (snapshot.connectionState == ConnectionState.active) {
                double total = 0;

                snapshot.data!.docs.forEach((element) {
                  total += double.parse(element.data().price!) *
                      double.parse(element.data().quantity!);
                });
                return Column(
                  children: [
                    Scrollbar(
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemBuilder: (context, index) {
                              DocumentSnapshot point =
                                  snapshot.data!.docs[index];
                              double myPrices = double.parse(
                                point['price'].toString().replaceAll(",", ""),
                              );
                              int myQuantity = int.parse(
                                point['Quantity']
                                    .toString()
                                    .replaceAll(",", ""),
                              );

                              return Column(
                                children: [
                                  Container(
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DeleteOption(
                                              document:
                                                  snapshot.data!.docs[index],
                                            );
                                          },
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Image(
                                                image: NetworkImage(
                                                    '${point['img']}'),
                                                loadingBuilder:
                                                    (context, child, progress) {
                                                  return progress == null
                                                      ? child
                                                      : CircularProgressIndicator();
                                                },
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                      size: 50,
                                                    ),
                                                  );
                                                },
                                                fit: BoxFit.cover,
                                                height: 50.0,
                                                width: 50.0,
                                              ),
                                              Text(
                                                '${point['name']}',
                                                style: TextStyle(
                                                  fontFamily: 'PlayfairDisplay',
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              Text(
                                                '${formatCurrency.format(myPrices)}',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'PlayfairDisplay - Regular',
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text("x"),
                                                  Text(
                                                    myQuantity.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Total: \$${total.toString()}',
                      style: TextStyle(fontSize: 20.0, color: Colors.red),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      width: size.width * 0.80,
                      height: size.height * 0.06,
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return AlertDialog(
                                  title: Stack(
                                    children: [
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 11.0),
                                            child:
                                                Text("We now do Shipping!!!"),
                                          )),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: Icon((Icons.close))),
                                      )
                                    ],
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/deliveryTruck.png'),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "Give us the task to delivery all of your products to you at a reasonable cost."),
                                              TextSpan(
                                                text: " read delivery policy",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = (() {
                                                        Navigator.pop(context);
                                                        shippingPolicy(
                                                            context, size);
                                                      }),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    pickUpMethod(context),
                                    deliveryOption(context, size, snapshot),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Check Out",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                );
              }
              return Center(
                child: Text("Nothing"),
              );
            },
          );
        },
      ),
    );
  }

  TextButton pickUpMethod(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (builder) {
                return CheckOutDialog();
              });
        },
        child: Text("Pick Up"));
  }

  TextButton deliveryOption(
    BuildContext context,
    Size size,
    AsyncSnapshot<QuerySnapshot<CartModel>> snapshot,
  ) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        showBottomSheet(
          context: context,
          builder: (builder) {
            return SingleChildScrollView(
              child: Container(
                height: size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Wrap(
                          children: [
                            Text(
                              "A fee of \$2500.00 JMD will be charged for each delivery",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.50,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot point = snapshot.data!.docs[index];

                          double myPrices = double.parse(
                            point['price'].toString().replaceAll(",", ""),
                          );
                          int myQuantity = int.parse(
                            point['Quantity'].toString().replaceAll(",", ""),
                          );

                          //print(mean);
                          return Column(
                            children: [
                              SingleChildScrollView(
                                child: Container(
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DeleteOption(
                                            document:
                                                snapshot.data!.docs[index],
                                          );
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image(
                                              image: NetworkImage(
                                                  '${point['img']}'),
                                              loadingBuilder:
                                                  (context, child, progress) {
                                                return progress == null
                                                    ? child
                                                    : CircularProgressIndicator();
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: Icon(
                                                    Icons.broken_image_outlined,
                                                    size: 50,
                                                  ),
                                                );
                                              },
                                              fit: BoxFit.cover,
                                              height: 50.0,
                                              width: 50.0,
                                            ),
                                            Text(
                                              '${point['name']}',
                                              style: TextStyle(
                                                fontFamily: 'PlayfairDisplay',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Text(
                                              '${formatCurrency.format(myPrices)}',
                                              style: TextStyle(
                                                fontFamily:
                                                    'PlayfairDisplay - Regular',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text("x"),
                                                Text(
                                                  myQuantity.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                        'PlayfairDisplay - Regular',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      height: MediaQuery.of(context).size.height / 10,
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          final List<DocumentSnapshot<CartModel>> documents =
                              snapshot.data!.docs;

                          Navigator.pushNamed(
                            context,
                            RouteNames.delieveryCheckOut,
                            arguments: documents.map<CartModel>((doc) {
                              return doc.data()!;
                            }).toList(),
                          );
                        },
                        child: Text(
                          "Deliver to me",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text("Ship Goods"),
    );
  }
}

class CheckOutDialog extends StatefulWidget {
  @override
  _CheckOutDialogState createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PageController? pageController;

  String _errorMessage = '';

  String? itemName;
  Timestamp? date;
  String? img;
  String? price;
  String? supermarket;
  String? userName;
  String? uid;
  String? quantity;

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            title: Text("Items Checking Out"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Column(
            children: [
              SingleChildScrollView(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0)),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot keyword = snapshot.data!.docs[index];

                    // CartModel cartModel = CartModel.fromJson(
                    //     keyword.data() as Map<String, dynamic>);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      tileColor: Theme.of(context).cardColor,
                      leading: ClipOval(
                        child: Image(
                          image: NetworkImage(keyword['img']),
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : CircularProgressIndicator();
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 50,
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                          height: 50.0,
                          width: 50.0,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text('Product Name: ${keyword['name']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Item Price: ${keyword['price']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Amount: ${keyword['Quantity']}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Spacer(),
              SizedBox(
                height: size.height * 0.08,
                width: size.width * 0.80,
                child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    double total = 0;

                    snapshot.data!.docs.forEach((element) {
                      quantity = element.data().quantity!;
                      itemName = element.data().productName!;
                      img = element.data().img!;
                      date = element.data().date!;
                      price = element.data().price!;
                      supermarket = element.data().supermarket!;
                      userName = element.data().userName;
                      total += double.parse(price!) * double.parse(quantity!);
                    });

                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            title: Text("Payment Method"),
                            content: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Total: \$$total",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    TextFormField(
                                        decoration: textFieldInputDecoration(
                                            context, "Enter Card Number"),
                                        validator: (value) => value!.isEmpty ||
                                                value.length < 16
                                            ? 'Please enter valid card number'
                                            : null,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel")),
                              TextButton(
                                  onPressed: () async {
                                    var ordersObject = {
                                      "date": date,
                                      "quantity": quantity,
                                      "imageUrl": img,
                                      "product name": itemName,
                                      "price": price,
                                      "supermarket": supermarket,
                                      "uid": uid,
                                      "client name": userName,
                                      "delivery": false,
                                    };
                                    if (_formKey.currentState!.validate()) {
                                      // print('information: $inventoryObject');
                                      FirebaseFirestore.instance
                                          .collection("Orders")
                                          .add(ordersObject)
                                          .then(
                                        (value) {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  RouteNames.homePage,
                                                  (Route<dynamic> route) =>
                                                      false);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "We will validate this transaction, this may take a couple of minutes");
                                        },
                                      );
                                    }
                                  },
                                  child: Text("Pay Now"))
                            ],
                          );
                        });
                  },
                  child: Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        );
      },
    );
  }

  void confirm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Navigator.of(context).pushNamedAndRemoveUntil(
            RouteNames.homePage, (Route<dynamic> route) => false);
        Fluttertoast.showToast(
          msg:
              "We will validate this transaction then send you an Order ID shortly.",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey[700],
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );
      } catch (e) {
        setState(() {
          isloading = false;
          _errorMessage = e.toString();
        });
        print(e);
      }
    }
  }
}
