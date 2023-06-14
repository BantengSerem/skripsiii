import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  late final String transactionID;
  late final String memberID;
  late final String shopID;
  late final DateTime date;
  late final List<dynamic> foodList;
  late final String status;
  late final double totalPrice;
  late final String memberName;
  late final String shopName;


  TransactionModel({
    required this.transactionID,
    required this.memberID,
    required this.shopID,
    required this.date,
    required this.foodList,
    required this.status,
    required this.memberName,
    required this.totalPrice,
    required this.shopName,
  });

  TransactionModel.fromMap(DocumentSnapshot<Object?> data) {
    Timestamp firebaseTimestamp = data['date'];
    transactionID = data['transactionID'];
    memberID = data['memberID'];
    shopID = data['shopID'];
    date = firebaseTimestamp.toDate();
    foodList = data['foodList'];
    status = data['status'];
    memberName = data['memberName'];
    totalPrice = data['totalPrice'];
    shopName = data['shopName'];
  }
}
