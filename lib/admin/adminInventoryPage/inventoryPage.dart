import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/Model/CartModel.dart';
import 'package:shop_app/Model/InventoryModel.dart';
import 'package:shop_app/utils/extensions.dart';

class InventoryItemGroup {
  List<DocumentSnapshot<InventoryModel>> items;
  String name;
  InventoryItemGroup({required this.items, required this.name});
}

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  double value = 0.0;
  double total = 0.0;
  final formatCurrency = new NumberFormat.simpleCurrency();
  double mean = 0.0;
  bool tap = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder<QuerySnapshot<InventoryModel>>(
            stream: FirebaseFirestore.instance
                // .collection('userInformation')
                // .doc(snapshot.data)
                .collection('Cart')
                .withConverter<InventoryModel>(
                  fromFirestore: (snapshots, _) =>
                      InventoryModel.fromJson(snapshots.data()!),
                  toFirestore: (movie, _) => movie.toJson(),
                )
                //.orderBy("user name")
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<InventoryModel>> snapshot) {
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
                List<InventoryItemGroup> items = [];
                double total = 0;
                snapshot.data!.docs.forEach(
                  (element) {
                    total += element.data().price * element.data().quantity;
                  },
                );
                snapshot.data!.docs
                    .groupBy((i) => i.get('userName'))
                    .forEach((key, value) {
                  items.add(
                      InventoryItemGroup(items: value, name: key.toString()));
                });
                items.sort((a, b) => a.name.compareTo(b.name));
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Client Name"),
                            Text("Item Name"),
                            Text("Price"),
                            Text("Quantity"),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            height: size.height,
                            child: Scrollbar(
                              child: true
                                  ? SingleChildScrollView(
                                      child: Column(children: [
                                        for (var item in items)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 64.0),
                                                      child: Text(item.name),
                                                    ),
                                                  ],
                                                ),
                                                for (int i = 0;
                                                    i < item.items.length;
                                                    i++)
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ConstrainedBox(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxWidth:
                                                                          size.height *
                                                                              0.20),
                                                              child:
                                                                  SelectableText(
                                                                '\t',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '${item.items[i].data()!.name}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'PlayfairDisplay',
                                                                fontSize: 16.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${formatCurrency.format(item.items[i].data()!.price)}',
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
                                                                  item.items[i]
                                                                      .data()!
                                                                      .quantity
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontFamily:
                                                                        'PlayfairDisplay - Regular',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        if (i ==
                                                            item.items.length -
                                                                2)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Divider(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        Text(
                                            'Total: \$${total.toStringAsFixed(2)}')
                                      ]),
                                    )
                                  : ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      separatorBuilder: (context, index) {
                                        return Divider();
                                      },
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot point =
                                            snapshot.data!.docs[index];

                                        CartModel cartData = CartModel.fromJson(
                                            point.data()
                                                as Map<String, dynamic>);

                                        double myPrices = double.parse(
                                          point['price']
                                              .toString()
                                              .replaceAll(",", ""),
                                        );
                                        int myQuantity = int.parse(
                                          point['Quantity']
                                              .toString()
                                              .replaceAll(",", ""),
                                        );

                                        value = myPrices * myQuantity;

                                        total += value;

                                        mean = total;
                                        print(mean);
                                      },
                                    ),
                            ),
                          ),
                          Container(
                            child: tap
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                          onPressed: () =>
                                              Phoenix.rebirth(context),
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
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          //  SizedBox(height: size.height * 0.70),
                        ],
                      ),
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
