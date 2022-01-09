import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:intl/intl.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  double value = 0.0;
  double total = 0.0;
  final formatCurrency = new NumberFormat.simpleCurrency();
  double mean = 0.0;
  bool tap = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: ListView(
            children: [
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () async {
                  Authentication().signOut(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                // .collection('userInformation')
                // .doc(snapshot.data)
                .collection('Cart')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 15.0),
                      Text("Loading....."),
                    ],
                  ),
                );
              else if (snapshot.connectionState == ConnectionState.active) {
                return Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemBuilder: (context, index) {
                            DocumentSnapshot point = snapshot.data.docs[index];

                            double myPrices = double.parse(
                              point['price'].toString().replaceAll(",", ""),
                            );
                            int myQuantity = int.parse(
                              point['Quantity'].toString().replaceAll(",", ""),
                            );

                            value = myPrices * myQuantity;

                            total += value;

                            mean = total;
                            print(mean);

                            return SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: size.height * 0.20),
                                          child: SelectableText(
                                            '${point['uid']}',
                                            style: TextStyle(
                                              fontFamily: 'PlayfairDisplay',
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${point['name']}',
                                          style: TextStyle(
                                            fontFamily: 'PlayfairDisplay',
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          '${formatCurrency.format(myPrices)}',
                                          style: TextStyle(
                                            fontFamily:
                                                'PlayfairDisplay - Regular',
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text("x"),
                                            Text(
                                              myQuantity.toString(),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily:
                                                    'PlayfairDisplay - Regular',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                        child: tap
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Total: "),
                                      Text(
                                        '${formatCurrency.format(mean)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () => Phoenix.rebirth(context),
                                      icon: Icon(Icons.refresh)),
                                ],
                              )
                            : Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.grey[700],
                                    ),
                                    onPressed: () {
                                      setState(
                                        () {
                                          mean = total;
                                          tap = true;
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Click for total",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                );
              }
              return Center(
                child: Text("Data not available \n Error Occured"),
              );
            },
          );
        },
      ),
    );
  }
}
