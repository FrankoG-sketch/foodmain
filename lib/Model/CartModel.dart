import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.date,
    this.quantity,
    this.img,
    this.productName,
    this.price,
    this.uid,
    this.userName,
  });

  String? date;
  String? quantity;
  String? img;
  String? productName;
  String? price;
  String? uid;
  String? userName;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        date: json['Date'].toString(),
        quantity: json['Quantity'],
        img: json['img'],
        productName: json['name'],
        price: json['price'],
        uid: json['uid'],
        userName: json['userName'],
      );

  Map<String, dynamic> toJson() => {
        "Date": date,
        "Quantity": quantity,
        "img": img,
        "name": productName,
        "price": price,
        "uid": uid,
        "userName": userName
      };
}
