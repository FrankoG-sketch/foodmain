import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';
import 'package:shop_app/utils/magic_strings.dart';
import 'package:shop_app/utils/widgets.dart';

class HomeData extends StatelessWidget {
  const HomeData({
    Key? key,
    required this.firstName,
  }) : super(key: key);

  final firstName;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    children: [
                                      Text(
                                        "Welcome $firstName",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  FutureBuilder(
                                    future: getCurrentUID(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      return StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(snapshot.data)
                                            .snapshots(),
                                        builder:
                                            (context, AsyncSnapshot firestore) {
                                          User user = FirebaseAuth
                                              .instance.currentUser!;

                                          return Container(
                                            child: !firestore.hasData
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : InkWell(
                                                    onTap: () =>
                                                        Navigator.pushNamed(
                                                            context,
                                                            RouteNames.profile),
                                                    child: Container(
                                                      child: ClipOval(
                                                        child: SizedBox(
                                                          height: 60.0,
                                                          width: 60.0,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: ClipOval(
                                                              child: Image(
                                                                image:
                                                                    NetworkImage(
                                                                  "${firestore.data!['imgUrl']}",
                                                                ),
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        progress) {
                                                                  return progress ==
                                                                          null
                                                                      ? child
                                                                      : CircularProgressIndicator();
                                                                },
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                    'assets/images/profile.png',
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          );
                                        },
                                      );
                                    },
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
    );
  }
}
