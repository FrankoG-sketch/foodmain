import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

ClientReviewModel clientReviewModelFromJson(String str) =>
    ClientReviewModel.fromJson(json.decode(str));

String clientReviewModelToJson(ClientReviewModel data) =>
    json.encode(data.toJson());

class ClientReviewModel {
  ClientReviewModel({
    this.clientName,
    this.comment,
    this.date,
    this.deliveryPersonnel,
    this.ratings,
    this.uid,
  });

  String? clientName;
  String? comment;
  Timestamp? date;
  String? deliveryPersonnel;
  String? ratings;
  String? uid;

  factory ClientReviewModel.fromJson(Map<String, dynamic> json) =>
      ClientReviewModel(
        clientName: json['client name'],
        comment: json['comment'],
        date: json['date'],
        deliveryPersonnel: json['delivery personnel'],
        ratings: json['ratings'].toString(),
        uid: json['uid'],
      );

  Map<String, dynamic> toJson() => {
        "client name": clientName,
        "comment": comment,
        "date": date,
        "delivery personnel": deliveryPersonnel,
        "ratings": ratings,
        "uid": uid,
      };
}
