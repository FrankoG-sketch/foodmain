import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/utils/widgets.dart';

class ProductDetails extends StatefulWidget {
  final heroTag;
  final name;
  final price;

  const ProductDetails({Key key, this.heroTag, this.name, this.price})
      : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isloading = false;

  String cardTitle = '';

  var num = 1;

  var selectedCard = 'INGREDIENTS';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: structurePageHomePage(
            Column(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.chevron_left),
                        iconSize: 40.0,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 80.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(45.0),
                                        topRight: Radius.circular(45.0),
                                      ),
                                      color: Theme.of(context).canvasColor,
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(top: 250.0),
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: isloading
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 4,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                      child: new MaterialButton(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        textColor: Colors.white,
                                                        child: new Text(
                                                          "Add to Cart",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () async {
                                                          try {
                                                            var uid =
                                                                await getCurrentUID();
                                                            var date =
                                                                DateTime.now();
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'userInformation')
                                                                .doc(uid)
                                                                .collection(
                                                                    'Cart')
                                                                .add(
                                                              {
                                                                "img": widget
                                                                    .heroTag,
                                                                "name":
                                                                    widget.name,
                                                                "price": widget
                                                                    .price,
                                                                "Quantity": num
                                                                    .toString(),
                                                                "Date": date,
                                                              },
                                                            ).then((value) {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Item added to cart",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  backgroundColor:
                                                                      Colors.grey[
                                                                          700],
                                                                  textColor:
                                                                      Colors
                                                                          .white);

                                                              Navigator.pop(
                                                                  context);
                                                            }).timeout(
                                                                    Duration(
                                                                        seconds:
                                                                            5),
                                                                    onTimeout:
                                                                        () {
                                                              setState(() {
                                                                print("Error");
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Item will be added to the cart automatically"
                                                                            " when reconnected to a stable network connection",
                                                                        toastLength:
                                                                            Toast
                                                                                .LENGTH_LONG,
                                                                        gravity:
                                                                            ToastGravity
                                                                                .CENTER,
                                                                        backgroundColor:
                                                                            Colors.grey[
                                                                                700],
                                                                        textColor:
                                                                            Colors.white);
                                                              });
                                                            });
                                                          } on TimeoutException catch (e) {
                                                            print(e);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                            ),
                                            SizedBox(height: 20.0),
                                            Center(
                                              child: Text(
                                                "Details".toUpperCase(),
                                                style: TextStyle(
                                                  fontFamily: 'PlayfairDisplay',
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.grey,
                                              endIndent: 50.0,
                                              indent: 50.0,
                                            ),
                                            Container(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    widget.name,
                                                    style: TextStyle(
                                                      fontSize: 22.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'PlayfairDisplay - Regular',
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.0),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          '\$${widget.price}',
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontFamily:
                                                                'PlayfairDisplay - Regular',
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 25.0,
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                        Container(
                                                          width: 125.0,
                                                          height: 40.0,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          17.0),
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                      () {
                                                                        if (num >
                                                                            1) {
                                                                          num--;
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          25.0,
                                                                      width:
                                                                          25.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(7.0),
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .remove,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              25.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  num.toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      if (num <
                                                                          10) {
                                                                        num++;
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        30.0,
                                                                    width: 30.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              7.0),
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        size:
                                                                            15.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 40.0),

                                                  //Card which contains the blue Drug facts....

                                                  SizedBox(height: 10.0),
                                                ],
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    child: Hero(
                                      tag: widget.heroTag,
                                      child: Image(
                                        image: NetworkImage(widget.heroTag),
                                        loadingBuilder:
                                            (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : CircularProgressIndicator();
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace stackTrace) {
                                          return Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Icon(
                                              Icons.broken_image_outlined,
                                              size: 200,
                                            ),
                                          );
                                        },
                                        fit: BoxFit.cover,
                                        height: 200.0,
                                        width: 200.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
