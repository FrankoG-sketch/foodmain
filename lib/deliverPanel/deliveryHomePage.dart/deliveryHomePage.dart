import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/deliverPanel/deliveryPanelProfilePage/deliveryProfilePage.dart';
import '../../Authentication/auth.dart';

class DeliveryHomePage extends StatefulWidget {
  final Size size;

  const DeliveryHomePage({Key? key, required this.size}) : super(key: key);

  @override
  State<DeliveryHomePage> createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  @override
  void initState() {
    super.initState();

    checkForProfilePhoto;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Jobs"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0),
              child: ListTile(
                title: Text("Logout "),
                trailing: Icon(Icons.exit_to_app),
                onTap: () => Authentication().signOut(context),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          String? fullName = FirebaseAuth.instance.currentUser!.displayName;
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Delivery")
                .where("selected personal", isEqualTo: fullName)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.data!.docs.isEmpty)
                return Center(
                  child: Text("Nothing in Progress"),
                );
              return DeliverySideList(documents: snapshot.data!.docs);
            },
          );
        },
      ),
    );
  }

  get checkForProfilePhoto async {
    var blankPhoto =
        'https://firebasestorage.googleapis.com/v0/b/jmarket-9aa0f.appspot.com/o/profile.png?alt=media&token=43d9378c-3f32-4cf8-b726-1a35f8e18f46';
    var uid = await getCurrentUID();

    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();

    if (snapshot.exists) {
      Map<String, dynamic>? fetchDoc = snapshot.data() as Map<String, dynamic>?;

      var profilePhoto = fetchDoc?['imgUrl'];

      FirebaseFirestore.instance
          .collection("Users")
          .where('uid', isEqualTo: uid)
          .get()
          .then((value) {
        if (profilePhoto == blankPhoto) {
          showDialog(
              context: context,
              builder: (builder) {
                return AlertDialog(
                  title: SingleChildScrollView(
                      child: Text("Profile Picture required")),
                  content: Text(
                      "A profile picture is required to help clients know who to expect to drop off their products"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Not Now')),
                    TextButton(
                        onPressed: () => Navigator.popAndPushNamed(
                            context, '/deliveryProfilePage',
                            arguments: DeliveryProfile(size: this.widget.size)),
                        child: Text("Add Photo"))
                  ],
                );
              });
        }
      });
    }
  }
}

class DeliverySideList extends StatefulWidget {
  DeliverySideList({Key? key, required this.documents}) : super(key: key);
  List<DocumentSnapshot?> documents;
  @override
  State<DeliverySideList> createState() => _DeliverySideListState();
}

class _DeliverySideListState extends State<DeliverySideList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Delivery")
                  .where("Delivery Progress", isEqualTo: "Shipped")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      else if (snapshot.data!.docs.isEmpty)
                        return Center(
                          child: Text("No Jobs Avaliable"),
                        );

                      return SizedBox(
                        height: size.height * 0.20,
                        child: InkWell(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Job Finished"),
                                    content: SingleChildScrollView(
                                      child: Text(
                                          "By Clicking yes, you are confirming that you have completed the delivery of this/these product(s)"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            FirebaseFirestore.instance
                                                .collection("Delivery".trim())
                                                .doc(this
                                                    .widget
                                                    .documents[index]!['uid']
                                                    .trim())
                                                .update({
                                              "Delivery Progress": "Arrived"
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Yes'))
                                    ],
                                  );
                                });
                          },
                          child: Card(
                            elevation: 17.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35.0, vertical: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          'Client Name: ${this.widget.documents[index]!['Client name']}'),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Row(
                                    children: [
                                      Text(
                                          'Address: ${this.widget.documents[index]!['address']}'),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var i in this
                                          .widget
                                          .documents[index]!['products infor'])
                                        Builder(builder: (context) {
                                          double total = 0;
                                          List items = this
                                              .widget
                                              .documents[index]![
                                                  'products infor']
                                              .map((e) {
                                            if (e['user name'] ==
                                                i['user name']) return e;
                                          }).toList();
                                          items.forEach((element) {
                                            total += double.parse(
                                                    element['price']) *
                                                int.parse(element['Quantity']);
                                          });

                                          return Text(
                                              'Client Name: ${i['user name']} \n Total:  $total');
                                        })

                                      // Text(
                                      //     'Products: ${this.widget.documents[index]!['']}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              });
        });
  }
}
