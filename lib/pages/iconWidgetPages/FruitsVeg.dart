import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/Model/AllFoodModel.dart';
import 'package:shop_app/pages/iconWidgetPages/searchDelegate.dart';
import 'package:shop_app/pages/productDetails.dart';
import 'package:shop_app/utils/store_provider.dart';

import '../../Authentication/auth.dart';

class FruitsAndVeg extends ConsumerWidget {
  const FruitsAndVeg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(ref.watch(storeProvider))
              .orderBy("name")
              .where("tag", isEqualTo: "fruitsVeg")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Scaffold(
                appBar: AppBar(
                  title: Text("Fruits and Vegetables"),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Food For this Segment is currently not available at this supermarket, please switch to the next branch and try again."),
                      TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/profile'),
                          child: Text("Switch Branch")),
                    ],
                  ),
                ),
              );
            return Scaffold(
              appBar: AppBar(
                title: Text("Fruits and Vegetables"),
                backgroundColor: Theme.of(context).primaryColor,
                actions: [
                  IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: MySearchDelegate(snapshot.data!.docs,
                              ref.watch(storeProvider), "fruitsVeg"),
                        );
                      },
                      icon: Icon(Icons.search))
                ],
              ),
              body: Container(
                height: size.height,
                width: double.infinity,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot keyword = snapshot.data!.docs[index];
                    AllFoodsModel allFoodsModel = AllFoodsModel.fromJson(
                        keyword.data() as Map<String, dynamic>);

                    return InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/productDetails',
                        arguments: ProductDetails(
                          heroTag: allFoodsModel.img,
                          name: allFoodsModel.name,
                          price: allFoodsModel.price,
                          rating: allFoodsModel.rating,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: SizedBox(
                          height: size.height * 0.12,
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Image(
                                          image: NetworkImage(
                                            allFoodsModel.img!,
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
                                              child: Icon(
                                                  Icons.broken_image_outlined),
                                            );
                                          },
                                          fit: BoxFit.cover,
                                          height: size.height * 0.10,
                                          width: size.width * 0.10,
                                        ),
                                      ),
                                      Text(allFoodsModel.name!),
                                      Text('\$${allFoodsModel.price!}'),
                                    ],
                                  ),
                                ],
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
        );
      },
    );
  }
}
