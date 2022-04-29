import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';
import 'package:intl/intl.dart';

class AdminDeliveryList extends StatefulWidget {
  const AdminDeliveryList({Key? key}) : super(key: key);

  @override
  State<AdminDeliveryList> createState() => _AdminDeliveryListState();
}

class _AdminDeliveryListState extends State<AdminDeliveryList>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  String? collection;

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Delivery")
                  .orderBy("Client name")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                return Scaffold(
                  appBar: AppBar(
                    title: Text("Delivery Items"),
                    backgroundColor: Theme.of(context).primaryColor,
                    bottom: TabBar(
                      onTap: (index) {
                        if (tabController.index == 0 ||
                            tabController.index == 1) {
                          setState(() {
                            collection = "Delivery";
                          });
                        } else {
                          setState(() {
                            collection = "Deliveried Jobs";
                          });
                        }
                        print(collection);
                      },
                      controller: tabController,
                      labelColor: Colors.white,
                      tabs: <Tab>[
                        Tab(text: "Staging"),
                        Tab(text: "In Progress"),
                        Tab(text: "Completed"),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    controller: tabController,
                    children: [
                      Staging(document: snapshot.data!.docs),
                      InProgress(document: snapshot.data!.docs),
                      Completed(),
                    ],
                  ),
                );
              });
        });
  }
}

class Staging extends StatefulWidget {
  Staging({Key? key, this.document}) : super(key: key);

  final List<DocumentSnapshot>? document;

  @override
  State<Staging> createState() => _StagingState();
}

class _StagingState extends State<Staging> {
  String? selectedDriver;

  String? deliveryID;

  PageController? pageController;

  String? driver;

  @override
  void dispose() {
    super.dispose();
    pageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, AsyncSnapshot snapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Delivery")
              // .where("Delivery Progress", isEqualTo: "pending")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Center(
                child: Text("No Orders"),
              );
            return Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (this.widget.document![index]['Delivery Progress'] ==
                      "pending")
                    return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, stateSet) {
                                return FractionallySizedBox(
                                  heightFactor: 0.9,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              icon: Icon(Icons.close),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 35.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      "Client Name: ${this.widget.document![index]['Client name']}"),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.03),
                                              Row(
                                                children: [
                                                  Text(
                                                      "Address: ${this.widget.document![index]['address']}"),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.03),
                                              Row(
                                                children: [
                                                  Text(
                                                      "Delivery Progress: ${this.widget.document![index]['Delivery Progress']}"),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.03),
                                              Row(
                                                children: [
                                                  Text(
                                                      "Selected Personal: $selectedDriver"),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("Users")
                                                .where("role",
                                                    isEqualTo: "Delivery")
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (!snapshot.hasData)
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );

                                              List<DropdownMenuItem>
                                                  deliveryList = [];

                                              for (int i = 0;
                                                  i <
                                                      snapshot
                                                          .data!.docs.length;
                                                  i++) {
                                                DocumentSnapshot snap =
                                                    snapshot.data!.docs[i];

                                                deliveryList
                                                    .add(DropdownMenuItem(
                                                  child: Text(
                                                    snap.id,
                                                  ),
                                                  value: "${snap.id}",
                                                ));
                                              }
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 35.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        DropdownButton(
                                                          hint: Text(
                                                              'Select Personal'),
                                                          value: selectedDriver,
                                                          isExpanded: false,
                                                          items: snapshot
                                                              .data!.docs
                                                              .map((DocumentSnapshot
                                                                  document) {
                                                            return DropdownMenuItem<
                                                                    String>(
                                                                value: document
                                                                    .get("FullName"
                                                                        .toString()),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          5.0),
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        // height: size
                                                                        //         .height *
                                                                        //     0.0,
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              Image(
                                                                            image:
                                                                                NetworkImage(
                                                                              document.get('imgUrl'),
                                                                            ),
                                                                            loadingBuilder: (context,
                                                                                child,
                                                                                progress) {
                                                                              return progress == null ? child : Center(child: CircularProgressIndicator());
                                                                            },
                                                                            fit:
                                                                                BoxFit.contain,
                                                                            height:
                                                                                50.0,
                                                                            width:
                                                                                50.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          "${document.get("FullName".trim())}"),
                                                                    ],
                                                                  ),
                                                                ));
                                                          }).toList(),
                                                          onChanged: (String?
                                                              deliveryMen) {
                                                            print(deliveryMen!);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    "Selected Driver is $deliveryMen"),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        300),
                                                              ),
                                                            );
                                                            // if (mounted)
                                                            stateSet(() {
                                                              selectedDriver =
                                                                  deliveryMen;
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                        SizedBox(height: size.height * 0.40),
                                        SizedBox(
                                          height: size.height * 0.08,
                                          width: size.width * 0.80,
                                          child: MaterialButton(
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () {
                                              if (selectedDriver != null) {
                                                showDialog(
                                                    context: context,
                                                    builder: (builder) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Assign Driver"),
                                                        content:
                                                            SingleChildScrollView(
                                                                child: Text.rich(
                                                                    TextSpan(
                                                                        children: [
                                                              TextSpan(
                                                                  text:
                                                                      'You are about to assign'),
                                                              TextSpan(
                                                                  text:
                                                                      ' $selectedDriver ',
                                                                  style: TextStyle(
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: Colors
                                                                          .red)),
                                                              TextSpan(
                                                                  text:
                                                                      'to this task'),
                                                            ]))),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child:
                                                                Text("Cancel"),
                                                          ),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    context);

                                                                Navigator.pop(
                                                                    context);
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "Delivery"
                                                                            .trim())
                                                                    .doc(this
                                                                        .widget
                                                                        .document![
                                                                            index]
                                                                            [
                                                                            'uid']
                                                                        .trim())
                                                                    .update({
                                                                  "selected personal":
                                                                      selectedDriver,
                                                                  "Task Completed":
                                                                      false,
                                                                  "Delivery Progress":
                                                                      "Shipped"
                                                                });
                                                              },
                                                              child: Text(
                                                                  "Proceed"))
                                                        ],
                                                      );
                                                    });
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Select A driver from drop down menu",
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              }
                                            },
                                            child: Text(
                                              "Assign Delivery Man",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                      },
                      child: SizedBox(
                        height: size.height * 0.10,
                        child: Card(
                          elevation: 17.0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Client Name: ${this.widget.document![index]['Client name']}'),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                    'Address: ${this.widget.document![index]['address']}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  else {
                    return Container();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

class InProgress extends StatefulWidget {
  const InProgress({Key? key, this.document}) : super(key: key);
  final List<DocumentSnapshot>? document;
  @override
  State<InProgress> createState() => _InProgressState();
}

class _InProgressState extends State<InProgress> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Delivery").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Center(
                child: Text("Nothing in Progress"),
              );
            return Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (this.widget.document![index]['Delivery Progress'] !=
                      "Shipped") {
                    return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      child: Card(
                        elevation: 17.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'Client Name: ${this.widget.document![index]['Client name']}'),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                  'Address: ${this.widget.document![index]['address']}'),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                  'Delivery Personnel: ${this.widget.document![index]['selected personal']}'),
                              SizedBox(height: size.height * 0.01),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class Completed extends StatefulWidget {
  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Deliveried Jobs")
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Center(
                child: Text("No Products have yet to arrived Destination"),
              );
            return Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (() => showDialog(
                          context: context,
                          builder: (context) {
                            double total = 0;
                            for (var i in snapshot.data!.docs[index]
                                ['products infor']) {
                              total += double.parse(i['price']) *
                                  double.parse(i['Quantity']);
                            }
                            return AlertDialog(
                              title: Text("Task Details"),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        constraintBox(
                                          Text(
                                              'Client Name: ${snapshot.data!.docs[index]['Client Name']}'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        constraintBox(
                                          Text(
                                              'Address: ${snapshot.data!.docs[index]['address']}'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        constraintBox(
                                          Text(
                                              'Delivery Personnel: ${snapshot.data!.docs[index]['Delivery Personnel']}'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        constraintBox(
                                          Text(
                                              'Date: ${DateFormat.yMMMd().format(snapshot.data!.docs[index]['date'].toDate())}'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        constraintBox(
                                          Text(
                                              'Delivered to: ${snapshot.data!.docs[index]['directions']}'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Products",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        for (var i in snapshot.data!.docs[index]
                                            ['products infor'])
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Image(
                                                  image: NetworkImage(i['img']),
                                                  loadingBuilder: (context,
                                                      child, progress) {
                                                    return progress == null
                                                        ? child
                                                        : Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                  },
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              18.0),
                                                      child: Icon(Icons
                                                          .broken_image_outlined),
                                                    );
                                                  },
                                                  fit: BoxFit.cover,
                                                  height: size.height * 0.06,
                                                  width: size.width * 0.10,
                                                ),
                                                Text(
                                                  i['name'],
                                                ),
                                                Text(
                                                  "\t\$${i['price']}",
                                                ),
                                                Text(
                                                  "\t * ${i['Quantity']}",
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Total",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('\$${total.toString()}'),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Ok"))
                              ],
                            );
                          },
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        // height: size.height * 0.10,
                        child: Card(
                          elevation: 17.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: size.height * 0.01),
                                Text(
                                    'Client Name: ${snapshot.data!.docs[index]['Client Name']}',
                                    maxLines: 1),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  'Address: ${snapshot.data!.docs[index]['address']}',
                                  maxLines: 1,
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                    'Selected Personnel: ${snapshot.data!.docs[index]['Delivery Personnel']}',
                                    maxLines: 1),
                                SizedBox(height: size.height * 0.01),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget constraintBox(take) {
    return ConstrainedBox(
        child: take,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.60,
        ));
  }
}
