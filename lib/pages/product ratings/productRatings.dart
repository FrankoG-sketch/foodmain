import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/utils/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ProductRatings extends StatefulWidget {
  final heroTag;
  final productName;
  final rating;
  const ProductRatings({Key? key, this.productName, this.rating, this.heroTag})
      : super(key: key);

  @override
  State<ProductRatings> createState() => _ProductRatingsState();
}

class _ProductRatingsState extends State<ProductRatings>
    with SingleTickerProviderStateMixin {
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  int overallRating = 0;
  bool isloading = false;

  Color gold = Color(0xFFFFD54F);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${this.widget.productName}"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.10),
              Center(
                child: Container(
                  child: Hero(
                    tag: widget.heroTag,
                    child: Image(
                      image: NetworkImage(widget.heroTag),
                      loadingBuilder: (context, child, progress) {
                        return progress == null
                            ? child
                            : CircularProgressIndicator();
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
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
              SizedBox(height: size.height * 0.10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    RatingBar.builder(
                      initialRating: 0,
                      itemSize: 20,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: gold,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);

                        setState(() {
                          overallRating = rating.round();
                        });
                      },
                    ),
                    SizedBox(height: size.height * 0.10),
                    TextFormField(
                        controller: _commentController,
                        maxLength: 250,
                        maxLines: 3,
                        decoration:
                            textFieldInputDecoration(context, 'Comment')),
                    SizedBox(height: size.height * 0.05),
                    isloading
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: size.height * 0.08,
                            width: size.width * 0.80,
                            child: MaterialButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  "Add Review",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isloading = false;
                                  });
                                  String? clientName = FirebaseAuth
                                      .instance.currentUser!.displayName;

                                  String uid =
                                      FirebaseAuth.instance.currentUser!.uid;

                                  Timestamp date = Timestamp.now();

                                  // var averageRating = {
                                  //   "rating": overallRating,
                                  //   "client name": clientName,
                                  //   "uid": uid,
                                  // };

                                  var reviewObject = {
                                    "comment": _commentController.text,
                                    "client name": clientName,
                                    "uid": uid,
                                    "date": date,
                                    "ratings": overallRating,
                                    "product name": this.widget.productName
                                  };

                                  // FirebaseFirestore.instance
                                  //     .collection("Ratings")
                                  //     .doc(this.widget.productName)
                                  //     .set(averageRating);

                                  FirebaseFirestore.instance
                                      .collection("Product Review")
                                      .add(reviewObject)
                                      //.add(reviewObject)
                                      .then((value) {
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                        msg: "Review added",
                                        toastLength: Toast.LENGTH_LONG);
                                  });
                                }),
                          )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.15),
            ],
          ),
        ),
      ),
    );
  }
}
