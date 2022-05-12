import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

OrdersStatusModel ordersStatusModelFromJson(String str) =>
    OrdersStatusModel.fromJson(json.decode(json.decode(str)));

String ordersStatusModelToJson(OrdersStatusModel data) =>
    json.encode(data.toJson());

class OrdersStatusModel {
  OrdersStatusModel({
    required this.clientName,
    required this.deliveryProgress,
    this.taskCompleted,
    required this.address,
    required this.date,
    required this.directions,
    required this.productsInfor,
    required this.selectedPersonal,
    required this.uid,
  });

  String clientName;
  String deliveryProgress;
  bool? taskCompleted;
  String address;
  Timestamp date;
  String directions;
  List productsInfor;
  String selectedPersonal;
  String uid;

  factory OrdersStatusModel.fromJson(Map<String, dynamic> json) =>
      OrdersStatusModel(
          clientName: json['Client name'],
          deliveryProgress: json['Delivery Progress'],
          taskCompleted: json['Task Completed'],
          address: json['address'],
          date: json['date'],
          directions: json['directions'],
          productsInfor: json['products infor'],
          selectedPersonal: json['selected personal'].toString(),
          uid: json['uid']);

  Map<String, dynamic> toJson() => {
        "Client name": clientName,
        "Delivery Progress": deliveryProgress,
        "Task Completed": taskCompleted,
        "address": address,
        "date": date,
        "directions": directions,
        "products infor": productsInfor,
        "selectedPersonal": selectedPersonal,
        "uid": uid,
      };
}
