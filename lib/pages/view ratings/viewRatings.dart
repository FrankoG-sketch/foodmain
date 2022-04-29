import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/Model/productReviewModel.dart';
import 'package:shop_app/utils/widgets.dart';
import 'package:intl/intl.dart';

class ViewProductRatings extends StatefulWidget {
  final productName;
  final heroTag;
  const ViewProductRatings({Key? key, this.productName, this.heroTag})
      : super(key: key);

  @override
  State<ViewProductRatings> createState() => _ViewProductRatingsState();
}

class _ViewProductRatingsState extends State<ViewProductRatings> {
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${this.widget.productName}"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Product Review")
              .where("product name", isEqualTo: this.widget.productName)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Center(
                child: Text("No comments available for this product"),
              );

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Center(
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
                  ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot keyword = snapshot.data!.docs[index];
                      ProductReviewModel productReviewModel =
                          ProductReviewModel.fromJson(
                              keyword.data() as Map<String, dynamic>);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: size.width * 0.30),
                                    child:
                                        Text(productReviewModel.clientName!)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: size.width * 0.40,
                                    ),
                                    child: Text(productReviewModel.comment!)),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                    Text("Ratings: "),
                                    RatingBarIndicator(
                                      rating: double.parse(productReviewModel
                                          .ratings
                                          .toString()),
                                      itemBuilder: (context, index) => Icon(
                                        selectedIcon ?? Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 13.0,
                                      unratedColor: Colors.amber.withAlpha(85),
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                    "Date: ${DateFormat.yMMMd().format(productReviewModel.date!.toDate())}")
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
