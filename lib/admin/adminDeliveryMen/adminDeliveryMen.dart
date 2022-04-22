import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';
import 'package:shop_app/admin/adminDeliveryMen/addDeliveryMan.dart';
import 'package:shop_app/admin/adminDeliveryMen/viewDeliveryMen.dart';

class AdminDeliveryMen extends StatefulWidget {
  const AdminDeliveryMen({Key? key}) : super(key: key);

  @override
  State<AdminDeliveryMen> createState() => _AdminDeliveryMenState();
}

class _AdminDeliveryMenState extends State<AdminDeliveryMen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("Users").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.data!.docs.isEmpty)
                  return Center(
                    child: Text("No Drivers Avaliable"),
                  );
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Delivery Men"),
                    backgroundColor: Theme.of(context).primaryColor,
                    actions: [
                      IconButton(
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: DeliverySearchDelegate(
                                    snapshot.data!.docs));
                          },
                          icon: Icon(Icons.search))
                    ],
                    bottom: TabBar(
                      controller: tabController,
                      labelColor: Colors.white,
                      tabs: <Tab>[
                        Tab(text: 'View Delivery Men'),
                        Tab(text: 'Add Delivery Men'),
                      ],
                    ),
                  ),
                  body: new TabBarView(
                    controller: tabController,
                    children: [
                      ViewDeliveryMen(),
                      AddDeliveryMen(tabController: tabController),
                    ],
                  ),
                );
              });
        });
  }
}

class DeliverySearchDelegate extends SearchDelegate {
  final documents;

  DeliverySearchDelegate(this.documents);

  IconData? _selectedIcon;

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back));

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
    Size size = MediaQuery.of(context).size;
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
              physics: BouncingScrollPhysics(),
              children: results
                  .map<Widget>(
                    (a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: size.height * 0.15,
                        child: Card(
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      //   height: size.height * 0.,
                                      width: size.width * 0.20,
                                      child: Image(
                                        image: NetworkImage(
                                          a['imgUrl'],
                                        ),
                                        loadingBuilder:
                                            (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator());
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Icon(
                                                Icons.broken_image_outlined),
                                          );
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ]),
                              SizedBox(width: size.width * 0.05),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name: ${a['FullName']}"),
                                  Text("Email: ${a['email']}"),
                                  Text("Address: ${a['address']}"),
                                  Row(
                                    children: [
                                      Text("Ratings: "),
                                      RatingBarIndicator(
                                        rating: double.parse(
                                            a['ratings'].toString()),
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
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList());
        });
  }

  @override
  Widget buildResults(BuildContext context) => Center(child: Text(query));
}
