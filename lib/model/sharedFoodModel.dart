import 'package:cloud_firestore/cloud_firestore.dart';

class SharedFood {
  late final String sharedFoodID;
  late final String sharedFoodName;
  late final String sharedFoodImageURL;
  late final String detailNotes;
  late final String memberID;
  late final double price;
  late final String status;
  late final DateTime date;
  late final String memberName;
  late double distance;

  SharedFood({
    required this.sharedFoodID,
    required this.sharedFoodName,
    required this.sharedFoodImageURL,
    required this.detailNotes,
    required this.price,
    required this.memberID,
    required this.status,
    required this.date,
    required this.memberName,
  });

  SharedFood.fromMap(DocumentSnapshot<Object?> data) {
    Timestamp firebaseTimestamp = data['date'];
    sharedFoodID = data['sharedFoodID'];
    sharedFoodName = data['sharedFoodName'];
    sharedFoodImageURL = data['sharedFoodImageURL'];
    detailNotes = data['detailNotes'];
    memberID = data['memberID'];
    price = data['price'];
    status = data['status'];
    date = firebaseTimestamp.toDate();
    memberName = data['memberName'];
  }

  Map<String, dynamic> toMap() {
    return {
      'sharedFoodID': sharedFoodID,
      'memberID': memberID,
      'sharedFoodName': sharedFoodName,
      'sharedFoodImageURL': sharedFoodImageURL,
      'detailNotes': detailNotes,
      'price': price,
      'status': status,
      'date': date,
      'memberName': memberName,
    };
  }
}
