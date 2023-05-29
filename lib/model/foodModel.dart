import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  late final String foodID;
  late final String foodName;
  late final String foodImageURL;
  late final String detailNotes;
  late final double price;
  late final int qty;

  Food({
    required this.foodID,
    required this.foodName,
    required this.foodImageURL,
    required this.detailNotes,
    required this.price,
    required this.qty,
  });

  Food.fromMap(DocumentSnapshot<Object> data) {
    foodID = data['foodID'];
    foodName = data['foodName'];
    foodImageURL = data['foodImageURL'];
    detailNotes = data['detailNotes'];
    price = data['price'];
    qty = data['qty'];
  }
}
