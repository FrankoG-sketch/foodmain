import 'dart:convert';

AllFoodsModel allFoodsModelFromJson(String str) =>
    AllFoodsModel.fromJson(json.decode(str));

String allFoodsModelToJson(AllFoodsModel data) => json.encode(data.toJson());

class AllFoodsModel {
  AllFoodsModel({
    this.img,
    this.name,
    this.price,
    this.rating,
  });

  String? img;
  String? name;
  String? price;
  String? rating;

  factory AllFoodsModel.fromJson(Map<String, dynamic> json) => AllFoodsModel(
        img: json["img"],
        name: json["name"],
        price: json["price"],
        rating: json["rating"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "name": name,
        "price": price,
        "rating": rating,
      };
}
