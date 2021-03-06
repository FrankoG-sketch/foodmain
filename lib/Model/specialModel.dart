import 'dart:convert';

SpecialModel specialModelFromJson(String str) =>
    SpecialModel.fromJson(json.decode(str));

String specialModelToJson(SpecialModel data) => json.encode(data.toJson());

class SpecialModel {
  SpecialModel({
    this.imgPath,
    this.name,
    this.price,
    this.memo,
    this.rating,
  });

  String? imgPath;
  String? name;
  String? price;
  String? memo;
  String? rating;

  factory SpecialModel.fromJson(Map<String, dynamic> json) => SpecialModel(
        imgPath: json["img"],
        name: json["name"],
        price: json["price"],
        memo: json["memo"],
        rating: json["rating"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "img": imgPath,
        "name": name,
        "price": price,
        "memo": memo,
        "rating": rating
      };
}
