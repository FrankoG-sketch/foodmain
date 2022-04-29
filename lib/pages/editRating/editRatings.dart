import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/utils/widgets.dart';

import '../../Model/productReviewModel.dart';

class EditRatings extends StatefulWidget {
  final QueryDocumentSnapshot<ProductReviewModel> review;
  final heroTag;
  const EditRatings({Key? key, required this.review, this.heroTag})
      : super(key: key);

  @override
  State<EditRatings> createState() => _EditRatingsState();
}

class _EditRatingsState extends State<EditRatings> {
  Color gold = Color(0xFFFFD54F);
  int overallRating = 0;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ProductReviewModel editedReview;
  late TextEditingController commentController;

  bool isloading = true;
  bool buttonLoader = false;

  @override
  void initState() {
    super.initState();
    editedReview = widget.review.data();
    commentController = TextEditingController(text: editedReview.comment!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Ratings"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.10),
              Center(
                child: Container(
                  child: Hero(
                    tag: this.widget.heroTag,
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
              Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        RatingBar.builder(
                          initialRating: double.parse(editedReview.ratings!),
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
                              editedReview.ratings = rating.round().toString();
                            });
                          },
                        ),
                        SizedBox(height: size.height * 0.10),
                        TextFormField(
                          //initialValue: widget.review.data().comment,
                          maxLines: 3,
                          controller: commentController,
                          //onSaved: (value) => comment = value,
                          maxLength: 250,
                          decoration:
                              textFieldInputDecoration(context, "Comment"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                title: Text("Delete Rating"),
                                content: SingleChildScrollView(
                                    child: Text(
                                        "By Clicking yes, you are about to permanently delete this rating")),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection("Product Review")
                                            .doc(widget.review.id)
                                            .delete();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg: "Rating Deleted",
                                            toastLength: Toast.LENGTH_LONG);
                                      },
                                      child: Text("Yes"))
                                ],
                              );
                            });
                      },
                      child: Text(
                        "Delete Rating",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    buttonLoader
                        ? Center(child: CircularProgressIndicator())
                        : MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  setState(() {
                                    buttonLoader = true;
                                  });

                                  editedReview.date = Timestamp.now();
                                  editedReview.comment = commentController.text;
                                  FirebaseFirestore.instance
                                      .collection("Product Review")
                                      .doc(widget.review.id)
                                      .update(editedReview.toJson())
                                      .then((value) {
                                    setState(() {
                                      buttonLoader = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Ratings Updated",
                                        toastLength: Toast.LENGTH_LONG);
                                    Navigator.pop(context);
                                  }).timeout(Duration(minutes: 2),
                                          onTimeout: () {
                                    setState(() {
                                      buttonLoader = false;
                                    });
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            child: Text(
                              "Save Changes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
