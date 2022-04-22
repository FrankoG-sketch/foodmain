import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/productModel.dart';
import 'package:shop_app/pages/homepage/homePage.dart';
import 'package:shop_app/utils/widgets.dart';

class SpecialBody extends StatelessWidget {
  const SpecialBody({
    Key? key,
    required this.widget,
    required this.size,
  }) : super(key: key);

  final HomeContent widget;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return SliverToBoxAdapter(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('Special').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.data!.docs.isEmpty)
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
                                  child: Text("Opps!!!! no goods available"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              return structurePageHomePage(
                Container(
                  height: widget.size.height * 0.25,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot keyword = snapshot.data!.docs[index];
                      ProductModel products = ProductModel.fromJson(
                          keyword.data() as Map<String, dynamic>);

                      return InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, '/specialItems'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          child: SizedBox(
                            // width: size.width * 0.60,
                            // height: size.height * 0.02,
                            child: Card(
                              child: Container(
                                child: Image(
                                  image: NetworkImage(
                                    products.imgPath!,
                                  ),
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : Center(
                                            child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Icon(Icons.broken_image_outlined),
                                    );
                                  },
                                  fit: BoxFit.cover,
                                  height: size.height * 0.15,
                                  width: size.width * 0.50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SpecialHeader extends StatelessWidget {
  const SpecialHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: structurePageHomePage(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Special for you",
              style: TextStyle(fontSize: 19.0),
            ),
            TextButton(
                child: Text("See more"),
                onPressed: () {
                  Navigator.pushNamed(context, '/specialItems');
                }),
          ],
        ),
      ),
    );
  }
}
