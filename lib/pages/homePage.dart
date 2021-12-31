import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/utils/icon.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, AsyncSnapshot snapshot) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(snapshot.data)
                .snapshots(),
            builder: (context, AsyncSnapshot firestore) {
              //  User user = FirebaseAuth.instance.currentUser;
              return !firestore.hasData
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 50),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
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
                                    borderRadius: BorderRadius.circular(81.0),
                                    child: SvgPicture.asset(
                                      'assets/images/profile.svg',
                                      height: 60,
                                      width: 60,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Container(
                                height: size.height * 0.15,
                                width: size.width * 0.95,
                                decoration: BoxDecoration(
                                  color: Colors.purple[900],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "A Summer Suprise",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Cashback 20%",
                                        style: TextStyle(
                                            fontSize: 26.0,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 35.0),
                              child: Container(
                                height: size.height * 0.50,
                                width: double.infinity,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: iconItems.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Colors.orange[100],
                                              ),
                                              height: size.height * 0.06,
                                              width: size.width * 0.13,
                                              child: Icon(iconItems[index].icon,
                                                  color: Colors.red[200]),
                                            ),
                                            SizedBox(height: 2.0),
                                            Text(
                                              iconItems[index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
            },
          );
        },
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
    );
  }
}
