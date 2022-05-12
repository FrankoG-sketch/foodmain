import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/pages/productDetails.dart';
import 'package:shop_app/utils/magic_strings.dart';

class MySearchDelegate extends SearchDelegate {
  final collection;
  final documents;
  final tag;
  MySearchDelegate(this.documents, this.collection, this.tag);
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
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collection)
            .where("tag", isEqualTo: tag)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final results = snapshot.data!.docs.where((DocumentSnapshot a) =>
              a['name'].toString().toLowerCase().contains(query.toLowerCase()));

          return ListView(
              children: results
                  .map<Widget>(
                    (a) => Card(
                      child: ListTile(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.productDetails,
                          arguments: ProductDetails(
                            heroTag: a['img'],
                            name: a['name'],
                            price: a['price'],
                            rating: a['rating'],
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        leading: SizedBox(
                          height: size.height * 0.10,
                          width: size.width * 0.10,
                          child: Image(
                            image: NetworkImage(
                              a['img'],
                            ),
                            loadingBuilder: (context, child, progress) {
                              return progress == null
                                  ? child
                                  : Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Icon(Icons.broken_image_outlined),
                              );
                            },
                            fit: BoxFit.cover,
                            height: size.height * 0.10,
                            width: size.width * 0.10,
                          ),
                        ),
                        title: Text(a['name'].toString()),
                        trailing: Text("${a['price']}"),
                      ),
                    ),
                  )
                  .toList());
        });
  }

  @override
  Widget buildResults(BuildContext context) => Center(child: Text(query));
}
