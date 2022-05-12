import 'package:flutter/material.dart';

class OrdersChartData {
  final String deliveryStatus;
  final double percentage;
  final Color color;

  OrdersChartData(this.deliveryStatus, this.percentage, this.color);
}

class SalesChartData {
  String storeName;
  late double total;
  Color color;
  SalesChartData(this.storeName, List<double> numbers, this.color) {
    total = 0;
    numbers.forEach((element) {
      total += element;
    });
  }
}
