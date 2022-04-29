import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

ProductReviewModel productReviewModelFromJson(String str) =>
    ProductReviewModel.fromJson(json.decode(str));

String productReviewModelToJson(ProductReviewModel data) =>
    json.encode(data.toJson());

class ProductReviewModel {
  ProductReviewModel({
    this.clientName,
    this.comment,
    this.date,
    this.productName,
    this.ratings,
    this.uid,
  });

  String? clientName;
  String? comment;
  Timestamp? date;
  String? productName;
  String? ratings;
  String? uid;

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) =>
      ProductReviewModel(
        clientName: json['client name'],
        comment: json['comment'],
        date: json['date'],
        productName: json['product name'],
        ratings: json['ratings'].toString(),
        uid: json['uid'],
      );

  Map<String, dynamic> toJson() => {
        "client name": clientName,
        "comment": comment,
        "date": date,
        "product name": productName,
        "ratings": ratings,
        "uid": uid,
      };
}
