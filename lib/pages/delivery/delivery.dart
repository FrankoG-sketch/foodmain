import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/Model/userDeliveryInformationModel.dart';
import 'package:shop_app/utils/magic_strings.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:intl/intl.dart';

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
        await Navigator.pushNamed(context, RouteNames.deliveryWorkers);
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
                          DocumentSnapshot keyword = snapshot.data!.docs[index];
                          UserDeliveryModel userDeliveryModel =
                              UserDeliveryModel.fromJson(
                                  keyword.data() as Map<String, dynamic>);

                          double total = 0;
                          for (var i in snapshot.data!.docs[index]
                              ['products infor']) {
                            total += double.parse(i['price']) *
                                double.parse(i['Quantity']);
                          }
                          return InkWell(
                            onTap: userDeliveryModel.deliveryProgress !=
                                    'pending'.toLowerCase()
                                ? () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Task Failed"),
                                            content: SingleChildScrollView(
                                              child: Text(
                                                  "Unfortunately, this order has already been shipped to you. We are sorry for any inconviences this may produce."),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Ok"))
                                            ],
                                          );
                                        });
                                  }
                                : () {
                                    showDialog(
                                        context: context,
                                        builder: (builder) {
                                          return AlertDialog(
                                            title: Text("Cancel Order"),
                                            content: SingleChildScrollView(
                                              child: Text(
                                                  "By clicking yes, you are about cancel your order. This means this order will no longer be shipped to you and you'll be alerted as soon as possible about your refund."),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text("Cancel")),
                                              TextButton(
                                                  onPressed: () async {
                                                    var cancelledOrdersObject =
                                                        {
                                                      "Client name":
                                                          userDeliveryModel
                                                              .clientName,
                                                      "Delivery Progress":
                                                          userDeliveryModel
                                                              .deliveryProgress,
                                                      "Task Completed":
                                                          userDeliveryModel
                                                              .taskCompleted,
                                                      "address":
                                                          userDeliveryModel
                                                              .address,
                                                      "date made":
                                                          userDeliveryModel
                                                              .dateCancelled,
                                                      "date cancelled":
                                                          Timestamp.now(),
                                                      "directions":
                                                          userDeliveryModel
                                                              .directions,
                                                      "products infor":
                                                          userDeliveryModel
                                                              .productsInfo,
                                                      "selected personal":
                                                          userDeliveryModel
                                                              .selectedPersonal,
                                                      "uid":
                                                          userDeliveryModel.uid,
                                                      "refunded": false,
                                                      "compoundKey":
                                                          userDeliveryModel.uid
                                                                  .toString()
                                                                  .trim() +
                                                              userDeliveryModel
                                                                  .dateCancelled
                                                                  .toString()
                                                                  .trim()
                                                    };

                                                    FirebaseFirestore.instance
                                                        .collection("Delivery")
                                                        .doc(userDeliveryModel
                                                            .uid
                                                            .toString()
                                                            .trim())
                                                        .delete();

                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "Cancelled Orders")
                                                        .doc(userDeliveryModel
                                                                .uid
                                                                .toString()
                                                                .trim() +
                                                            userDeliveryModel
                                                                .dateCancelled
                                                                .toString()
                                                                .trim())
                                                        .set(
                                                            cancelledOrdersObject);

                                                    Navigator.pop(context);

                                                    Fluttertoast.showToast(
                                                        msg: "Order Cancelled");
                                                  },
                                                  child: Text("Ok"))
                                            ],
                                          );
                                        });
                                  },
                            child: Column(
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
                                                'Client name: ${userDeliveryModel.clientName}',
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
                                                'Delivery Progress: ${userDeliveryModel.deliveryProgress}',
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
                                                'Date made: ${DateFormat.yMMMd().format(userDeliveryModel.dateCancelled!.toDate())}',
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
                                              if (userDeliveryModel
                                                      .selectedPersonal ==
                                                  null) ...[
                                                Text(
                                                  "Delivery Personnel: No Driver selected as yet",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'PlayfairDisplay',
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ] else
                                                Text(
                                                  'Delivery Personnel: ${userDeliveryModel.selectedPersonal}',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'PlayfairDisplay',
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Row(
                                            children: [
                                              Text(
                                                "Total: \$$total",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var i in userDeliveryModel
                                                  .productsInfo!)
                                                Builder(
                                                  builder: (context) {
                                                    double total = 0;
                                                    List items =
                                                        userDeliveryModel
                                                            .productsInfo!
                                                            .map((e) {
                                                      if (e['user name'] ==
                                                          i['user name'])
                                                        return e;
                                                    }).toList();
                                                    items.forEach((element) {
                                                      total += double.parse(
                                                              element[
                                                                  'price']) *
                                                          int.parse(element[
                                                              'Quantity']);
                                                    });

                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Products: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(i['name']),
                                                            Text(
                                                                ' x ${i['Quantity']}'),
                                                            Text(
                                                                ' = \$${i['price']}')
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
