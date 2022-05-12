import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/Model/ordersMadeModel.dart';
import 'package:shop_app/Model/supermarketModel.dart';
import 'package:shop_app/utils/extensions.dart';
import 'package:shop_app/utils/magic_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/utils/store_provider.dart';

class ActiveOrdersItemGroup {
  List<DocumentSnapshot<OrdersMadeModel>> items;
  String name;
  ActiveOrdersItemGroup({required this.items, required this.name});
}

enum PageEnum {
  dashBoard,
  switchSupermarket,
}

class ActiveOrders extends ConsumerStatefulWidget {
  @override
  _ActiveOrdersState createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends ConsumerState<ActiveOrders> {
  String? _selectedOption;
  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.dashBoard:
        Navigator.pushNamed(context, RouteNames.adminDashBoard);

        break;

      case PageEnum.switchSupermarket:
        _selectedOption = ref.read(storeProvider);
        showDialog(
          context: context,
          builder: (builder) {
            return StreamBuilder<QuerySnapshot<SuperMarketModel>>(
              stream: FirebaseFirestore.instance
                  .collection('Supermarket')
                  .withConverter(
                    fromFirestore: (snapshot, _) =>
                        SuperMarketModel.fromJson(snapshot.data()!),
                    toFirestore: (SuperMarketModel model, _) => model.toJson(),
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text("Change Supermarket"),
                    content: SingleChildScrollView(
                      child: !snapshot.hasData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                Text(
                                    "By Changing the supermarket, not all products may"
                                    " be available at the selected one."
                                    " Also note thats the supermarket you will recieve the products from."),
                                for (var storeName in snapshot.data!.docs)
                                  ListTile(
                                    title: Text(storeName.data().displayName!),
                                    leading: Radio<String>(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: storeName.data().storeId!,
                                      groupValue: _selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedOption = value!;
                                        });
                                      },
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                              ],
                            ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(storeProvider.notifier)
                              .updateStore(_selectedOption!);

                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      )
                    ],
                  );
                });
              },
            );
          },
        );
        break;

      default:
        print("Something went wrong");
        break;
    }
  }

  double value = 0.0;
  double total = 0.0;
  final formatCurrency = new NumberFormat.simpleCurrency();
  double mean = 0.0;
  bool tap = false;

  @override
  void initState() {
    super.initState();
    _selectedOption = ref.read(storeProvider);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('store: ${ref.read(storeProvider)}');
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Orders"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedOption == 'foodJamChristiana') ...[
                Text(
                  "Christiana",
                  style: TextStyle(color: Colors.red),
                ),
              ] else if (_selectedOption == 'foodJamMandeville') ...[
                Text(
                  "Mandeville",
                  style: TextStyle(color: Colors.red),
                ),
              ],
              PopupMenuButton(
                onSelected: _onSelect,
                child: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
                itemBuilder: (context) => <PopupMenuEntry<PageEnum>>[
                  PopupMenuItem(
                    value: PageEnum.dashBoard,
                    child: Text("Dash Board"),
                  ),
                  PopupMenuItem(
                    value: PageEnum.switchSupermarket,
                    child: Text("Switch Supermarket"),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder<QuerySnapshot<OrdersMadeModel>>(
            stream: FirebaseFirestore.instance
                .collection('Orders')
                .where("supermarket",
                    isEqualTo: ref.watch(storeProvider).trim())
                .withConverter<OrdersMadeModel>(
                  fromFirestore: (snapshots, _) =>
                      OrdersMadeModel.fromJson(snapshots.data()!),
                  toFirestore: (movie, _) => movie.toJson(),
                )
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<OrdersMadeModel>> snapshot) {
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
                List<ActiveOrdersItemGroup> items = [];
                double total = 0;
                snapshot.data!.docs.forEach(
                  (element) {
                    total += element.data().price * element.data().quantity;
                  },
                );
                snapshot.data!.docs
                    .groupBy((i) => i.get('client name'))
                    .forEach((key, value) {
                  items.add(ActiveOrdersItemGroup(
                      items: value, name: key.toString()));
                });
                items.sort((a, b) => a.name.compareTo(b.name));

                return snapshot.data!.docs.isEmpty
                    ? Center(
                        child: Text("No Items in Cart"),
                      )
                    : Column(
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              child: DataTable(columns: [
                                DataColumn(
                                  label: Text(
                                    'Client Name',
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Item',
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Price',
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Quantity",
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
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
                                      DataCell(Text('${j.data()!.clientName}')),
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
