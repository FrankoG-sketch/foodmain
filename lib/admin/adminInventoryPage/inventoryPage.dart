import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:intl/intl.dart';
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
                .collection('Cart')
                .withConverter<InventoryModel>(
                  fromFirestore: (snapshots, _) =>
                      InventoryModel.fromJson(snapshots.data()!),
                  toFirestore: (movie, _) => movie.toJson(),
                )
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

                return Column(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        child: DataTable(columns: [
                          DataColumn(
                              label: Text(
                            'Client Name',
                            style: TextStyle(fontSize: 10.0),
                          )),
                          DataColumn(
                              label: Text(
                            'Item Name',
                            style: TextStyle(fontSize: 10.0),
                          )),
                          DataColumn(
                              label: Text(
                            'Price',
                            style: TextStyle(fontSize: 10.0),
                          )),
                          DataColumn(
                              label: Text(
                            "Quantity",
                            style: TextStyle(fontSize: 10.0),
                          )),
                        ], rows: [
                          for (var i in items) ...{
                            DataRow(cells: [
                              DataCell(Text('${i.name}')),
                              DataCell(SizedBox.shrink()),
                              DataCell(SizedBox.shrink()),
                              DataCell(SizedBox.shrink()),
                            ]),
                            for (var j in i.items)
                              DataRow(cells: [
                                DataCell(SizedBox.shrink()),
                                DataCell(Text('${j.data()!.name}')),
                                //formatCurrency.format(item.items[i].data()!.price)
                                DataCell(Text(
                                    '${formatCurrency.format(j.data()!.price)}')),
                                DataCell(Text('*${j.data()!.quantity}')),
                              ]),
                          }
                        ]),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Text(
                          'Total: \$${total.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 19.0,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
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
