import 'package:cloud_firestore/cloud_firestore.dart';

class SharedFood {
  late final String sharedFoodID;
  late final String sharedFoodName;
  late final String sharedFoodImageURL;
  late final String detailNotes;
  late final String memberID;
  late final double price;

  SharedFood({
    required this.sharedFoodID,
    required this.sharedFoodName,
    required this.sharedFoodImageURL,
    required this.detailNotes,
    required this.price,
    required this.memberID,
  });

  SharedFood.fromMap(DocumentSnapshot<Object?> data) {
    sharedFoodID = data['sharedFoodID'];
    sharedFoodName = data['sharedFoodName'];
    sharedFoodImageURL = data['sharedFoodImageURL'];
    detailNotes = data['detailNotes'];
    memberID = data['memberID'];
    price = data['price'];
  }

  Map<String, dynamic> toMap() {
    return {
      'sharedFoodID': sharedFoodID,
      'memberID': memberID,
      'sharedFoodName': sharedFoodName,
      'sharedFoodImageURL': sharedFoodImageURL,
      'detailNotes': detailNotes,
      'price': price,
    };
  }
}
