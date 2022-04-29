import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';
import 'package:shop_app/utils/widgets.dart';

class CreateDeliveryReview extends StatefulWidget {
  final imgUrl;
  final name;
  const CreateDeliveryReview({Key? key, this.imgUrl, this.name})
      : super(key: key);

  @override
  State<CreateDeliveryReview> createState() => _CreateDeliveryReviewState();
}

class _CreateDeliveryReviewState extends State<CreateDeliveryReview> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Color gold = Color(0xFFFFD54F);
  int overallRating = 0;
  TextEditingController _commentController = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.name),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.10),
                Container(
                  child: ClipOval(
                    child: Hero(
                      tag: widget.imgUrl,
                      child: Image(
                        image: NetworkImage(widget.imgUrl),
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
                SizedBox(height: size.height * 0.05),
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
                        validator: ((value) =>
                            value!.isEmpty ? "Enter a comment" : null),
                        controller: _commentController,
                        maxLength: 250,
                        maxLines: 3,
                        decoration:
                            textFieldInputDecoration(context, 'Comment'),
                      ),
                      SizedBox(height: size.height * 0.05),
                      isloading
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                              height: size.height * 0.08,
                              width: size.width * 0.80,
                              child: MaterialButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  "Save Review",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (overallRating == 0) {
                                    Fluttertoast.showToast(
                                        msg: "Please provide a rating",
                                        toastLength: Toast.LENGTH_LONG);
                                  }
                                  if (_formKey.currentState!.validate() &&
                                      overallRating != 0) {
                                    try {
                                      setState(() {
                                        isloading = true;
                                      });
                                      print("helo");
                                      String? clientName = FirebaseAuth
                                          .instance.currentUser!.displayName;

                                      String uid = FirebaseAuth
                                          .instance.currentUser!.uid;

                                      Timestamp date = Timestamp.now();

                                      var reviewObject = {
                                        "comment": _commentController.text,
                                        "client name": clientName,
                                        "uid": uid,
                                        "date": date,
                                        "ratings": overallRating,
                                        "delivery personnel": this.widget.name,
                                      };

                                      FirebaseFirestore.instance
                                          .collection(
                                              "Delivery Personnel Review")
                                          .add(reviewObject)
                                          .then((value) {
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg: "Review Added",
                                            toastLength: Toast.LENGTH_LONG);
                                        setState(() {
                                          isloading = false;
                                        });
                                      });
                                    } catch (e) {
                                      print(e);
                                      setState(() {
                                        isloading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                      SizedBox(height: size.height * 0.10),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
