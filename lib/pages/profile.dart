import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/Authentication/auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none)
                return Center(
                  child: Text("No Data"),
                );

              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());

              if (snapshot.connectionState == ConnectionState.active)
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(81.0),
                          child: SvgPicture.asset(
                            'assets/images/profile.svg',
                            height: 120,
                            width: 120,
                          ),
                        ),
                        Container(
                          height: size.height * 0.50,
                          width: size.width * 0.80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              SizedBox(height: 50),
                              Center(
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            Expanded(
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.80,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Wrap(
                                                    children: [
                                                      Text("Name: "),
                                                      Text(snapshot
                                                          .data['FullName']),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                          ),
                                          Expanded(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.80,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Wrap(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text("Email: ")
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(snapshot
                                                            .data['email']),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
