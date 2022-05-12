import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/firebase_services.dart';
import 'package:shop_app/Model/CartModel.dart';
import 'package:shop_app/admin/adminDashBoard/dashboardFunctions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Model/custom_chart_data.dart';
import '../../Model/supermarketModel.dart';

class SalesThumbnail extends StatelessWidget {
  // final DashBoardFunctions handler;
  const SalesThumbnail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Material(
        //color: Theme.of(context).cardColor,
        elevation: 28,
        child: StreamBuilder<QuerySnapshot<SuperMarketModel>>(
            stream: FirebaseService.instance.storeData.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Container(
                child: StreamBuilder<QuerySnapshot<CartModel>>(
                  stream: FirebaseService.instance.orderModelStatus.snapshots(),
                  builder: (context, salesSnap) {
                    if (!salesSnap.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    List<SalesChartData> data = [],
                        monthData = [],
                        daySales = [];
                    for (var store in snapshot.data!.docs) {
                      data.add(SalesChartData(
                          store.data().displayName!,
                          salesSnap.data!.docs
                              .where((element) =>
                                  element.data().supermarket ==
                                  store.data().storeId)
                              .map<double>((e) =>
                                  double.parse(e.data().price!) *
                                  int.parse(e.data().quantity!))
                              .toList(),
                          Colors.greenAccent));
                      monthData.add(SalesChartData(
                          store.data().displayName!,
                          salesSnap.data!.docs
                              .where((element) =>
                                  element.data().supermarket ==
                                      store.data().storeId &&
                                  DashBoardFunctions.dateMatch(
                                      element.data().date!))
                              .map<double>((e) =>
                                  double.parse(e.data().price!) *
                                  int.parse(e.data().quantity!))
                              .toList(),
                          Colors.blue));

                      daySales.add(SalesChartData(
                          store.data().displayName!,
                          salesSnap.data!.docs
                              .where((element) =>
                                  element.data().supermarket ==
                                      store.data().storeId &&
                                  DashBoardFunctions.dateMatch(
                                      element.data().date!, true))
                              .map<double>((e) =>
                                  double.parse(e.data().price!) *
                                  int.parse(e.data().quantity!))
                              .toList(),
                          Colors.red));
                    }

                    return SfCartesianChart(
                        title: ChartTitle(text: 'Store Sales'),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(minimum: 0),
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          isResponsive: false,
                        ),
                        series: <ChartSeries<SalesChartData, String>>[
                          //   for (var store in snapshot.data!.docs)
                          BarSeries<SalesChartData, String>(
                              dataLabelSettings: DataLabelSettings(
                                  // Renders the data label
                                  isVisible: true),
                              dataSource: data,
                              xValueMapper: (SalesChartData data, _) =>
                                  data.storeName.replaceAll(' ', '\n'),
                              yValueMapper: (SalesChartData data, _) =>
                                  data.total,
                              name: 'Total Sales',
                              pointColorMapper: (SalesChartData data, _) =>
                                  data.color),

                          //   for (var store in snapshot.data!.docs)
                          BarSeries<SalesChartData, String>(
                              dataLabelSettings: DataLabelSettings(
                                  // Renders the data label
                                  isVisible: true),
                              dataSource: monthData,
                              xValueMapper: (SalesChartData data, _) =>
                                  data.storeName.replaceAll(' ', '\n'),
                              yValueMapper: (SalesChartData data, _) =>
                                  data.total,
                              name: 'Month Sales',
                              pointColorMapper: (SalesChartData data, _) =>
                                  data.color),
                          BarSeries<SalesChartData, String>(
                              dataLabelSettings: DataLabelSettings(
                                  // Renders the data label
                                  isVisible: true),
                              dataSource: daySales,
                              xValueMapper: (SalesChartData data, _) =>
                                  data.storeName.replaceAll(' ', '\n'),
                              yValueMapper: (SalesChartData data, _) =>
                                  data.total,
                              name: 'Daily Sales',
                              pointColorMapper: (SalesChartData data, _) =>
                                  data.color)
                        ]);
                  },
                ),
                // child: UsersOrders(handler, handler: null,),
              );
            }),
      ),
    );
  }
}

class UsersOrders extends StatelessWidget {
  final DashBoardFunctions handler;
  const UsersOrders(this.handler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
