import 'dart:convert';

ClientUserModel clientUserModelFromJson(String str) =>
    ClientUserModel.fromJson(json.decode(str));

String clientUserModelToJson(ClientUserModel data) =>
    json.encode(data.toJson());

class ClientUserModel {
  ClientUserModel(
      {this.uid,
      this.email,
      this.fullName,
      this.address,
      this.date,
      this.imgUrl,
      this.path,
      this.role});
  String? uid;
  String? email;
  String? fullName;
  String? address;
  String? imgUrl;
  String? path;
  String? role;
  String? date;

  factory ClientUserModel.fromJson(Map<String, dynamic> map) => ClientUserModel(
        uid: map['uid'] == null ? null : map['uid'],
        email: map['email'] == null ? null : map['email'],
        fullName: map['FullName'] == null ? null : map['FullName'],
        address: map['address'] == null ? null : map['address'],
        date: map['date'].toString() == null ? null : map['date'].toString(),
        imgUrl: map['imgUrl'] == null ? null : map['imgUrl'],
        path: map['path'] == null ? null : map['path'],
        role: map['role'] == null ? null : map['role'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'address': address,
        'date': date,
        'imgUrl': imgUrl,
        'path': path,
        'role': role,
      };
}
