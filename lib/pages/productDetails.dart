import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/productReviewModel.dart';
import 'package:shop_app/pages/editRating/editRatings.dart';
import 'package:shop_app/pages/product%20ratings/productRatings.dart';
import 'package:shop_app/pages/view%20ratings/viewRatings.dart';
import 'package:shop_app/utils/widgets.dart';

class ProductDetails extends StatefulWidget {
  final heroTag;
  final name;
  final price;
  final rating;

  const ProductDetails(
      {Key? key, this.heroTag, this.name, this.price, required this.rating})
      : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

enum PageEnum {
  productRatings,
  viewRatings,
  editRatings,
}

class _ProductDetailsState extends State<ProductDetails> {
  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.productRatings:
        Navigator.pushNamed(context, '/productRatings',
            arguments: ProductRatings(
                heroTag: this.widget.heroTag,
                productName: this.widget.name,
                rating: this.widget.rating));
        break;
      case PageEnum.viewRatings:
        Navigator.pushNamed(context, '/viewProductRatings',
            arguments: ViewProductRatings(
              heroTag: this.widget.heroTag,
              productName: this.widget.name,
            ));
        break;
      case PageEnum.editRatings:
        Navigator.pushNamed(context, '/editRating',
            arguments: EditRatings(
              heroTag: this.widget.heroTag,
              review: review,
            ));
        break;

      default:
        print("Something went wrong");
        break;
    }
  }

  bool purchasePass = false;

  bool isloading = false;

  String cardTitle = '';

  var num = 1;
  late QueryDocumentSnapshot<ProductReviewModel> review;
  @override
  Widget build(BuildContext context) {
    String? uid = FirebaseAuth.instance.currentUser!.uid;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${this.widget.name}"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          StreamBuilder<QuerySnapshot<ProductReviewModel>>(
              stream: FirebaseFirestore.instance
                  .collection("Product Review")
                  .where("product name", isEqualTo: this.widget.name)
                  .where("uid", isEqualTo: uid)
                  .withConverter(
                    fromFirestore: (snapshot, _) =>
                        ProductReviewModel.fromJson(snapshot.data()!),
                    toFirestore: (ProductReviewModel model, _) =>
                        model.toJson(),
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) if (snapshot.data!.docs.isNotEmpty)
                  review = snapshot.data!.docs.first;

                // if (!snapshot.hasData) {
                //   return Center(child: CircularProgressIndicator());
                // }
                /*  else if (snapshot.data!.docs.isEmpty) {
                  return PopupMenuButton(
                    onSelected: _onSelect,
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
                    itemBuilder: (context) => <PopupMenuEntry<PageEnum>>[
                      PopupMenuItem(
                        value: PageEnum.productRatings,
                        child: Text("Rate"),
                      ),
                    ],
                  );
                } */
                return PopupMenuButton(
                  onSelected: _onSelect,
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) => <PopupMenuEntry<PageEnum>>[
                    // for(var i in snapshot.
                    if (snapshot.hasData)
                      snapshot.data!.docs.isNotEmpty
                          ? PopupMenuItem(
                              value: PageEnum.editRatings,
                              child: Text("Edit Rating"),
                            )
                          : PopupMenuItem(
                              value: PageEnum.productRatings,
                              child: Text("Rate"),
                            ),
                    PopupMenuItem(
                      value: PageEnum.viewRatings,
                      child: Text("View Ratings"),
                    ),
                  ],
                );
              }),
          SizedBox(width: 10.0),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: structurePageHomePage(
            Column(
              children: [
                Column(
                  children: [
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 250.0),
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
                                                          var collection =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Food Filter');
                                                          var docSnapshot =
                                                              await collection
                                                                  .doc(uid)
                                                                  .get();

                                                          if (docSnapshot
                                                              .exists) {
                                                            try {
                                                              var uid =
                                                                  await getCurrentUID();
                                                              var date =
                                                                  DateTime
                                                                      .now();

                                                              var fullName =
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .displayName;
                                                              var cartitem = FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Cart')
                                                                  .where('uid',
                                                                      isEqualTo:
                                                                          uid)
                                                                  .where('name',
                                                                      isEqualTo:
                                                                          widget
                                                                              .name);
                                                              var available =
                                                                  await cartitem
                                                                      .get();
                                                              if (available
                                                                      .size ==
                                                                  0)
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Cart')
                                                                    .add(
                                                                  {
                                                                    "img": widget
                                                                        .heroTag,
                                                                    "name": widget
                                                                        .name,
                                                                    "price": widget
                                                                        .price,
                                                                    "Quantity":
                                                                        num.toString(),
                                                                    "Date":
                                                                        date,
                                                                    "uid": uid,
                                                                    "userName":
                                                                        fullName,
                                                                  },
                                                                ).then((value) {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "Item added to cart",
                                                                      toastLength:
                                                                          Toast
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
                                                                    print(
                                                                        "Error");
                                                                    Fluttertoast.showToast(
                                                                        msg: "Item will be added to the cart automatically"
                                                                            " when reconnected to a stable network connection",
                                                                        toastLength: Toast.LENGTH_LONG,
                                                                        gravity: ToastGravity.CENTER,
                                                                        backgroundColor: Colors.grey[700],
                                                                        textColor: Colors.white);
                                                                  });
                                                                });
                                                              else {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Cart')
                                                                    .doc(available
                                                                        .docs
                                                                        .first
                                                                        .id)
                                                                    .update({
                                                                  "Quantity": (int.parse(available
                                                                              .docs
                                                                              .first
                                                                              .get("Quantity")) +
                                                                          1)
                                                                      .toString()
                                                                }).then(
                                                                        (value) {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "Item added to cart",
                                                                      toastLength:
                                                                          Toast
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
                                                                    print(
                                                                        "Error");
                                                                    Fluttertoast.showToast(
                                                                        msg: "Item will be added to the cart automatically"
                                                                            " when reconnected to a stable network connection",
                                                                        toastLength: Toast.LENGTH_LONG,
                                                                        gravity: ToastGravity.CENTER,
                                                                        backgroundColor: Colors.grey[700],
                                                                        textColor: Colors.white);
                                                                  });
                                                                });
                                                              }
                                                            } on TimeoutException catch (e) {
                                                              print(e);
                                                            } catch (e) {
                                                              print(e);
                                                            }
                                                          } else {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Food Filter Required"),
                                                                    content:
                                                                        SingleChildScrollView(
                                                                      child: Text(
                                                                          "A food filter is a form in which you tell us information about yourself such as your meal type, allergies, diet plans and exercise plan. This will help us to provide you with food which meets the requirments for your daily meal consumption."),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        child: Text(
                                                                            "Cancel"),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.popAndPushNamed(
                                                                              context,
                                                                              '/foodFilter');
                                                                        },
                                                                        child: Text(
                                                                            "Add Food Filter"),
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    StreamBuilder<
                                                            QuerySnapshot<
                                                                ProductReviewModel>>(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "Product Review")
                                                            .where(
                                                                "product name",
                                                                isEqualTo: this
                                                                    .widget
                                                                    .name)
                                                            .withConverter(
                                                              fromFirestore: (snapshot,
                                                                      _) =>
                                                                  ProductReviewModel
                                                                      .fromJson(
                                                                          snapshot
                                                                              .data()!),
                                                              toFirestore:
                                                                  (ProductReviewModel
                                                                              model,
                                                                          _) =>
                                                                      model
                                                                          .toJson(),
                                                            )
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (!snapshot.hasData)
                                                            return Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                          double total = 0;

                                                          snapshot.data!.docs
                                                              .forEach((doc) {
                                                            total +=
                                                                double.parse(doc
                                                                    .data()
                                                                    .ratings!);
                                                          });
                                                          double average =
                                                              snapshot
                                                                      .data!
                                                                      .docs
                                                                      .isEmpty
                                                                  ? 0
                                                                  : total /
                                                                      snapshot
                                                                          .data!
                                                                          .docs
                                                                          .length;

                                                          return Container(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        30.0),
                                                            child:
                                                                RatingBarIndicator(
                                                              rating: average,
                                                              itemBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      Icon(
                                                                selectedIcon ??
                                                                    Icons.star,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        223,
                                                                        168,
                                                                        5),
                                                              ),
                                                              itemCount: 5,
                                                              itemSize: 20.0,
                                                              unratedColor:
                                                                  Colors.amber
                                                                      .withAlpha(
                                                                          85),
                                                              direction: Axis
                                                                  .horizontal,
                                                            ),
                                                          ));
                                                        }),
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
                                                              padding: const EdgeInsets
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
                                                                          color:
                                                                              Theme.of(context).primaryColor,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Icon(
                                                                            Icons.remove,
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
                                                                      width:
                                                                          30.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(7.0),
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Theme.of(context).primaryColor,
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
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Center(
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
                                              StackTrace? stackTrace) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 18.0),
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
