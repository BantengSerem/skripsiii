import 'package:cloud_firestore/cloud_firestore.dart';

class SharedFood {
  late final String _sharedFoodID;
  late final String _sharedFoodName;
  late final String _sharedFoodImageURL;
  late final String _detailNotes;
  late final String _memberID;
  late final double _price;
  late final String _status;
  late final DateTime _date;
  late final String _memberName;
  late double _distance;

  SharedFood({
    required String sharedFoodID,
    required String sharedFoodName,
    required String sharedFoodImageURL,
    required String detailNotes,
    required double price,
    required String memberID,
    required String status,
    required DateTime date,
    required String memberName,
  }) : _sharedFoodID = sharedFoodID,
        _sharedFoodName = sharedFoodName,
        _sharedFoodImageURL = sharedFoodImageURL,
        _detailNotes = detailNotes,
        _price = price,
        _memberID = memberID,
        _status = status,
        _date = date,
        _memberName = memberName;

  SharedFood.fromMap(DocumentSnapshot<Object?> data) {
    Timestamp firebaseTimestamp = data['date'];
    _sharedFoodID = data['sharedFoodID'];
    _sharedFoodName = data['sharedFoodName'];
    _sharedFoodImageURL = data['sharedFoodImageURL'];
    _detailNotes = data['detailNotes'];
    _memberID = data['memberID'];
    _price = data['price'];
    _status = data['status'];
    _date = firebaseTimestamp.toDate();
    _memberName = data['memberName'];
  }

  Map<String, dynamic> toMap() {
    return {
      'sharedFoodID': _sharedFoodID,
      'memberID': _memberID,
      'sharedFoodName': _sharedFoodName,
      'sharedFoodImageURL': _sharedFoodImageURL,
      'detailNotes': _detailNotes,
      'price': _price,
      'status': _status,
      'date': _date,
      'memberName': _memberName,
    };
  }

  double get distance => _distance;

  set distance(double value) {
    _distance = value;
  }

  String get memberName => _memberName;

  set memberName(String value) {
    _memberName = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get memberID => _memberID;

  set memberID(String value) {
    _memberID = value;
  }

  String get detailNotes => _detailNotes;

  set detailNotes(String value) {
    _detailNotes = value;
  }

  String get sharedFoodImageURL => _sharedFoodImageURL;

  set sharedFoodImageURL(String value) {
    _sharedFoodImageURL = value;
  }

  String get sharedFoodName => _sharedFoodName;

  set sharedFoodName(String value) {
    _sharedFoodName = value;
  }

  String get sharedFoodID => _sharedFoodID;

  set sharedFoodID(String value) {
    _sharedFoodID = value;
  }
}
