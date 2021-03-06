import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';

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
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth:
                                                            size.width * 0.80),
                                                    child: Text(
                                                        "Address: ${this.widget.document![index]['address']}"),
                                                  ),
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
