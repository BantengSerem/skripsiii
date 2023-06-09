import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  late final String sharedFoodID;
  late final String sharedFoodName;
  late final String sharedFoodImageURL;
  late final String detailNotes;
  late final double price;

  Food({
    required this.sharedFoodID,
    required this.sharedFoodName,
    required this.sharedFoodImageURL,
    required this.detailNotes,
    required this.price,
  });

  Food.fromMap(DocumentSnapshot<Object?> data) {
    sharedFoodID = data['foodID'];
    sharedFoodName = data['foodName'];
    sharedFoodImageURL = data['foodImageURL'];
    detailNotes = data['detailNotes'];
    price = data['price'];
  }
}
