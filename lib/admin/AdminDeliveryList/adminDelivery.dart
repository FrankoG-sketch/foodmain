import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';
import 'package:shop_app/admin/AdminDeliveryList/cancelled.dart';
import 'package:shop_app/admin/AdminDeliveryList/completed.dart';
import 'package:shop_app/admin/AdminDeliveryList/inProgress.dart';
import 'package:shop_app/admin/AdminDeliveryList/staging.dart';

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

    tabController = new TabController(length: 4, vsync: this);
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
                    if (tabController.index == 0 || tabController.index == 1) {
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
                    Tab(text: "Cancelled"),
                  ],
                ),
              ),
              body: TabBarView(
                controller: tabController,
                children: [
                  Staging(document: snapshot.data!.docs),
                  InProgress(document: snapshot.data!.docs),
                  Completed(),
                  Cancelled(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
