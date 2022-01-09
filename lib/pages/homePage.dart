import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/Model/productModel.dart';
import 'package:shop_app/pages/cart.dart';
import 'package:shop_app/pages/productDetails.dart';
import 'package:shop_app/pages/profile.dart';
import 'package:shop_app/utils/icon.dart';
import 'package:shop_app/utils/special.dart';
import 'package:shop_app/utils/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  void _onTap(int value) {
    setState(() {
      _currentIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      drawer: Drawer(
        child: Center(
          child: ListView(
            children: [
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () async {
                  Authentication().signOut(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          HomeContent(size: size),
          Cart(),
          Profile(),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  ProductModel products;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: getCurrentUID(),
              builder: (context, AsyncSnapshot snapshot) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(snapshot.data)
                      .snapshots(),
                  builder: (context, AsyncSnapshot firestore) {
                    return !firestore.hasData
                        ? Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: structurePageHomePage(
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Wrap(
                                          children: [
                                            Text(
                                              "Welcome ${firestore.data['FullName']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(81.0),
                                          child: SvgPicture.asset(
                                            'assets/images/profile.svg',
                                            height: 60,
                                            width: 60,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          SliverToBoxAdapter(
            child: structurePageHomePage(
              Container(
                height: widget.size.height * 0.15,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "A Summer Suprise",
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Cashback 20%",
                        style: TextStyle(fontSize: 26.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(padding: const EdgeInsets.only(top: 40.0)),
          SliverToBoxAdapter(
            child: structurePageHomePage(
              Container(
                height: widget.size.height * 0.15,
                width: double.infinity,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: iconItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.orange[100],
                            ),
                            height: widget.size.height * 0.06,
                            width: widget.size.width * 0.13,
                            child: Icon(iconItems[index].icon,
                                color: Colors.red[200]),
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                iconItems[index].name,
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverPadding(padding: const EdgeInsets.only(top: 10.0)),
          SliverToBoxAdapter(
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
          SliverPadding(padding: const EdgeInsets.only(top: 20.0)),
          SliverToBoxAdapter(
            child: FutureBuilder(
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
                      height: widget.size.height * 0.25,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
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
                              width: widget.size.width * 0.35,
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
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
                                            child: Icon(
                                                Icons.broken_image_outlined),
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
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 150.0),
          ),
        ],
      ),
    );
  }
}
