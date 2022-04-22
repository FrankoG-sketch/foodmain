import 'dart:convert';

AllFoodsModel allFoodsModelFromJson(String str) =>
    AllFoodsModel.fromJson(json.decode(str));

String allFoodsModelToJson(AllFoodsModel data) => json.encode(data.toJson());

class AllFoodsModel {
  AllFoodsModel({
    this.img,
    this.name,
    this.price,
  });

  String? img;
  String? name;
  String? price;

  factory AllFoodsModel.fromJson(Map<String, dynamic> json) => AllFoodsModel(
        img: json["img"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "name": name,
        "price": price,
      };
}
