import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';

class AdminFeedBack extends StatelessWidget {
  const AdminFeedBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("FeedBack").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Center(
                child: Text("No feed backs at this time"),
              );
            return Scaffold(
              appBar: AppBar(
                title: Text("Customers Feed Back"),
                backgroundColor: Theme.of(context).primaryColor,
                actions: [
                  IconButton(
                      onPressed: () => showSearch(
                            context: context,
                            delegate: FeedBackSearchList(
                                snapshot.data!.docs, "FeedBack"),
                          ),
                      icon: Icon(Icons.search))
                ],
              ),
              body: AdminFeedBackList(documents: snapshot.data!.docs),
            );
          });
    });
  }
}

class AdminFeedBackList extends StatefulWidget {
  List<DocumentSnapshot>? documents;
  AdminFeedBackList({
    Key? key,
    required this.documents,
  }) : super(key: key);

  @override
  State<AdminFeedBackList> createState() => _AdminFeedBackListState();
}

class _AdminFeedBackListState extends State<AdminFeedBackList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getCurrentUID(),
        builder: (context, AsyncSnapshot snapshot) {
          return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("FeedBack").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.data!.docs.isEmpty)
                  return Center(
                    child: Text("No feed backs at this time"),
                  );
                return Scrollbar(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          child: InkWell(
                            onTap: () => showDialog(
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                    title: Text("Delete Permanently"),
                                    content: SingleChildScrollView(
                                        child: Text(
                                            "Are you sure you want to permanently delete this feed back from ${snapshot.data!.docs[index]['Name']}")),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .runTransaction(
                                              (transaction) async {
                                                DocumentSnapshot snapshot =
                                                    await transaction.get(widget
                                                        .documents![index]
                                                        .reference);
                                                transaction
                                                    .delete(snapshot.reference);
                                                Fluttertoast.showToast(
                                                  msg: 'Reservation Deleted',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                );
                                                print("Deleted");
                                                Navigator.pop(context);
                                              },
                                            ).catchError(
                                              (onError) {
                                                print("Error");
                                                Fluttertoast.showToast(
                                                    msg: "Please try again or" +
                                                        " connect to a stable network",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    backgroundColor:
                                                        Colors.grey[700],
                                                    textColor: Colors.grey[50],
                                                    gravity:
                                                        ToastGravity.CENTER);
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          child: Text("Ok")),
                                    ],
                                  );
                                }),
                            child: Card(
                              elevation: 17.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Client Name: ${snapshot.data!.docs[index]['Name']}'),
                                    SizedBox(height: size.height * 0.01),
                                    Text(
                                        'Date made: ${DateFormat.yMMMd().format(snapshot.data!.docs[index]['Date'].toDate())}'),
                                    SizedBox(height: size.height * 0.01),
                                    Text(
                                        'Feed back: ${snapshot.data!.docs[index]['FeedBack']}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              });
        });
  }
}

class FeedBackSearchList extends SearchDelegate {
  final collection;
  final documents;
  FeedBackSearchList(this.documents, this.collection);
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: Icon(Icons.clear))
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(collection).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final results = snapshot.data!.docs.where((DocumentSnapshot a) =>
              a['Name'].toString().toLowerCase().contains(query.toLowerCase()));

          return ListView(
              children: results
                  .map<Widget>(
                    (a) => Card(
                      child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return AlertDialog(
                                  title: Text("Delete Feed Back"),
                                  content: SingleChildScrollView(
                                    child: Text(
                                        "Are you sure you want to delete this Feed back?"),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel")),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          var collect = FirebaseFirestore
                                              .instance
                                              .collection(collection);

                                          var snapshot = await collect
                                              .where('FeedBack',
                                                  isEqualTo: a['FeedBack'])
                                              .get();

                                          for (var doc in snapshot.docs) {
                                            await doc.reference.delete();
                                          }
                                        },
                                        child: Text("Yes"))
                                  ],
                                );
                              });
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        leading: Text(a['Name'].toString()),
                        title: Text(a['FeedBack'].toString()),
                        trailing: Text(
                            '${DateFormat.yMMMd().format(a['Date'].toDate())}'),
                      ),
                    ),
                  )
                  .toList());
        });
  }

  @override
  Widget buildResults(BuildContext context) => Center(child: Text(query));
}
