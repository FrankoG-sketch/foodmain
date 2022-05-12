import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';

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
