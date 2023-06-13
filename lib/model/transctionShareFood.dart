import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionShareFoodModel {
  late final String shareFoodTransactionID;
  late final String memberBuyID;
  late final String memberSellID;
  late final DateTime date;
  late final String shareFoodID;
  late final String status;

  TransactionShareFoodModel({
    required this.shareFoodTransactionID,
    required this.memberBuyID,
    required this.memberSellID,
    required this.date,
    required this.shareFoodID,
    required this.status,
  });

  TransactionShareFoodModel.fromMap(DocumentSnapshot<Object?> data) {
    shareFoodTransactionID = data['shareFoodTransactionID'];
    memberBuyID = data['memberBuyID'];
    memberSellID = data['memberSellID'];
    date = data['date'];
    shareFoodID = data['shareFoodID'];
    status = data['status'];
  }
}
