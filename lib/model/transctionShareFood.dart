import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionShareFoodModel {
  late final String shareFoodTransactionID;
  late final String memberBuyID;
  late final String memberSellID;
  late final String memberBuyName;
  late final String memberSellName;
  late final DateTime date;
  late final String shareFoodID;
  late final String status;
  late final String sharedFoodName;
  late final double price;

  TransactionShareFoodModel({
    required this.shareFoodTransactionID,
    required this.memberBuyID,
    required this.memberSellID,
    required this.date,
    required this.shareFoodID,
    required this.status,
    required this.sharedFoodName,
    required this.memberBuyName,
    required this.memberSellName,
    required this.price,
  });

  TransactionShareFoodModel.fromMap(DocumentSnapshot<Object?> data) {
    Timestamp firebaseTimestamp = data['date'];
    shareFoodTransactionID = data['shareFoodTransactionID'];
    memberBuyID = data['memberBuyID'];
    memberSellID = data['memberSellID'];
    date = firebaseTimestamp.toDate();
    shareFoodID = data['shareFoodID'];
    status = data['status'];
    memberBuyName = data['memberBuyName'];
    memberSellName = data['memberSellName'];
    price = double.parse(data['price'].toString());
    sharedFoodName = data['sharedFoodName'];
  }
}
