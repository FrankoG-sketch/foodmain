import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Model/User_model.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';

class ViewClients extends StatefulWidget {
  const ViewClients({Key? key}) : super(key: key);

  @override
  State<ViewClients> createState() => _ViewClientsState();
}

class _ViewClientsState extends State<ViewClients> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .orderBy('FullName')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Center(
                child: Text("No Clients Available"),
              );

            return Scaffold(
              appBar: AppBar(
                title: Text("Clients"),
                backgroundColor: Theme.of(context).primaryColor,
                actions: [
                  IconButton(
                      onPressed: () => showSearch(
                            context: context,
                            delegate: ViewClientsSearchDelegate(
                                snapshot.data!.docs, "Users"),
                          ),
                      icon: Icon(Icons.search))
                ],
              ),
              body: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot keyword = snapshot.data!.docs[index];
                  ClientUserModel userModel = ClientUserModel.fromJson(
                      keyword.data() as Map<String, dynamic>);
                  if (userModel.role != "User") {
                    return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Card(
                      child: ListTile(
                        leading: SizedBox(
                          // height: size.height * 0.10,
                          // width: size.width * 0.10,
                          child: ClipOval(
                            child: Image(
                              image: NetworkImage(userModel.imgUrl!),
                              loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : Center(
                                        child: CircularProgressIndicator());
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Icon(Icons.broken_image_outlined),
                                );
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(userModel.fullName!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${userModel.email!}'),
                            Text('Address: ${userModel.address!}'),
                          ],
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

class ViewClientsSearchDelegate extends SearchDelegate {
  final collection;
  final documents;
  ViewClientsSearchDelegate(this.documents, this.collection);
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
      stream: FirebaseFirestore.instance
          .collection("Users")
          .where("role", isEqualTo: "User")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final results = snapshot.data!.docs.where((DocumentSnapshot a) =>
            a['FullName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()));

        return ListView(
            children: results
                .map<Widget>(
                  (a) => Card(
                    child: ListTile(
                      leading: Image(
                        image: NetworkImage(a['imgUrl']),
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Icon(Icons.broken_image_outlined),
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                      title: Text(a['FullName'].toString()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${a['email'].toString()}'),
                          Text('Address: ${a['address'].toString()}'),
                        ],
                      ),
                    ),
                  ),
                )
                .toList());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => Center(child: Text(query));
}
