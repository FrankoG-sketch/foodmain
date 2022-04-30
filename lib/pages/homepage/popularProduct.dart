import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/productModel.dart';
import 'package:shop_app/pages/homepage/homePage.dart';
import 'package:shop_app/pages/productDetails.dart';
import 'package:shop_app/utils/store_provider.dart';
import 'package:shop_app/utils/widgets.dart';

class ProductBody extends ConsumerWidget {
  const ProductBody({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final HomeContent widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(ref.watch(storeProvider))
                .orderBy("name")
                .where("tag", isEqualTo: "popular items")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.data!.docs.isEmpty)
                return Column(
                  children: <Widget>[
                    Container(
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Text(
                              "The popular products aren't available at this supermarket, please select another supermarket"),
                        ),
                      ),
                    ),
                  ],
                );
              return Container(
                height: widget.size.height * 0.25,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: structurePageHomePage(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Popular Products",
                              style: TextStyle(fontSize: 19.0),
                            ),
                            TextButton(
                                child: Text("See more"),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/productPage');
                                }),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ListView.builder(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot keyword = snapshot.data!.docs[index];
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
                                rating: products.rating,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: SizedBox(
                                width: widget.size.width * 0.35,
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Hero(
                                          tag: products.imgPath!,
                                          child: Image(
                                            image: NetworkImage(
                                              products.imgPath!,
                                            ),
                                            loadingBuilder:
                                                (context, child, progress) {
                                              return progress == null
                                                  ? child
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator());
                                            },
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: Icon(Icons
                                                    .broken_image_outlined),
                                              );
                                            },
                                            fit: BoxFit.contain,
                                            height: 75.0,
                                            width: 75.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(products.name!),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.attach_money_sharp,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          Text(
                                            products.price!,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
