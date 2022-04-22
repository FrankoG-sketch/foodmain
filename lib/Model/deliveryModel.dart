import 'dart:convert';

DeliveryMenModel deliveryMenModelFromJson(String str) =>
    DeliveryMenModel.fromJson(json.decode(str));

String deliveryMenModelToJson(DeliveryMenModel data) =>
    json.encode(data.toJson());

class DeliveryMenModel {
  DeliveryMenModel({
    this.fullName,
    this.address,
    this.email,
    this.imgUrl,
    this.path,
    this.role,
    this.ratings,
  });

  String? fullName;
  String? address;
  String? email;
  String? imgUrl;
  String? path;
  String? role;
  String? ratings;

  factory DeliveryMenModel.fromJson(Map<String, dynamic> json) =>
      DeliveryMenModel(
        fullName: json["FullName"],
        address: json["address"],
        email: json["email"],
        imgUrl: json["imgUrl"],
        path: json["path"],
        role: json["role"],
        ratings: json["ratings"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "FullName": fullName,
        "address": address,
        "email": email,
        "imgUrl": imgUrl,
        "path": path,
        "role": role,
        "ratings": ratings,
      };
}
