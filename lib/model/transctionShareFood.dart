import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionShareFoodModel {
  late final String _shareFoodTransactionID;
  late final String _memberBuyID;
  late final String _memberSellID;
  late final String _memberBuyName;
  late final String _memberSellName;
  late final DateTime _date;
  late final String _shareFoodID;
  late final String _status;
  late final String _sharedFoodName;
  late final double _price;

  TransactionShareFoodModel({
    required String shareFoodTransactionID,
    required String memberBuyID,
    required String memberSellID,
    required DateTime date,
    required String shareFoodID,
    required String status,
    required String sharedFoodName,
    required String memberBuyName,
    required String memberSellName,
    required double price,
  }) : _shareFoodTransactionID = shareFoodTransactionID,
        _memberBuyID = memberBuyID,
        _memberSellID = memberSellID,
        _date = date,
        _shareFoodID = shareFoodID,
        _status = status,
        _sharedFoodName = sharedFoodName,
        _memberBuyName = memberBuyName,
        _memberSellName = memberSellName,
        _price = price;

  TransactionShareFoodModel.fromMap(DocumentSnapshot<Object?> data) {
    Timestamp firebaseTimestamp = data['date'];
    _shareFoodTransactionID = data['shareFoodTransactionID'];
    _memberBuyID = data['memberBuyID'];
    _memberSellID = data['memberSellID'];
    _date = firebaseTimestamp.toDate();
    _shareFoodID = data['shareFoodID'];
    _status = data['status'];
    _memberBuyName = data['memberBuyName'];
    _memberSellName = data['memberSellName'];
    _price = double.parse(data['price'].toString());
    _sharedFoodName = data['sharedFoodName'];
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get sharedFoodName => _sharedFoodName;

  set sharedFoodName(String value) {
    _sharedFoodName = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get shareFoodID => _shareFoodID;

  set shareFoodID(String value) {
    _shareFoodID = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get memberSellName => _memberSellName;

  set memberSellName(String value) {
    _memberSellName = value;
  }

  String get memberBuyName => _memberBuyName;

  set memberBuyName(String value) {
    _memberBuyName = value;
  }

  String get memberSellID => _memberSellID;

  set memberSellID(String value) {
    _memberSellID = value;
  }

  String get memberBuyID => _memberBuyID;

  set memberBuyID(String value) {
    _memberBuyID = value;
  }

  String get shareFoodTransactionID => _shareFoodTransactionID;

  set shareFoodTransactionID(String value) {
    _shareFoodTransactionID = value;
  }
}
