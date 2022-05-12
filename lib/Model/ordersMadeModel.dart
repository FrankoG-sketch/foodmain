import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

OrdersMadeModel ordersMadeModelFromJson(String str) =>
    OrdersMadeModel.fromJson(json.decode(str));

String ordersMadeModelToJson(OrdersMadeModel data) =>
    json.encode(data.toJson());

class OrdersMadeModel {
  OrdersMadeModel({
    required this.img,
    required this.clientName,
    required this.uid,
    required this.price,
    required this.date,
    required this.quantity,
    required this.productName,
    required this.supermarket,
  });

  String img;
  String clientName;
  String uid;
  double price;
  Timestamp date;
  int quantity;
  String productName;
  String supermarket;

  OrdersMadeModel copyWith({
    required String img,
    required String clientName,
    required String uid,
    required double price,
    required String date,
    required int quantity,
    required String productName,
    required String supermarket,
  }) =>
      OrdersMadeModel(
        img: this.img,
        clientName: this.clientName,
        uid: this.uid,
        price: this.price,
        date: this.date,
        quantity: this.quantity,
        productName: this.productName,
        supermarket: this.supermarket,
      );

  factory OrdersMadeModel.fromJson(Map<String, dynamic> json) =>
      OrdersMadeModel(
        img: json["imageUrl"],
        clientName: json["client name"],
        uid: json["uid"],
        price: double.parse(json["price"]),
        date: json["date"],
        quantity: int.parse(json["quantity"]),
        productName: json["product name"],
        supermarket: json["supermarket"],
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": img,
        "client name": clientName,
        "uid": uid,
        "price": price.toStringAsFixed(2),
        "date": date,
        "quantity": quantity.toString(),
        "product name": productName,
        "supermarket": supermarket,
      };
}
