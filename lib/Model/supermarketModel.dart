import 'dart:convert';

SuperMarketModel superMarketModel(String str) =>
    SuperMarketModel.fromJson(json.decode(str));

String superMarketModelToJson(SuperMarketModel data) =>
    json.encode(data.toJson());

class SuperMarketModel {
  SuperMarketModel({
    this.displayName,
    this.storeId,
  });

  String? displayName;
  String? storeId;

  factory SuperMarketModel.fromJson(Map<String, dynamic> json) =>
      SuperMarketModel(
        displayName: json['displayName'],
        storeId: json['storeId'],
      );

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "storeId": storeId,
      };
}
