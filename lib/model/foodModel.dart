import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  late final String _foodID;
  late final String _foodName;
  late final String _foodImageURL;
  late final String _detailNotes;
  late final double _price;
  late final String _shopID;
  late final int _qty;

  Food({
    required String foodID,
    required String foodName,
    required String foodImageURL,
    required String detailNotes,
    required double price,
    required int qty,
    required String shopID,
  }) : _foodID = foodID,
        _foodName = foodName,
        _foodImageURL = foodImageURL,
        _detailNotes = detailNotes,
        _price = price,
        _qty = qty,
        _shopID = shopID;

  Food.fromMap(DocumentSnapshot<Object?> data) {
    _foodID = data['foodID'];
    _foodName = data['foodName'];
    _foodImageURL = data['foodImageURL'];
    _detailNotes = data['detailNotes'];
    _price = data['price'];
    _qty = data['qty'];
    _shopID = data['shopID'];
  }

  Map<String, dynamic> toMap() {
    return {
      'foodID': _foodID,
      'foodName': _foodName,
      'foodImageURL': _foodImageURL,
      'detailNotes': _detailNotes,
      'price': _price,
      'qty': _qty,
      'shopID': _shopID,
    };
  }

  int get qty => _qty;

  set qty(int value) {
    _qty = value;
  }

  String get shopID => _shopID;

  set shopID(String value) {
    _shopID = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get detailNotes => _detailNotes;

  set detailNotes(String value) {
    _detailNotes = value;
  }

  String get foodImageURL => _foodImageURL;

  set foodImageURL(String value) {
    _foodImageURL = value;
  }

  String get foodName => _foodName;

  set foodName(String value) {
    _foodName = value;
  }

  String get foodID => _foodID;

  set foodID(String value) {
    _foodID = value;
  }
}
