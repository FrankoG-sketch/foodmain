import 'dart:convert';

FoodFilterModel foodFilterModelFromJson(String str) =>
    FoodFilterModel.fromJson(json.decode(str));

String foodFilterModelToJson(FoodFilterModel data) =>
    json.encode(data.toJson());

class FoodFilterModel {
  FoodFilterModel({
    this.allergy,
    this.clientName,
    this.dietType,
    this.exercisePlan,
    this.specialDiet,
    this.uid,
  });

  String? allergy;
  String? clientName;
  String? dietType;
  String? exercisePlan;
  String? specialDiet;
  String? uid;

  factory FoodFilterModel.fromJson(Map<String, dynamic> json) =>
      FoodFilterModel(
        allergy: json["allergy"],
        clientName: json["clientName"],
        dietType: json["diet type"],
        exercisePlan: json["exercise plan"],
        specialDiet: json["special diet"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "allergy": allergy,
        "clientName": clientName,
        "diet type": dietType,
        "exercise plan": exercisePlan,
        "special diet": specialDiet,
        "uid": uid,
      };
}
