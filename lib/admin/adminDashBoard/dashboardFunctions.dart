import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Model/custom_chart_data.dart';
import 'package:shop_app/Model/order_status.dart';
import 'package:shop_app/utils/magic_strings.dart';

class DashBoardFunctions {
  Function refresh;

  DashBoardFunctions(this.refresh) {
    getData();
  }

  getData() {
    FirebaseFirestore.instance
        .collection('Reserved Appointments')
        .snapshots()
        .first
        .then((value) => print(value.docs.first.data()));
  }

  static OrdersChartData getOrderDataList(String filter,
          List<QueryDocumentSnapshot<OrdersStatusModel>> docs, Color color) =>
      OrdersChartData(
          filter,
          docs
                  .where((element) => element.data().deliveryProgress == filter)
                  .length /
              docs.length,
          color);

  static List<OrdersChartData> orderChartDataList(
          AsyncSnapshot<QuerySnapshot<OrdersStatusModel>> snapshot) =>
      [
        DashBoardFunctions.getOrderDataList(
            OrderStatus.Shipped, snapshot.data!.docs, Colors.orange),
        DashBoardFunctions.getOrderDataList(
            OrderStatus.Arrived, snapshot.data!.docs, Colors.green),
        DashBoardFunctions.getOrderDataList(
            OrderStatus.pending, snapshot.data!.docs, Colors.red),
      ];
  static bool dateMatch(Timestamp d, [bool isDay = false]) {
    DateTime docDate = d.toDate();
    DateTime date = DateTime.now();
    return isDay
        ? date.month == docDate.month &&
            date.year == docDate.year &&
            date.day == docDate.day
        : date.month == docDate.month && date.year == docDate.year;
  }
}
