import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/Model/deliveryModel.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';

IconData? _selectedIcon;

class DeliveryWorkers extends StatelessWidget {
  const DeliveryWorkers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .orderBy("FullName")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.data!.docs.isEmpty)
                  return Center(
                    child: Text("No Drivers Avaliable"),
                  );
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Delivery Workers"),
                    backgroundColor: Theme.of(context).primaryColor,
                    actions: [
                      IconButton(
                          onPressed: () => showSearch(
                                context: context,
                                delegate: UserViewDriverSearchDelegate(
                                    snapshot.data!.docs, "Users"),
                              ),
                          icon: Icon(Icons.search))
                    ],
                  ),
                  body: Center(
                    child: Container(
                      height: size.height * 0.50,
                      width: double.infinity,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot keyword =
                                snapshot.data!.docs[index];
                            DeliveryMenModel deliveryMenModel =
                                DeliveryMenModel.fromJson(
                                    keyword.data() as Map<String, dynamic>);

                            if (deliveryMenModel.role != "Delivery") {
                              return Container();
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: size.width * 0.60,
                                child: Card(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: size.height * 0.25,
                                        width: double.infinity,
                                        child: Image(
                                          image: NetworkImage(
                                            deliveryMenModel.imgUrl!,
                                          ),
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
                                                  const EdgeInsets.all(18.0),
                                              child: Icon(
                                                  Icons.broken_image_outlined),
                                            );
                                          },
                                          fit: BoxFit.cover,
                                          height: 75.0,
                                          width: 75.0,
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.05),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Name: ${deliveryMenModel.fullName!}'),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Row(
                                              children: [
                                                Text("Ratings: "),
                                                RatingBarIndicator(
                                                  rating: double.parse(
                                                      deliveryMenModel
                                                          .ratings!),
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    _selectedIcon ?? Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 13.0,
                                                  unratedColor: Colors.amber
                                                      .withAlpha(85),
                                                  direction: Axis.horizontal,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Text(
                                                "Email: ${deliveryMenModel.email}"),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Text(
                                                "Address: ${deliveryMenModel.address}"),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                );
              });
        });
  }
}

class UserViewDriverSearchDelegate extends SearchDelegate {
  final collection;
  final documents;
  UserViewDriverSearchDelegate(this.documents, this.collection);
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: Icon(Icons.clear))
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .where("role", isEqualTo: "Delivery")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final results = snapshot.data!.docs.where((DocumentSnapshot a) =>
            a['FullName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()));

        return ListView(
            children: results
                .map<Widget>(
                  (a) => Card(
                    child: ListTile(
                      leading: Image(
                        image: NetworkImage(a['imgUrl']),
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(Icons.broken_image_outlined),
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                      title: Text(a['FullName'].toString()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('Email: ${a['ratings'].toString()}'),
                          Row(
                            children: [
                              Text("Ratings: "),
                              RatingBarIndicator(
                                rating: double.parse(a['ratings'].toString()),
                                itemBuilder: (context, index) => Icon(
                                  _selectedIcon ?? Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 13.0,
                                unratedColor: Colors.amber.withAlpha(85),
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                          Text('Email: ${a['email'].toString()}'),
                          Text('Address: ${a['address'].toString()}'),
                        ],
                      ),
                    ),
                  ),
                )
                .toList());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => Center(child: Text(query));
}
