import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/pages/deliveryCheckOut.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Cart"),
      ),
      body: Container(
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
  double value = 0.0;
  double total = 0.0;
  final formatCurrency = new NumberFormat.simpleCurrency();
  double mean = 0.0;

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
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getCurrentUID(),
            builder: (context, snapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    // .collection('userInformation')
                    // .doc(snapshot.data)
                    .collection('Cart')
                    .where('uid', isEqualTo: uidKey)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    return Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemBuilder: (context, index) {
                                DocumentSnapshot point =
                                    snapshot.data!.docs[index];

                                // if (point.id == _auth.currentUser.uid) {
                                //   return Container(height: 0);
                                // }
                                double myPrices = double.parse(
                                  point['price'].toString().replaceAll(",", ""),
                                );
                                int myQuantity = int.parse(
                                  point['Quantity']
                                      .toString()
                                      .replaceAll(",", ""),
                                );

                                value = myPrices * myQuantity;

                                total += value;

                                mean = total;
                                print(mean);

                                return Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: Container(
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return PopUp(
                                                  document: snapshot
                                                      .data!.docs[index],
                                                );
                                              },
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Image(
                                                    image: NetworkImage(
                                                        '${point['img']}'),
                                                    loadingBuilder: (context,
                                                        child, progress) {
                                                      return progress == null
                                                          ? child
                                                          : CircularProgressIndicator();
                                                    },
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(18.0),
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
                                                      fontFamily:
                                                          'PlayfairDisplay',
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
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.grey[700],
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      mean = total;
                                    },
                                  );
                                },
                                child: Text(
                                  "Click for total:",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Text(
                                '${formatCurrency.format(mean)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: MediaQuery.of(context).size.height / 10,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 11.0),
                                                child: Text(
                                                    "We now do Shipping!!!"),
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
                                                    text:
                                                        " read delivery policy",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = (() {
                                                            Navigator.pop(
                                                                context);
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
                                        PickUp(),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showBottomSheet(
                                              context: context,
                                              builder: (builder) {
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 35.0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    35.0),
                                                        child: Wrap(
                                                          children: [
                                                            Text(
                                                              "A fee of \$2500.00 JMD will be charged for each delivery",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height:
                                                          size.height * 0.50,
                                                      child: ListView.builder(
                                                        itemCount: snapshot
                                                            .data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          DocumentSnapshot
                                                              point = snapshot
                                                                  .data!
                                                                  .docs[index];

                                                          double myPrices =
                                                              double.parse(
                                                            point['price']
                                                                .toString()
                                                                .replaceAll(
                                                                    ",", ""),
                                                          );
                                                          int myQuantity =
                                                              int.parse(
                                                            point['Quantity']
                                                                .toString()
                                                                .replaceAll(
                                                                    ",", ""),
                                                          );

                                                          print(mean);
                                                          return Column(
                                                            children: [
                                                              SingleChildScrollView(
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return PopUp(
                                                                            document:
                                                                                snapshot.data!.docs[index],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            Image(
                                                                              image: NetworkImage('${point['img']}'),
                                                                              loadingBuilder: (context, child, progress) {
                                                                                return progress == null ? child : CircularProgressIndicator();
                                                                              },
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
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
                                                                                fontFamily: 'PlayfairDisplay - Regular',
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
                                                                                    fontFamily: 'PlayfairDisplay - Regular',
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              10,
                                                      child: MaterialButton(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        onPressed: () {
                                                          final List<
                                                                  DocumentSnapshot>
                                                              documents =
                                                              snapshot
                                                                  .data!.docs;

                                                          Navigator.pushNamed(
                                                            context,
                                                            '/delieveryCheckOut',
                                                            arguments:
                                                                DeliveryCheckOut(
                                                                    documents:
                                                                        documents
                                                                            .map((doc) {
                                                              return doc.data();
                                                            }).toList()),
                                                          );
                                                        },
                                                        child: Text(
                                                          "Deliver to me",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text("Ship Goods"),
                                        ),
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
        ),
      ],
    );
  }

  PersistentBottomSheetController<dynamic> shippingPolicy(
      BuildContext context, Size size) {
    return showBottomSheet(
      context: context,
      builder: (builder) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35.0),
              ),
              bulletins(
                  "Standard Shipping: Standard shipping is typically the default checkout setting. Your item(s) are expected to be" +
                      "delivered within 3-5 business days after the items have been shipped and picked up by the delivery carrier." +
                      "Spend \$35 or more, or place your order using your REDcard and receive free standard shipping.",
                  size),
              bulletins(
                  "order may ship in multiple packages so we're able to deliver your order faster.",
                  size),
              bulletins(
                  "Some ship to home orders are eligible to have multiple packages consolidated. This may change your"
                  "delivery dates. Packages that qualify will be eligible for a \$1 off discount off of merchandise subtotal."
                  "Merchandise subtotal does not include Gift Cards, eGiftCards, MobileGiftCards, gift wrap, tax or shipping"
                  "and handling charges. Discount will be displayed and applied at checkout. May not be applied to previous"
                  "orders. Ineligible carts will not be shown an option to consolidate and will not receive the discount.",
                  size),
              bulletins(
                  "2-Day Shipping: Depending on the item origin and shipping destination, 2-day shipping may be available in"
                  "select areas. Your item(s) are expected to be delivered within 2 business days after the items have been"
                  "shipped and picked up by the delivery carrier. For eligible items, spend \$35 or more, or place your order using"
                  "your REDcard and receive free 2-day shipping",
                  size),
              bulletins(
                  "Express Shipping: Your items) are expected to be delivered within 1 business day after the items have been"
                  "shipped and picked up by the delivery carrier.",
                  size),
              SizedBox(height: size.height * 0.02),
              Text(
                "PLEASE NOTE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.02),
              bulletins(
                  "Business days don't typically include weekends, however Saturday deliveries may occur in select ZIP codes.",
                  size),
              bulletins(
                  "Some items may not be eligible for 2-day or express shipping due to size, weight, quantities, delivery address or"
                  "vendor constraints.",
                  size),
              bulletins(
                  "Shipping charges for Express shipping are calculated on a 'per order' basis, including shipping, order"
                  "processing, item selection and packaging costs, and will only apply to the items using these shipping speeds.",
                  size),
              bulletins(
                  "most items ship within 24 hours, some vendors and shipping locations may require additional processing"
                  "time. This processing time is factored into the estimated delivery date shown at checkout.",
                  size),
              SizedBox(height: size.height * 0.10),
            ],
          ),
        );
      },
    );
  }

  Widget bulletins(String text, size) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text('')),
              Expanded(child: Text("•")),
              Expanded(flex: 10, child: Text(text)),
              Expanded(flex: 2, child: Text(''))
            ],
          ),
        )
      ],
    );
  }
}

class PickUp extends StatelessWidget {
  const PickUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (builder) {
              return CheckOutDialog();
            });
      },
      child: Text("Pick Up"),
    );
  }
}

class PopUp extends StatefulWidget {
  final DocumentSnapshot? document;
  PopUp({this.document});
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Cancel",
          style: TextStyle(fontFamily: 'PlayfairDisplay'),
        ));
    Widget okButton = TextButton(
      onPressed: () {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot =
              await transaction.get(widget.document!.reference);
          transaction.delete(snapshot.reference);
          Fluttertoast.showToast(
              msg: 'Item removed', toastLength: Toast.LENGTH_SHORT);
          Navigator.pop(context);
        }).catchError(
          (onError) {
            print("Error");
            Fluttertoast.showToast(
                msg: "Item failed to remove from cart,"
                    " please check internet connection.",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.grey[700],
                textColor: Colors.grey[50],
                gravity: ToastGravity.CENTER);
            Navigator.pop(context);
          },
        );
      },
      child: Text("Ok", style: TextStyle(fontFamily: 'PlayfairDisplay')),
    );

    return AlertDialog(
      title: Text(
        "Remove Item from Cart?",
      ),
      content: Text(
        "Are you sure you want to remove this item from your cart?",
      ),
      actions: [
        cancelButton,
        okButton,
      ],
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

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "Enter Card Information",
                      style: TextStyle(
                          fontSize: 20.0, fontFamily: 'PlayfairDisplay'),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(height: 10.0),
                    Form(
                      key: _formKey,
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
                                      hintText: "1234-5478-9876-5432",
                                      hintStyle: TextStyle(
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
                                height: MediaQuery.of(context).size.height / 15,
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
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        child: MaterialButton(
                                          onPressed: confirm,
                                          color: Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          child: new Text(
                                            "Pay Now",
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          splashColor: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            Text(
                              _errorMessage,
                              textAlign: TextAlign.center,
                            ),
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
                )
              ],
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }

  void confirm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/homePage', (Route<dynamic> route) => false);
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
