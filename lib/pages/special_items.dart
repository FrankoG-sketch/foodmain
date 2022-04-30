import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/specialModel.dart';
import 'package:shop_app/pages/productDetails.dart';
import 'package:shop_app/utils/store_provider.dart';

class Specialitems extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Special items'),
      ),
      body: Container(
        height: size.height,
        child: FutureBuilder(
          future: getCurrentUID(),
          builder: (context, snapshot) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(ref.watch(storeProvider))
                  .orderBy("name")
                  .where("tag", isEqualTo: "special items")
                  .snapshots(),
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

                return Container(
                  height: size.height,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot keyword = snapshot.data!.docs[index];
                      SpecialModel specialModel = SpecialModel.fromJson(
                          keyword.data() as Map<String, dynamic>);
                      return InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/productDetails',
                          arguments: ProductDetails(
                            heroTag: specialModel.imgPath,
                            name: specialModel.name,
                            price: specialModel.price,
                            rating: specialModel.rating,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          child: Container(
                            height: size.height * 0.25,
                            width: double.infinity,
                            child: Stack(children: [
                              Hero(
                                tag: specialModel.imgPath!,
                                child: Image(
                                  image: NetworkImage(
                                    specialModel.imgPath!,
                                  ),
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : CircularProgressIndicator();
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Icon(Icons.broken_image_outlined),
                                    );
                                  },
                                  fit: BoxFit.fitWidth,
                                  //                  colorFilter: ColorFilter.mode(
                                  // // Colors.black.withOpacity(0.50), BlendMode.darken),
                                  // color: Colors.white.withOpacity(0.70),
                                  // colorBlendMode: BlendMode.modulate,
                                  width: double.infinity,
                                ),
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.70),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: size.width * 0.80,
                                          ),
                                          child: Text(
                                            specialModel.name!,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: size.width * 0.80,
                                          ),
                                          child: Text(
                                            '\$${specialModel.price!}',
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: size.width * 0.80,
                                          ),
                                          child: Text(
                                            specialModel.memo!,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ]),
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
