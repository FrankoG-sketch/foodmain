import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Model/AllFoodModel.dart';
import 'package:shop_app/pages/iconWidgetPages/searchDelegate.dart';
import 'package:shop_app/pages/productDetails.dart';

import '../../Authentication/auth.dart';

class Protein extends StatelessWidget {
  const Protein({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Protein")
              .orderBy("name")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.data!.docs.isEmpty)
              return Center(
                child: Text("No Food For this Segment"),
              );
            return Scaffold(
              appBar: AppBar(
                title: Text("Protein Goods"),
                backgroundColor: Theme.of(context).primaryColor,
                actions: [
                  IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate:
                              MySearchDelegate(snapshot.data!.docs, "Protein"),
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
