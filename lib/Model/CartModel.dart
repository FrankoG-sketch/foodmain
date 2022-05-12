import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.date,
    this.quantity,
    this.img,
    this.productName,
    this.price,
    this.uid,
    this.userName,
    this.supermarket,
  });

  Timestamp? date;
  String? quantity;
  String? img;
  String? productName;
  String? price;
  String? uid;
  String? userName;
  String? supermarket;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        date: json['date'] ?? json['Date'],
        quantity: json['quantity'] ?? json['Quantity'],
        img: json['img'],
        productName: json['name'],
        price: json['price'],
        uid: json['uid'],
        userName: json['userName'],
        supermarket: json['supermarket'],
      );

  Map<String, dynamic> toJson() => {
        "Date": date,
        "Quantity": quantity,
        "img": img,
        "name": productName,
        "price": price,
        "uid": uid,
        "userName": userName,
        "supermarket": supermarket,
      };
}
