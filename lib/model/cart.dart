import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  late final int qty;
  late final double subPrice;
  late final String foodID;
  late String imgURL;
  late String foodName;

  Cart({
    required this.qty,
    required this.subPrice,
    required this.foodID,
  });

  Cart.fromMap(DocumentSnapshot<Object> data){
    qty = data['qty'];
    subPrice = data['subPrice'];
    foodID = data['foodID'];
  }
  Cart.fromMapData(Map<String, dynamic> data) {
    qty = data['qty'];
    subPrice = data['subPrice'];
    foodID = data['foodID'];
  }
}
