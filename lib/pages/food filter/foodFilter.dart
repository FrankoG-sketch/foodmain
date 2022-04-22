import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/utils/widgets.dart';

class FoodFilter extends StatefulWidget {
  @override
  State<FoodFilter> createState() => _FoodFilterState();
}

class _FoodFilterState extends State<FoodFilter> {
  bool filterDetected = false;
  bool isloading = true;

  var uidKey;
  @override
  void initState() {
    super.initState();
    getFilter();
  }

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    return Container(
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: getCurrentUID(),
                //let me show u sumn...
                builder: (context, AsyncSnapshot snapshot) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Food Filter")
                          .where("uid", isEqualTo: uid)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return Scaffold(
                          floatingActionButton: !snapshot.hasData
                              ? SizedBox.shrink()
                              : snapshot.data!.docs.isEmpty
                                  ? FloatingActionButton(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      onPressed: (() async {
                                        await Navigator.pushNamed(
                                            context, '/foodFilterData',
                                            arguments: FilterFoodData(
                                                getFilters: getFilter));
                                        await getFilter();
                                      }),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                          appBar: AppBar(
                            backgroundColor: Theme.of(context).primaryColor,
                            title: Text("Food Filter"),
                          ),
                          body: Builder(
                            //let me show u sumn...
                            builder: (context) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              return FilterList(
                                  documents: snapshot.data!.docs,
                                  getFilters: () => getFilter());
                            },
                          ),
                        );
                      });
                }));
  }

  Future getFilter() async {
    var uid = await getCurrentUID();

    print("function called");

    setState(() {
      uidKey = uid;
    });

    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Food Filter")
        .doc(uid)
        .get();

    var collection = FirebaseFirestore.instance.collection('Food Filter');
    var docSnapshot = await collection.doc(uid).get();

    if (docSnapshot.exists) {
      setState(() {
        isloading = false;
        filterDetected = true;
      });
    }

    if (docSnapshot.exists == false) {
      setState(() {
        isloading = false;
      });
    }
  }
}

class FilterList extends StatefulWidget {
  final List<DocumentSnapshot>? documents;

  final VoidCallback getFilters;

  const FilterList({
    Key? key,
    this.documents,
    required this.getFilters,
  }) : super(key: key);

  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  Future<void> _getUid() async {
    var uid = await getCurrentUID();
    setState(() {
      uidKey = uid;
    });
  }

  var uidKey;
  @override
  void initState() {
    super.initState();
    this.widget.getFilters();
    _getUid();
  }

  bool filterDetected = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, AsyncSnapshot snapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Food Filter")
                .where('uid', isEqualTo: uidKey)
                //checks if the uid is equal cause more than one user
                //maybe u dont need to know, but just telling u incase
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null)
                return Center(child: CircularProgressIndicator());

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (() => showDialog(
                          context: context,
                          builder: (builder) {
                            return FilterFoodData(
                                document: this.widget.documents![index],
                                getFilters: () => this.widget.getFilters);
                          },
                        )),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35.0, vertical: 35.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            "Diet Type: ${this.widget.documents![index]['diet type']}")
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.04),
                                    Row(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: size.width * 0.80,
                                          ),
                                          child: Text(
                                              "Allergy: ${this.widget.documents![index]['allergy']}"),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.04),
                                    Row(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: size.width * 0.80),
                                          child: Text(
                                              "Exercise Plan: ${this.widget.documents![index]['exercise plan']}"),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.04),
                                    Row(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: size.width * 0.80,
                                          ),
                                          child: Text(
                                              "Special Diet: ${this.widget.documents![index]['special diet']}"),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FilterFoodData extends StatefulWidget {
  final DocumentSnapshot? document;
  final VoidCallback getFilters;
  FilterFoodData({this.document, required this.getFilters});

  @override
  State<FilterFoodData> createState() => _FilterFoodDataState();
}

class _FilterFoodDataState extends State<FilterFoodData> {
  User user = FirebaseAuth.instance.currentUser!;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PageController? pageController;

  late String diet, allergy, specialDietPlan, exercisePlanType = '';

  TextEditingController dietType = TextEditingController(text: 'Meatatarian');
  TextEditingController allergies = TextEditingController();
  TextEditingController specialDiet = TextEditingController();
  TextEditingController exercisePlan = TextEditingController();

  bool isloading = false;

  @override
  void initState() {
    super.initState();
    this.widget.getFilters();
    pageController = PageController(keepPage: true);
    if (widget.document != null) {
      dietType.text = this.widget.document!['diet type'];
      allergies.text = this.widget.document!['allergy'];
      specialDiet.text = this.widget.document!['special diet'];
      exercisePlan.text = this.widget.document!['exercise plan'];
    }
    diet = dietType.text;
    allergy = allergies.text;
    specialDietPlan = specialDiet.text;
    exercisePlanType = exercisePlan.text;
  }

  @override
  void dispose() {
    super.dispose();
    this.widget.getFilters();
    pageController?.dispose();
    print("testing");
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
      ),
      onPressed: () {
        this.widget.getFilters();
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      child: Text(
        "Ok",
      ),
      onPressed: () {
        FirebaseFirestore.instance.runTransaction(
          (transaction) async {
            DocumentSnapshot snapshot =
                await transaction.get(widget.document!.reference);
            transaction.delete(snapshot.reference);
            Fluttertoast.showToast(
              msg: 'Food Filter Deleted',
              toastLength: Toast.LENGTH_SHORT,
            ).then((value) => this.widget.getFilters());
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ).catchError((onError) {
          print("Error");
          Fluttertoast.showToast(
              msg: "Please try again or" + " connect to a stable network",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.grey[700],
              textColor: Colors.grey[50],
              gravity: ToastGravity.CENTER);
          Navigator.pop(context);
        });
      },
    );
    void deleteFilter() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Delete Food Filter",
            ),
            content: Text(
              "Are you sure you want to " +
                  "permanently delete this Food Filter?",
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            actions: <Widget>[
              cancelButton,
              okButton,
            ],
          );
        },
      );
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              closingDialogButton(context),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 35.0, vertical: 10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(child: dropdownButtonStyle()),
                      SizedBox(height: size.height * 0.07),
                      TextFormField(
                        maxLines: 3,
                        controller: allergies,
                        decoration:
                            textFieldInputDecoration(context, 'Enter Allergy'),
                      ),
                      SizedBox(height: size.height * 0.07),
                      TextFormField(
                        maxLines: 3,
                        decoration: textFieldInputDecoration(
                            context, 'Enter Special Diet'),
                        controller: specialDiet,
                      ),
                      SizedBox(height: size.height * 0.07),
                      TextFormField(
                        maxLines: 3,
                        controller: exercisePlan,
                        decoration: textFieldInputDecoration(
                            context, 'Enter exercise plan'),
                      ),
                      SizedBox(height: size.height * 0.07),
                      Container(
                        child: this.widget.document == null
                            ? SizedBox(
                                height: size.height * 0.10,
                                width: double.infinity,
                                child: isloading
                                    ? Center(child: CircularProgressIndicator())
                                    : MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () async {
                                          setState(() {
                                            isloading = true;
                                          });
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());

                                          String? fullName = FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .displayName;

                                          var uid = await getCurrentUID();
                                          var dietObject = {
                                            "diet type": dietType.text,
                                            "allergy": allergies.text,
                                            "special diet": specialDiet.text,
                                            "exercise plan": exercisePlan.text,
                                            "uid": uid,
                                            "clientName": fullName,
                                          };
                                          widget.document == null
                                              ? FirebaseFirestore.instance
                                                  .collection("Food Filter")
                                                  .doc(uid)
                                                  .set(dietObject)
                                                  .then((value) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Your Food Filter has been saved');
                                                  this.widget.getFilters();
                                                  Navigator.pop(context);
                                                }).timeout(Duration(seconds: 5),
                                                      onTimeout: () {
                                                  setState(() {
                                                    isloading = false;
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
                                                      dietObject);
                                                  this.widget.getFilters();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Your Food Filter has been updated');
                                                  Navigator.pop(context);
                                                }).catchError(
                                                  (onError) {
                                                    setState(
                                                      () {
                                                        isloading = false;
                                                        Fluttertoast.showToast(
                                                            msg: "Please try again or" +
                                                                " connect to a stable network",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[700],
                                                            textColor:
                                                                Colors.grey[50],
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER);
                                                      },
                                                    );
                                                  },
                                                );
                                        },
                                        child: Text(
                                          "Save Filter",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.10,
                                    width: size.width * 0.30,
                                    child: isloading
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : MaterialButton(
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () async {
                                              setState(() {
                                                isloading = true;
                                              });
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());

                                              var uid = await getCurrentUID();
                                              var dietObject = {
                                                "diet type": dietType.text,
                                                "allergy": allergies.text,
                                                "special diet":
                                                    specialDiet.text,
                                                "exercise plan":
                                                    exercisePlan.text,
                                                "uid": uid,
                                              };
                                              widget.document == null
                                                  ? FirebaseFirestore.instance
                                                      .collection("Food Filter")
                                                      .add(dietObject)
                                                      .then((value) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Your Food Filter has been saved');
                                                      Navigator.pop(context);
                                                      this.widget.getFilters();
                                                    }).timeout(
                                                          Duration(seconds: 5),
                                                          onTimeout: () {
                                                      setState(() {
                                                        isloading = false;
                                                        print("Error");
                                                      });
                                                    })
                                                  : FirebaseFirestore.instance
                                                      .runTransaction(
                                                          (transaction) async {
                                                      DocumentSnapshot
                                                          snapshot =
                                                          await transaction.get(
                                                              widget.document!
                                                                  .reference);
                                                      this.widget.getFilters();
                                                      transaction.update(
                                                          snapshot.reference,
                                                          dietObject);
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Your Food Filter has been updated');
                                                      Navigator.pop(context);
                                                    }).catchError(
                                                      (onError) {
                                                        setState(
                                                          () {
                                                            isloading = false;
                                                            Fluttertoast.showToast(
                                                                msg: "Please try again or" +
                                                                    " connect to a stable network",
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        700],
                                                                textColor:
                                                                    Colors.grey[
                                                                        50],
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER);
                                                          },
                                                        );
                                                      },
                                                    );
                                            },
                                            child: Text(
                                              "Save Filter",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.10,
                                    width: size.width * 0.30,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        this.widget.getFilters();
                                        deleteFilter();
                                      },
                                      color: Theme.of(context).primaryColor,
                                      child: Text(
                                        "Delete Filter",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> dropdownButtonStyle() {
    return DropdownButtonFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            //borderSide: BorderSide( width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).canvasColor),
            borderRadius: BorderRadius.circular(5),
          ),

          //fillColor: Colors.blueAccent,
        ),
        dropdownColor: Theme.of(context).canvasColor,
        value: dietType.text,
        onChanged: (String? value) {
          setState(() {
            dietType.text = value!;
          });
        },
        items: dropdownItems);
  }

  Row closingDialogButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close))
      ],
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Meatatarian (Eat meat)"), value: "Meatatarian"),
      DropdownMenuItem(child: Text("Vegetarian"), value: "Vegetarian"),
    ];
    return menuItems;
  }
}
