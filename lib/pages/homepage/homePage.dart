import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/productModel.dart';
import 'package:shop_app/pages/cart.dart';
import 'package:shop_app/pages/delivery/delivery.dart';
import 'package:shop_app/pages/homepage/homePageDateInfo.dart';
import 'package:shop_app/pages/homepage/popularProduct.dart';
import 'package:shop_app/pages/homepage/services.dart';
import 'package:shop_app/pages/homepage/special.dart';
import 'package:shop_app/pages/homepage/specialOffer.dart';
import 'package:shop_app/pages/productDetails.dart';
import 'package:shop_app/pages/profile/profile.dart';
import 'package:shop_app/utils/icon.dart';
import 'package:shop_app/utils/jam_icons_icons.dart';
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
            icon: Icon(JamIcons.home),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(JamIcons.cart),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(JamIcons.delivery),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(JamIcons.profile),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          HomeContent(size: size),
          Cart(),
          Delivery(),
          Profile(),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  ProductModel? products;

  var fullName;
  var firstName;

  @override
  void initState() {
    super.initState();

    checkForFirstTimeUser();

    getSharedPreferenceData();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.60),
                              child: Text(
                                notification.body.toString(),
                                style: TextStyle(fontSize: 12.0),
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Ok',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('A new onMessageOpenedApp event was published');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification!.android;
        if (notification != null && android != null) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.60),
                              child: Text(
                                notification.body.toString(),
                                style: TextStyle(fontSize: 12.0),
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Ok',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  getSharedPreferenceData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      fullName = sharedPreferences.getString('name');
      var names = fullName.split(" ");
      firstName = names[0];
    });
  }

  int _selectedIndex = 0;

  List<Map> items = [];

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  String currentTag = 'All';

  void setTag(String tag) {
    setState(() {
      currentTag = tag;
    });
  }

  List get itemList {
    if (currentTag == "All") return iconItems;
    return iconItems.where((e) => e.tag == currentTag).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(padding: const EdgeInsets.symmetric(vertical: 20)),
          HomeData(firstName: firstName),
          SliverPadding(padding: const EdgeInsets.symmetric(vertical: 20)),
          SpecialOffers(widget: widget),
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
                    return InkWell(
                      onTap: () {
                        setTag(iconItems[index].tag);
                        _onSelected(index);
                        if (index == 0) {
                          Navigator.pushNamed(context, '/allFoods');
                        }
                        if (index == 1) {
                          Navigator.pushNamed(context, '/starch');
                        }
                        if (index == 2) {
                          Navigator.pushNamed(context, '/protein');
                        }
                        if (index == 3) {
                          Navigator.pushNamed(context, '/fruits&Veg');
                        }
                        if (index == 4) {
                          Navigator.pushNamed(context, '/diary');
                        }
                      },
                      child: Container(
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
                                  iconItems[index].tag,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SpecialHeader(),
          SpecialBody(widget: widget, size: size),
          SliverPadding(padding: const EdgeInsets.only(top: 30.0)),
          PopularProductHeader(),
          ProductBody(widget: widget),
          SliverPadding(padding: const EdgeInsets.only(top: 30.0)),
          ServiceHeader(),
          SliverPadding(padding: const EdgeInsets.only(top: 30.0)),
          Services(size: size),
          SliverPadding(padding: const EdgeInsets.only(top: 200.0)),
        ],
      ),
    );
  }

  Future checkForFirstTimeUser() async {
    var uid = await getCurrentUID();
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    if (snapshot.exists) {
      Map<String, dynamic>? fetchDoc = snapshot.data() as Map<String, dynamic>?;

      var address = fetchDoc?['address'];

      FirebaseFirestore.instance
          .collection("Users")
          .where('uid', isEqualTo: uid)
          .get()
          .then(
        (value) {
          if (address == '') {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/registerAddress', (Route<dynamic> route) => false);
          }
        },
      );
    }
  }
}
