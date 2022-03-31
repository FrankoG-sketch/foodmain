import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Authentication/auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var fullName;
  var email;
  @override
  void initState() {
    super.initState();
    getSharedPreferenceData;
  }

  get getSharedPreferenceData async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      fullName = sharedPreferences.getString('name');
      email = sharedPreferences.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        child: FutureBuilder(
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
                          ProfileImage(),
                          UserData(size: size, name: fullName, email: email),
                          SizedBox(height: size.height * 0.20),
                          ExistApp(size: size)
                        ],
                      ),
                    ),
                  );
                return Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }
}

class UserData extends StatelessWidget {
  const UserData({
    Key? key,
    required this.size,
    required this.name,
    required this.email,
  }) : super(key: key);

  final Size size;
  final String? name;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.20,
      width: size.width * 0.80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Card(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.80,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Wrap(
                                children: [
                                  Text("Name: $name"),
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
                            minWidth: MediaQuery.of(context).size.width * 0.80,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Wrap(
                              children: [
                                Column(
                                  children: [Text("Email: $email")],
                                ),
                                Column(
                                  children: [],
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
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(81.0),
      child: Image.asset(
        'assets/images/profile.png',
        height: 120,
        width: 120,
      ),
    );
  }
}

class ExistApp extends StatelessWidget {
  const ExistApp({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Authentication().signOut(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.exit_to_app),
          SizedBox(width: size.width * 0.02),
          Text(
            'Log out',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
