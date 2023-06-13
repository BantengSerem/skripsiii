import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skripsiii/model/foodModel.dart';

class Cart {
  late final int qty;
  late final double subPrice;
  late final String foodID;

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
}
