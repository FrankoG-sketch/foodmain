import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/Model/clientReviewModel.dart';
import 'package:shop_app/Model/deliveryModel.dart';
import 'package:shop_app/pages/delivery%20workers/createReview.dart';
import 'package:shop_app/pages/delivery%20workers/editReview.dart';
import 'package:shop_app/utils/widgets.dart';
import 'package:intl/intl.dart';

class DeliveryWorkerRatings extends StatefulWidget {
  final imgUrl;
  final name;
  final email;
  final address;
  const DeliveryWorkerRatings(
      {Key? key, this.imgUrl, this.name, this.email, this.address})
      : super(key: key);

  @override
  State<DeliveryWorkerRatings> createState() => _DeliveryWorkerRatingsState();
}

enum PageEnum {
  createReview,
  editReview,
}

class _DeliveryWorkerRatingsState extends State<DeliveryWorkerRatings> {
  late QueryDocumentSnapshot<ClientReviewModel> review;
  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.createReview:
        Navigator.pushNamed(
          context,
          '/createDeliveryReview',
          arguments: CreateDeliveryReview(
              imgUrl: this.widget.imgUrl, name: this.widget.name),
        );
        break;

      case PageEnum.editReview:
        Navigator.pushNamed(context, '/editDeliveryReview',
            arguments: EditReview(
              heroTag: this.widget.imgUrl,
              reviewDeliveryPersonnel: review,
            ));
        break;

      default:
        print("Something went wrong");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          StreamBuilder<QuerySnapshot<ClientReviewModel>>(
            stream: FirebaseFirestore.instance
                .collection("Delivery Personnel Review")
                .where("delivery personnel", isEqualTo: this.widget.name)
                .where("uid", isEqualTo: uid)
                .withConverter(
                    fromFirestore: (snapshot, _) =>
                        ClientReviewModel.fromJson(snapshot.data()!),
                    toFirestore: (ClientReviewModel model, _) => model.toJson())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) if (snapshot.data!.docs.isNotEmpty)
                review = snapshot.data!.docs.first;

              return PopupMenuButton(
                onSelected: _onSelect,
                child: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
                itemBuilder: ((context) => <PopupMenuEntry<PageEnum>>[
                      if (snapshot.hasData)
                        snapshot.data!.docs.isNotEmpty
                            ? PopupMenuItem(
                                value: PageEnum.editReview,
                                child: Text("Edit Review"),
                              )
                            : PopupMenuItem(
                                value: PageEnum.createReview,
                                child: Text("Add Review"),
                              )
                    ]),
              );
            },
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.10),
            Center(
              child: ClipOval(
                child: SizedBox(
                  height: 120.0,
                  width: 120.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image(
                        image: NetworkImage(
                          this.widget.imgUrl,
                        ),
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : CircularProgressIndicator();
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/images/profile.png',
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.10),
            Container(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot<DeliveryMenModel>>(
                    stream: FirebaseFirestore.instance
                        .collection("Delivery Personnel Review")
                        .where("delivery personnel",
                            isEqualTo: this.widget.name)
                        .withConverter(
                            fromFirestore: (snapshot, _) =>
                                DeliveryMenModel.fromJson(snapshot.data()!),
                            toFirestore: (DeliveryMenModel model, _) =>
                                model.toJson())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());

                      double total = 0;
                      snapshot.data!.docs.forEach((doc) {
                        total += double.parse(doc.data().ratings!);
                      });

                      double average = snapshot.data!.docs.isEmpty
                          ? 0
                          : total / snapshot.data!.docs.length;

                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: RatingBarIndicator(
                            rating: average,
                            itemBuilder: (context, index) => Icon(
                              selectedIcon ?? Icons.star,
                              color: Color.fromARGB(255, 223, 168, 5),
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            unratedColor: Colors.amber.withAlpha(85),
                            direction: Axis.horizontal,
                          ),
                        ),
                      );
                    },
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Delivery Personnel Review")
                          .where("delivery personnel",
                              isEqualTo: this.widget.name)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());
                        else if (snapshot.data!.docs.isEmpty)
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50.0),
                            child: Center(
                              child: Text(
                                  "No reviews are available for this personnel"),
                            ),
                          );
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot keyword =
                                  snapshot.data!.docs[index];
                              ClientReviewModel clientReviewModel =
                                  ClientReviewModel.fromJson(
                                      keyword.data() as Map<String, dynamic>);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0, vertical: 18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: size.width * 0.30),
                                          child: Text(
                                              clientReviewModel.clientName!),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: size.width * 0.40,
                                            ),
                                            child: Text(
                                                clientReviewModel.comment!)),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          children: [
                                            Text("Ratings: "),
                                            RatingBarIndicator(
                                              rating: double.parse(
                                                  clientReviewModel.ratings
                                                      .toString()),
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                selectedIcon ?? Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: 13.0,
                                              unratedColor:
                                                  Colors.amber.withAlpha(85),
                                              direction: Axis.horizontal,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Text(
                                            "Date: ${DateFormat.yMMMd().format(clientReviewModel.date!.toDate())}")
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
