import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class FeedBackHelp extends StatefulWidget {
  @override
  _FeedBackHelpState createState() => _FeedBackHelpState();
}

class _FeedBackHelpState extends State<FeedBackHelp> {
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  GlobalKey keyButton = GlobalKey();

  @override
  void initState() {
    initTarget();
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed Back"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return FirestoreListView();
                });
          }),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: FutureBuilder(
            future: getCurrentUID(),
            builder: (context, AsyncSnapshot snapshot) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('FeedBack')
                    //.where("User", isEqualTo: snapshot.data)
                    .orderBy("Date", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.data!.docs.isEmpty)
                    return Center(child: Text("No feedback found..."));
                  return FeedbackList(documents: snapshot.data!.docs);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> initTarget() async {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Click the '+'",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'PlayfairDisplay - Regular',
                      fontSize: 35.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "To create a new feedback",
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay - Regular',
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void showTutorial() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var feed = preferences.getBool('feed') ?? false;
    if (!feed) {
      tutorialCoachMark = TutorialCoachMark(context,
          targets: targets,
          colorShadow: Color(0xff616161),
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
    await preferences.setBool('feed', true);
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }
}

class FeedbackList extends StatefulWidget {
  final List<DocumentSnapshot>? documents;
  const FeedbackList({Key? key, this.documents}) : super(key: key);
  @override
  _FeedbackListState createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, AsyncSnapshot snapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('FeedBack')
              .where("User", isEqualTo: uid)
              //   .orderBy("Date", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null)
              return Center(child: CircularProgressIndicator());
            return Scrollbar(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets?.fromLTRB(12.0, 15, 12.0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return FirestoreListView(
                                  document: this.widget.documents![index],
                                );
                              });
                        },
                        title: Text('Feedback: ' +
                            '${this.widget.documents![index]['FeedBack']}'),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class FirestoreListView extends StatefulWidget {
  final DocumentSnapshot? document;
  FirestoreListView({this.document});
  @override
  _FirestoreListViewState createState() => _FirestoreListViewState();
}

class _FirestoreListViewState extends State<FirestoreListView>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  PageController? pageController;

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Field cannot be left empty'),
  ]);

  bool isloading = false;
  bool autoValidate = true;
  String? feedBack = '';

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true);
    if (widget.document != null) {
      feedBack = this.widget.document!['FeedBack'];
    }
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(fontFamily: 'PlayfairDisplay'),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      onPressed: () {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot =
              await transaction.get(widget.document!.reference);
          transaction.delete(snapshot.reference);
          Fluttertoast.showToast(
            msg: 'Feedback Deleted',
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.pop(context);
          Navigator.pop(context);
        }).catchError(
          (onError) {
            print("Error");
            Fluttertoast.showToast(
                msg: "Please try again or" + " connect to a stable network",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.grey[700],
                textColor: Colors.grey[50],
                gravity: ToastGravity.CENTER);
            Navigator.pop(context);
          },
        );
      },
      child: Text(
        "Ok",
        style: TextStyle(fontFamily: 'PlayfairDisplay'),
      ),
    );

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Delete Feedback",
              style: TextStyle(fontFamily: 'PlayfairDisplay - Regular'),
            ),
            content: Text(
              "Are you sure you want to permanently delete this feedback?",
              style: TextStyle(
                  fontSize: 12.0, fontFamily: 'PlayfairDisplay - Regular'),
            ),
            actions: <Widget>[
              cancelButton,
              okButton,
            ],
          );
        },
      );
    }

    void _showDialog2() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Network Failure"),
            content: Wrap(
              children: [
                Text("Feedback will be saved automatically"
                    " when you reconnect to a stable network.")
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("FeedBack Details"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.20),
            Text(
              'Fill Out Application Form',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 30.0),
            Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: TextFormField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Enter feedback here",
                          hintStyle: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.all(
                              new Radius.circular(10.0),
                            ),
                          ),
                        ),
                        enabled: !isloading,
                        onSaved: (value) => feedBack = value,
                        initialValue: feedBack,
                        maxLength: 200,
                        validator: passwordValidator,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: isloading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: this.widget.document != null
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: SizedBox(
                                    height: 50.0,
                                    width: 120,
                                    child: MaterialButton(
                                      color: Theme.of(context).primaryColor,
                                      child: Text(
                                        "Send Feedback",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate()) {
                                          try {
                                            if (mounted)
                                              setState(() {
                                                isloading = !isloading;
                                              });
                                            _formkey.currentState!.save();
                                            var id = await getCurrentUID();
                                            var date =
                                                FieldValue.serverTimestamp();

                                            String? name = FirebaseAuth.instance
                                                .currentUser!.displayName;
                                            var feedObject = {
                                              "User": id,
                                              "FeedBack": feedBack,
                                              "Date": date,
                                              "Name": name,
                                            };
                                            widget.document == null
                                                ? FirebaseFirestore.instance
                                                    .collection('FeedBack')
                                                    .add(feedObject)
                                                    .then((value) {
                                                    Fluttertoast.showToast(
                                                        msg: 'Your Feedback' +
                                                            ' has been saved');

                                                    Navigator.pop(context);
                                                  }).timeout(
                                                        Duration(seconds: 10),
                                                        onTimeout: () {
                                                    setState(() {
                                                      isloading = false;
                                                      _showDialog2();
                                                      print("Error");
                                                    });
                                                  })
                                                : FirebaseFirestore.instance
                                                    .runTransaction(
                                                        (transaction) async {
                                                    DocumentSnapshot snapshot =
                                                        await transaction.get(
                                                            widget.document!
                                                                .reference);

                                                    transaction.update(
                                                        snapshot.reference,
                                                        feedObject);

                                                    Fluttertoast.showToast(
                                                      msg: 'Your feedback has' +
                                                          ' been saved',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                    );
                                                    Navigator.pop(context);
                                                  }).catchError((onError) {
                                                    setState(() {
                                                      isloading = false;
                                                      Fluttertoast.showToast(
                                                          msg: "Please try again or" +
                                                              " connect to a stable network",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          backgroundColor:
                                                              Colors.grey[700],
                                                          textColor:
                                                              Colors.grey[50],
                                                          gravity: ToastGravity
                                                              .CENTER);
                                                      print("Error");
                                                    });
                                                  });
                                          } catch (e) {
                                            if (mounted)
                                              setState(() {
                                                isloading = false;
                                              });
                                            print(e);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                if (this.widget.document != null)
                                  SizedBox(
                                    width: 120.0,
                                    height: 50.0,
                                    child: MaterialButton(
                                      color: Theme.of(context).primaryColor,
                                      child: Text(
                                        'Delete Feedback',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        _showDialog();
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
