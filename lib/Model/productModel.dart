import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.imgPath,
    this.name,
    this.price,
  });

  String imgPath;
  String name;
  String price;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        imgPath: json["img"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "img": imgPath,
        "name": name,
        "price": price,
      };
}
