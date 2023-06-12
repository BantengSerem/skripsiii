import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  late final String foodID;
  late final String foodName;
  late final String foodImageURL;
  late final String detailNotes;
  late final double price;
  late final String shopID;
  late final int qty;

  Food({
    required this.foodID,
    required this.foodName,
    required this.foodImageURL,
    required this.detailNotes,
    required this.price,
    required this.qty,
    required this.shopID,
  });

  Food.fromMap(DocumentSnapshot<Object?> data) {
    foodID = data['foodID'];
    foodName = data['foodName'];
    foodImageURL = data['foodImageURL'];
    detailNotes = data['detailNotes'];
    price = data['price'];
    qty = data['qty'];
    shopID = data['shopID'];
  }

  Map<String, dynamic> toMap() {
    return {
      'foodID': foodID,
      'foodName': foodName,
      'foodImageURL': foodImageURL,
      'detailNotes': detailNotes,
      'price': price,
      'qty': qty,
      'shopID': shopID,
    };
  }
}
