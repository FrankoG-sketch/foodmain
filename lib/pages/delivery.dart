import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';

class Delivery extends StatelessWidget {
  const Delivery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Delivery"),
      ),
      body: Container(
        child: FutureBuilder(
          future: getCurrentUID(),
          builder: (context, AsyncSnapshot snapshot) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Delivery")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.data!.docs.isEmpty)
                    return Center(
                      child: Text("Nothing being delivered"),
                    );
                  return DeliveryList(documents: snapshot.data!.docs);
                });
          },
        ),
      ),
    );
  }
}

class DeliveryList extends StatefulWidget {
  const DeliveryList({Key? key, this.documents}) : super(key: key);
  final List<DocumentSnapshot>? documents;

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  Future<void> _getUid() async {
    var uid = await getCurrentUID();
    setState(() {
      uidKey = uid;
    });
  }

  var uidKey;
  var uid;

  @override
  void initState() {
    _getUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getCurrentUID(),
            builder: (context, snapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Delivery")
                    .where('uid', isEqualTo: uidKey)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.connectionState == ConnectionState.active) {
                    return Scrollbar(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemBuilder: (context, index) {
                          DocumentSnapshot point = snapshot.data!.docs[index];

                          // var uidFromCart = point['uid'];

                          // if (uidFromCart == uid) {
                          //   return Container(height: 0);
                          // }

                          // double myPrices = double.parse(
                          //   point['price'].toString().replaceAll(",", ""),
                          // );
                          // int myQuantity = int.parse(
                          //   point['Quantity'].toString().replaceAll(",", ""),
                          // );

                          // value = myPrices * myQuantity;

                          // total += value;

                          // mean = total;
                          // print(mean);

                          return Column(
                            children: [
                              SingleChildScrollView(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35.0, vertical: 35.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Client name: ${point['Client name']}',
                                              style: TextStyle(
                                                fontFamily: 'PlayfairDisplay',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Delivery Progress: ${point['Delivery Progress']}',
                                              style: TextStyle(
                                                fontFamily: 'PlayfairDisplay',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Date made: ${point['date'].toDate()}',
                                              style: TextStyle(
                                                fontFamily: 'PlayfairDisplay',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Text("Nothing."),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
