import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  late final int _qty;
  late final double _subPrice;
  late final String _foodID;
  late String _imgURL;
  late String _foodName;

  Cart({
    required int qty,
    required double subPrice,
    required String foodID,
  }) : _qty = qty,
        _subPrice = subPrice,
        _foodID = foodID;

  Cart.fromMap(DocumentSnapshot<Object> data){
    _qty = data['qty'];
    _subPrice = data['subPrice'];
    _foodID = data['foodID'];
  }
  Cart.fromMapData(Map<String, dynamic> data) {
    _qty = data['qty'];
    _subPrice = data['subPrice'];
    _foodID = data['foodID'];
  }

  String get foodName => _foodName;

  set foodName(String value) {
    _foodName = value;
  }

  String get imgURL => _imgURL;

  set imgURL(String value) {
    _imgURL = value;
  }

  String get foodID => _foodID;

  set foodID(String value) {
    _foodID = value;
  }

  double get subPrice => _subPrice;

  set subPrice(double value) {
    _subPrice = value;
  }

  int get qty => _qty;

  set qty(int value) {
    _qty = value;
  }
}
