import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserDeliveryModel userDeliveryModelFromJson(String str) =>
    UserDeliveryModel.fromJson(json.decode(str));

String userDeliveryModelToJson(UserDeliveryModel data) =>
    json.encode(data.toJson());

class UserDeliveryModel {
  UserDeliveryModel({
    this.clientName,
    this.deliveryProgress,
    this.taskCompleted,
    this.address,
    this.dateCancelled,
    this.dateMade,
    this.directions,
    this.productsInfo,
    this.selectedPersonal,
    this.uid,
    this.refunded,
    this.compoundKey,
  });

  String? clientName;
  String? deliveryProgress;
  String? taskCompleted;
  String? address;
  Timestamp? dateCancelled;
  Timestamp? dateMade;
  String? directions;
  List? productsInfo;
  String? selectedPersonal;
  String? uid;
  String? refunded;
  String? compoundKey;

  factory UserDeliveryModel.fromJson(Map<String, dynamic> json) =>
      UserDeliveryModel(
        clientName: json['Client name'],
        deliveryProgress: json['Delivery Progress'],
        taskCompleted: json['Task Completed'].toString(),
        address: json['address'],
        dateCancelled: json['date'],
        dateMade: json['date made'],
        directions: json['directions'],
        productsInfo: json['products infor'],
        selectedPersonal: json['selected personal'],
        uid: json['uid'],
        refunded: json['refunded'].toString(),
        compoundKey: json['compoundKey'],
      );

  Map<String, dynamic> toJson() => {
        "Client name": clientName,
        "Delivery Progress": deliveryProgress,
        "Task Completed": taskCompleted,
        "address": address,
        "date": dateCancelled,
        "date made": dateMade,
        "directions": directions,
        "productsInfo": productsInfo,
        "selectedPersonal": selectedPersonal,
        "uid": uid,
        "refunded": refunded,
        "compoundKey": compoundKey,
      };
}
