// To parse this JSON data, do
//
//     final InventoryModel = InventoryModelFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

InventoryModel InventoryModelFromJson(String str) =>
    InventoryModel.fromJson(json.decode(str));

String InventoryModelToJson(InventoryModel data) => json.encode(data.toJson());

class InventoryModel {
  InventoryModel({
    required this.img,
    required this.userName,
    required this.uid,
    required this.price,
    required this.date,
    required this.quantity,
    required this.name,
  });

  String img;
  String userName;
  String uid;
  double price;
  Timestamp date;
  int quantity;
  String name;

  InventoryModel copyWith({
    required String img,
    required String userName,
    required String uid,
    required double price,
    required String date,
    required int quantity,
    required String name,
  }) =>
      InventoryModel(
        img: this.img,
        userName: this.userName,
        uid: this.uid,
        price: this.price,
        date: this.date,
        quantity: this.quantity,
        name: this.name,
      );

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
        img: json["img"],
        userName: json["userName"],
        uid: json["uid"],
        price: double.parse(json["price"]),
        date: json["Date"],
        quantity: int.parse(json["Quantity"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "userName": userName,
        "uid": uid,
        "price": price.toStringAsFixed(2),
        "Date": date,
        "Quantity": quantity.toString(),
        "name": name,
      };
}
