import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Delivery extends StatefulWidget {
  const Delivery({Key? key}) : super(key: key);

  @override
  State<Delivery> createState() => _DeliveryState();
}

enum PageEnum {
  foodFilter,
}

class _DeliveryState extends State<Delivery> {
  _onSelect(PageEnum value) async {
    switch (value) {
      case PageEnum.foodFilter:
        await Navigator.pushNamed(context, '/deliveryWorkers');
        break;
      default:
        print("Something went wrong");
        break;
    }
  }

  TutorialCoachMark? tutorialCoachMark;

  List<TargetFocus> targets = [];

  GlobalKey keyButton1 = GlobalKey();

  @override
  void initState() {
    super.initState();
    initTargets();
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayout);
  }

  @override
  void dispose() {
    super.dispose();
    initTargets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Delivery"),
        actions: [
          PopupMenuButton(
            key: keyButton1,
            onSelected: _onSelect,
            child: Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
            itemBuilder: (context) => <PopupMenuEntry<PageEnum>>[
              PopupMenuItem<PageEnum>(
                value: PageEnum.foodFilter,
                child: Text("Delivery Workers"),
              ),
            ],
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: getCurrentUID(),
          builder: (context, AsyncSnapshot snapshot) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Delivery")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.data!.docs.isEmpty)
                    return Center(
                      child: Text("Nothing being delivered"),
                    );
                  return DeliveryList(documents: snapshot.data!.docs);
                });
          },
        ),
      ),
    );
  }

  Future<void> initTargets() async {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton1,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Delivery men",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 35.0),
                        ),
                      ],
                    ),
                    Divider(color: Colors.white),
                    SizedBox(height: 60),
                    Text(
                      "Click here to view and rate the delivery men",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showTutorial() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var intro = preferences.getBool('deliveryMen') ?? false;
    if (!intro) {
      tutorialCoachMark = TutorialCoachMark(context,
          alignSkip: Alignment.bottomLeft,
          targets: targets,
          colorShadow: Color.fromARGB(255, 14, 13, 13),
          textSkip: "SKIP",
          paddingFocus: 10,
          opacityShadow: 0.8, onFinish: () {
        print("finish");
      }, onClickTarget: (target) {
        print(target);
      }, onSkip: () {
        print("skip");
      })
        ..show();
    }
    await preferences.setBool('deliveryMen', true);
  }

  void _afterLayout(_) {
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        showTutorial();
      },
    );
  }
}

class DeliveryList extends StatefulWidget {
  const DeliveryList({Key? key, this.documents}) : super(key: key);
  final List<DocumentSnapshot>? documents;

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  Future<void> _getUid() async {
    var uid = await getCurrentUID();
    setState(() {
      uidKey = uid;
    });
  }

  var uidKey;
  var uid;

  @override
  void initState() {
    _getUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getCurrentUID(),
            builder: (context, snapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Delivery")
                    .where('uid', isEqualTo: uidKey)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.connectionState == ConnectionState.active) {
                    return Scrollbar(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemBuilder: (context, index) {
                          DocumentSnapshot point = snapshot.data!.docs[index];

                          // var uidFromCart = point['uid'];

                          // if (uidFromCart == uid) {
                          //   return Container(height: 0);
                          // }

                          // double myPrices = double.parse(
                          //   point['price'].toString().replaceAll(",", ""),
                          // );
                          // int myQuantity = int.parse(
                          //   point['Quantity'].toString().replaceAll(",", ""),
                          // );

                          // value = myPrices * myQuantity;

                          // total += value;

                          // mean = total;
                          // print(mean);

                          return Column(
                            children: [
                              SingleChildScrollView(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35.0, vertical: 35.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Client name: ${point['Client name']}',
                                              style: TextStyle(
                                                fontFamily: 'PlayfairDisplay',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Delivery Progress: ${point['Delivery Progress']}',
                                              style: TextStyle(
                                                fontFamily: 'PlayfairDisplay',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Date made: ${point['date'].toDate()}',
                                              style: TextStyle(
                                                fontFamily: 'PlayfairDisplay',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Text("Nothing."),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
