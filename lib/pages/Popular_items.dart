import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/productModel.dart';
import 'package:shop_app/pages/productDetails.dart';

class Popularitems extends StatelessWidget {
  const Popularitems({Key key, this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Popular items'),
        ),
        body: (FutureBuilder(
            future: getCurrentUID(),
            builder: (context, snapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('PopularProducts')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.data.docs.isEmpty)
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(75),
                              ),
                            ),
                            child: ClipPath(
                              clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(75),
                                  ),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 50.0),
                                    Center(
                                      child:
                                          Text("Opps!!!! no goods available"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  return Container(
                    height: size.height * 0.20,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot keyword = snapshot.data.docs[index];
                        ProductModel products = ProductModel.fromJson(
                            keyword.data() as Map<String, dynamic>);
                        return InkWell(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/productDetails',
                            arguments: ProductDetails(
                              heroTag: products.imgPath,
                              name: products.name,
                              price: products.price,
                            ),
                          ),
                          child: Container(
                            width: size.width * 0.35,
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Hero(
                                    tag: products.imgPath,
                                    child: Image(
                                      image: NetworkImage(
                                        products.imgPath,
                                      ),
                                      loadingBuilder:
                                          (context, child, progress) {
                                        return progress == null
                                            ? child
                                            : CircularProgressIndicator();
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace stackTrace) {
                                        return Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child:
                                              Icon(Icons.broken_image_outlined),
                                        );
                                      },
                                      fit: BoxFit.cover,
                                      height: 75.0,
                                      width: 75.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Row(
                                  children: [
                                    Text(products.name),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.attach_money_sharp,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      products.price,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            })),
      ),
    );
  }
}
