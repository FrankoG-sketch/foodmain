import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/productModel.dart';
import 'package:shop_app/pages/productDetails.dart';
import 'package:shop_app/utils/store_provider.dart';

class ProductPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Products"),
        backgroundColor: Color(0xFF40BF73),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getCurrentUID(),
          builder: (context, snapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(ref.watch(storeProvider))
                  .where('tag', isEqualTo: 'popular items')
                  .orderBy("name")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    ],
                  );
                print(snapshot.data!.docs.length);
                return Container(
                  height: size.height,
                  width: double.infinity,
                  child: ListView.builder(
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
                        child: Container(
                          padding: const EdgeInsets.only(top: 50),
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            : CircularProgressIndicator();
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
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
                                    Text(products.name!),
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
                                      products.price!,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                )
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
        ),
      ),
    );
  }
}
