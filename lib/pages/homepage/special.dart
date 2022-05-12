import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/productModel.dart';
import 'package:shop_app/pages/homepage/homePage.dart';
import 'package:shop_app/utils/magic_strings.dart';
import 'package:shop_app/utils/store_provider.dart';
import 'package:shop_app/utils/widgets.dart';

class SpecialBody extends ConsumerWidget {
  const SpecialBody({
    Key? key,
    required this.widget,
    required this.size,
  }) : super(key: key);

  final HomeContent widget;
  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return SliverToBoxAdapter(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(ref.watch(storeProvider))
                .orderBy("name")
                .where("tag", isEqualTo: "special items")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return Center(child: CircularProgressIndicator());
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.data!.docs.isEmpty)
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "The Special Items are unavailible for this supermarket at this time, please select another supermarket"),
                    ],
                  ),
                );
              return Container(
                height: widget.size.height * 0.30,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Special for you",
                              style: TextStyle(fontSize: 19.0),
                            ),
                            TextButton(
                                child: Text("See more"),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RouteNames.specialItems);
                                }),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot keyword =
                                snapshot.data!.docs[index];
                            ProductModel products = ProductModel.fromJson(
                                keyword.data() as Map<String, dynamic>);

                            return InkWell(
                              onTap: () => Navigator.pushNamed(
                                context,
                                RouteNames.specialItems,
                              ),
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
                                            padding: const EdgeInsets.all(18.0),
                                            child: Icon(
                                                Icons.broken_image_outlined),
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
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
