import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  late final String _transactionID;
  late final String _memberID;
  late final String _shopID;
  late final DateTime _date;
  late final List<dynamic> _foodList;
  late final String _status;
  late final double _totalPrice;
  late final String _memberName;
  late final String _shopName;


  TransactionModel({
    required String transactionID,
    required String memberID,
    required String shopID,
    required DateTime date,
    required List<dynamic> foodList,
    required String status,
    required String memberName,
    required double totalPrice,
    required String shopName,
  }) : _transactionID = transactionID,
        _memberID = memberID,
        _shopID = shopID,
        _date = date,
        _foodList = foodList,
        _status = status,
        _memberName = memberName,
        _totalPrice = totalPrice,
        _shopName = shopName;

  TransactionModel.fromMap(DocumentSnapshot<Object?> data) {
    Timestamp firebaseTimestamp = data['date'];
    _memberID = data['memberID'];
    _shopID = data['shopID'];
    _date = firebaseTimestamp.toDate();
    _foodList = data['foodList'];
    _status = data['status'];
    _memberName = data['memberName'];
    _totalPrice = data['totalPrice'];
    _shopName = data['shopName'];
  }

  String get shopName => _shopName;

  set shopName(String value) {
    _shopName = value;
  }

  String get memberName => _memberName;

  set memberName(String value) {
    _memberName = value;
  }

  double get totalPrice => _totalPrice;

  set totalPrice(double value) {
    _totalPrice = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  List<dynamic> get foodList => _foodList;

  set foodList(List<dynamic> value) {
    _foodList = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get shopID => _shopID;

  set shopID(String value) {
    _shopID = value;
  }

  String get memberID => _memberID;

  set memberID(String value) {
    _memberID = value;
  }

  String get transactionID => _transactionID;

  set transactionID(String value) {
    _transactionID = value;
  }
}
