import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/Model/deliveryModel.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';

class ViewDeliveryMen extends StatelessWidget {
  const ViewDeliveryMen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData? _selectedIcon;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              //.orderBy("email", descending: true)
              .where("role", isEqualTo: "Delivery")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Center(
                child: Text("No Drivers Avaliable"),
              );
            return Scaffold(
              body: Container(
                height: size.height,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot keyword = snapshot.data!.docs[index];
                    DeliveryMenModel deliveryMenModel =
                        DeliveryMenModel.fromJson(
                            keyword.data() as Map<String, dynamic>);

                    // if (deliveryMenModel.role != "Delivery") {
                    //   return Container();
                    //}
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                        height: size.height * 0.15,
                        child: Card(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: size.height * 0.20,
                                width: size.width * 0.30,
                                child: Image(
                                  image: NetworkImage(
                                    deliveryMenModel.imgUrl!,
                                  ),
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : Center(
                                            child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Icon(Icons.broken_image_outlined),
                                    );
                                  },
                                  fit: BoxFit.cover,
                                  height: 75.0,
                                  width: 75.0,
                                ),
                              ),
                              SizedBox(width: size.width * 0.05),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: ${deliveryMenModel.fullName!}'),
                                  SizedBox(height: size.height * 0.01),
                                  Row(
                                    children: [
                                      Text("Ratings: "),
                                      RatingBarIndicator(
                                        rating: double.parse(
                                            deliveryMenModel.ratings!),
                                        itemBuilder: (context, index) => Icon(
                                          _selectedIcon ?? Icons.star,
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
                                  Text("Email: ${deliveryMenModel.email}"),
                                  SizedBox(height: size.height * 0.01),
                                  Text("Address: ${deliveryMenModel.address}"),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
