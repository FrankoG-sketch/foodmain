import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Model/foodFilterModel.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';

class AdminFoodFiler extends StatelessWidget {
  const AdminFoodFiler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getCurrentUID(),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Food Filter")
                  .orderBy("clientName")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.data!.docs.isEmpty)
                  return Center(
                    child: Text("No Food Filters"),
                  );
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Food Filters"),
                    backgroundColor: Theme.of(context).primaryColor,
                    actions: [
                      IconButton(
                          onPressed: () => showSearch(
                              context: context,
                              delegate: AdminFoodFilerSearchDelegate(
                                  snapshot.data!.docs)),
                          icon: Icon(Icons.search))
                    ],
                  ),
                  body: Scrollbar(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot keyword = snapshot.data!.docs[index];

                        FoodFilterModel foodFilterModel =
                            FoodFilterModel.fromJson(
                                keyword.data()! as Map<String, dynamic>);
                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                isDismissible: false,
                                context: context,
                                builder: (builder) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.9,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: Icon(Icons.close))
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 35.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  size.width *
                                                                      0.80),
                                                      child: Text(
                                                          "Client Name: ${foodFilterModel.clientName!}"),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.05),
                                                Row(
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  size.width *
                                                                      0.80),
                                                      child: Text(
                                                          "Client Diet Type: ${foodFilterModel.dietType!}"),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.05),
                                                Row(
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  size.width *
                                                                      0.80),
                                                      child: Text(
                                                          "Client Allergy: ${foodFilterModel.allergy!}"),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.05),
                                                Row(
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  size.width *
                                                                      0.80),
                                                      child: Text(
                                                          "Client Special Diet: ${foodFilterModel.specialDiet!}"),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.05),
                                                Row(
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  size.width *
                                                                      0.80),
                                                      child: Text(
                                                          "Client Exercise Plan: ${foodFilterModel.exercisePlan!}"),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.05),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: SizedBox(
                            height: size.height * 0.10,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(foodFilterModel.clientName!),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      children: [
                                        Text(foodFilterModel.uid!),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              });
        });
  }
}

class AdminFoodFilerSearchDelegate extends SearchDelegate {
  final documents;

  AdminFoodFilerSearchDelegate(this.documents);

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: Icon(Icons.clear))
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Food Filter")
            .orderBy("clientName")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final results = snapshot.data!.docs.where((DocumentSnapshot a) =>
              a['clientName']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()));

          return ListView(
              children: results
                  .map<Widget>(
                    (a) => Card(
                      child: ListTile(
                        onTap: () => showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: false,
                            context: context,
                            builder: (builder) {
                              return FractionallySizedBox(
                                heightFactor: 0.9,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              icon: Icon(Icons.close))
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          size.width * 0.80),
                                                  child: Text(
                                                      "Client Name: ${a['clientName']}"),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: size.height * 0.05),
                                            Row(
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          size.width * 0.80),
                                                  child: Text(
                                                      "Client Diet Type: ${a['diet type']}"),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: size.height * 0.05),
                                            Row(
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          size.width * 0.80),
                                                  child: Text(
                                                      "Client Allergy: ${a['allergy']}"),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: size.height * 0.05),
                                            Row(
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          size.width * 0.80),
                                                  child: Text(
                                                      "Client Special Diet: ${a['special diet']}"),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: size.height * 0.05),
                                            Row(
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          size.width * 0.80),
                                                  child: Text(
                                                      "Client Exercise Plan: ${a['exercise plan']}"),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: size.height * 0.05),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),

                        title: Text(a['clientName'].toString()),
                        //  trailing: Text("${a['price']}"),
                      ),
                    ),
                  )
                  .toList());
        });
  }

  @override
  Widget buildResults(BuildContext context) => Center(child: Text(query));
}
