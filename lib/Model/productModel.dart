import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.imgPath,
    this.name,
    this.price,
    this.rating,
  });

  String? imgPath;
  String? name;
  String? price;
  String? rating;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      imgPath: json["img"],
      name: json["name"],
      price: json["price"],
      rating: json["rating"].toString());

  Map<String, dynamic> toJson() =>
      {"img": imgPath, "name": name, "price": price, "rating": rating};
}
