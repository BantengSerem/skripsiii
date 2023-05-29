import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  late final String transactionID;
  late final String memberID;
  late final String shopID;
  late final DateTime date;
  late final List<Map<String, dynamic>> foodList;

  Transaction({
    required this.transactionID,
    required this.memberID,
    required this.shopID,
    required this.date,
    required this.foodList,
  });

  Transaction.fromMap(DocumentSnapshot<Object> data){
   transactionID = data['transactionID'];
   memberID = data['memberID'];
   shopID = data['shopID'];
   date = data['date'];
   foodList = data['foodList'];
  }
}
