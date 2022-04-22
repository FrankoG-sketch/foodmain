import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/admin/adminDrawer/adminDrawer.dart';
import 'package:shop_app/admin/adminUtils.dart';
import 'package:shop_app/utils/widgets.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  double value = 0.0;
  double total = 0.0;
  final formatCurrency = new NumberFormat.simpleCurrency();
  double mean = 0.0;
  bool tap = false;
  bool _obscureText = true;
  var email;

  var encrpytedPassword;

  @override
  void initState() {
    super.initState();
    getSharedPreferenceData;
  }

  get getSharedPreferenceData async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      encrpytedPassword = sharedPreferences.getString("password");
      email = sharedPreferences.getString("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController confirmPasswordController = TextEditingController();
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: AdminDrawerClass(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Welcome: $email",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
              child: Column(
                children: [
                  Row(children: [
                    Text(
                      "Services",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  ]),
                ],
              ),
            ),
          ),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(vertical: 20.0),
          // ),
          SliverGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 1.0,
            childAspectRatio: 16 / 9,
            children: [
              InkWell(
                onTap: () => openDialog(context, _formkey,
                    confirmPasswordController, '/adminInvertory'),
                child: AdminCards(
                  color: Color.fromARGB(255, 104, 194, 131),
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Inventory",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, '/adminPanelDeliveryView'),
                child: AdminCards(
                  color: Color.fromARGB(255, 8, 146, 38),
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Delivery Men",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/deliveryOrders'),
                child: AdminCards(
                  color: Color.fromARGB(255, 52, 139, 99),
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Delivery Orders",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/adminFoodFilter'),
                child: AdminCards(
                  color: Color.fromARGB(255, 125, 211, 122),
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Food Filter",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(padding: const EdgeInsets.symmetric(vertical: 10)),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
              child: Column(
                children: [
                  Row(children: [
                    Text(
                      "Business Data",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )
                  ]),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/adminFeedBack',
                  ),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("FeedBack")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());
                        else if (snapshot.data!.docs.isEmpty)
                          return Center(
                            child: Text("No Orders"),
                          );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: snapshot.data!.docs.length < 30
                                  ? Theme.of(context).primaryColor
                                  : Colors.red,
                            ),
                            height: size.height * 0.10,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35.0, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Customers Issues: ${snapshot.data!.docs.length}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(height: size.height * 0.02),
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/viewClients',
                  ),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .where("role", isEqualTo: 'User')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());
                        else if (snapshot.data!.docs.isEmpty)
                          return Center(
                            child: Text("No Orders"),
                          );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color.fromARGB(255, 125, 211, 122),
                            ),
                            height: size.height * 0.10,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35.0, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clients: ${snapshot.data!.docs.length}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(height: size.height * 0.02),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .where("role", isEqualTo: 'Delivery')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      else if (snapshot.data!.docs.isEmpty)
                        return Center(
                          child: Text("No Orders"),
                        );
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color.fromARGB(255, 52, 139, 99),
                          ),
                          height: size.height * 0.10,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Delivery Guys Count: ${snapshot.data!.docs.length}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> openDialog(
      BuildContext context,
      GlobalKey<FormState> _formkey,
      TextEditingController confirmPasswordController,
      String route) {
    return showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: SingleChildScrollView(
              child: Text("Enter Password to View Inventory"),
            ),
            content: Form(
              key: _formkey,
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: adminTextFieldForPassword(
                  context,
                  "Enter Password",
                  IconButton(
                    iconSize: 28,
                    color: Theme.of(context).primaryColor,
                    icon: Icon(_obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility),
                    onPressed: () {
                      // _toggle();
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
                controller: confirmPasswordController,
                validator: (value) => value!.isEmpty ? 'Enter password' : null,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('No')),
              TextButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    var isCorrect = new DBCrypt().checkpw(
                        confirmPasswordController.text.trim(),
                        encrpytedPassword);

                    if (isCorrect == true) {
                      Navigator.popAndPushNamed(context, route);
                    } else {
                      Navigator.pop(context);
                      var snackBar = snackBarWidget(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.80,
                                ),
                                child: Text(
                                  "Incorrect Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Icon(
                                Icons.error_outline_sharp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Colors.red);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: Text('Proceed'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AdminCards extends StatelessWidget {
  const AdminCards({
    Key? key,
    required this.color,
    required this.widget,
  }) : super(key: key);

  final Color color;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Card(
        color: color,
        child: widget,
      ),
    );
  }
}
