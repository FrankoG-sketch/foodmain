import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/firebase_services.dart';
import 'package:shop_app/Model/custom_chart_data.dart';
import 'package:shop_app/Model/order_status.dart';
import 'package:shop_app/admin/adminDashBoard/dashboardFunctions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrderThumbnail extends StatelessWidget {
  const OrderThumbnail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<OrdersStatusModel>>(
      stream: FirebaseService.instance.deliveryModelStatus.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No Data Available"),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Material(
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SfCircularChart(
                      borderWidth: 2,
                      title: ChartTitle(
                          text: "Deliveries",
                          textStyle: TextStyle(fontWeight: FontWeight.w700)),
                      legend: Legend(
                        borderColor: Colors.grey,
                        borderWidth: 2,
                        isVisible: true,
                        position: LegendPosition.bottom,
                      ),
                      series: <CircularSeries>[
                        PieSeries<OrdersChartData, String>(
                            dataSource:
                                DashBoardFunctions.orderChartDataList(snapshot),
                            dataLabelMapper: (OrdersChartData data, _) =>
                                "${(data.percentage * 100).toStringAsFixed(2)}%",
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                            ),
                            pointColorMapper: (OrdersChartData data, _) =>
                                data.color,
                            xValueMapper: (OrdersChartData data, _) =>
                                data.deliveryStatus,
                            yValueMapper: (OrdersChartData data, _) =>
                                data.percentage)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
