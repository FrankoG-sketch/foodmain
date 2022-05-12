import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';
import 'package:shop_app/admin/adminUtils.dart';

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
                                          context,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        constraintBox(
                                          Text(
                                              'Address: ${snapshot.data!.docs[index]['address']}'),
                                          context,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        constraintBox(
                                          Text(
                                              'Delivery Personnel: ${snapshot.data!.docs[index]['Delivery Personnel']}'),
                                          context,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        constraintBox(
                                          Text(
                                              'Date: ${DateFormat.yMMMd().format(snapshot.data!.docs[index]['date'].toDate())}'),
                                          context,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        constraintBox(
                                          Text(
                                              'Delivered to: ${snapshot.data!.docs[index]['directions']}'),
                                          context,
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
}
