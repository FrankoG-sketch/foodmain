import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Model/CartModel.dart';
import 'package:shop_app/Model/order_status.dart';

import '../Model/supermarketModel.dart';

class FirebaseService {
  FirebaseService._inst();
  static final FirebaseService _instance = FirebaseService._inst();

  static FirebaseService get instance => _instance;
  CollectionReference<OrdersStatusModel> get deliveryModelStatus =>
      FirebaseFirestore.instance.collection("Delivery").withConverter(
          fromFirestore: (snapshot, _) =>
              OrdersStatusModel.fromJson(snapshot.data()!),
          toFirestore: (OrdersStatusModel model, _) => model.toJson());
  CollectionReference<CartModel> get orderModelStatus =>
      FirebaseFirestore.instance.collection("Orders").withConverter(
          fromFirestore: (snapshot, _) => CartModel.fromJson(snapshot.data()!),
          toFirestore: (CartModel model, _) => model.toJson());
  CollectionReference<SuperMarketModel> get storeData =>
      FirebaseFirestore.instance.collection("Supermarket").withConverter(
          fromFirestore: (snapshot, _) =>
              SuperMarketModel.fromJson(snapshot.data()!),
          toFirestore: (SuperMarketModel model, _) => model.toJson());
}
