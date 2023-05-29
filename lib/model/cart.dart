import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  late final String cartID;
  late final double totalPrice;
  late final List<Map<String, dynamic>> foodList;

  Cart({
    required this.cartID,
    required this.totalPrice,
    required this.foodList,
  });

  Cart.fromMap(DocumentSnapshot<Object> data){
    cartID = data['cartID'];
    totalPrice = data['totalPrice'];
    foodList = data['foodList'];
  }
}
