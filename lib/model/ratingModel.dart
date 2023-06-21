import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  late final String _ratingID;
  late final String _shopID;
  late final String _memberID;
  late final int _rating;

  Rating({
    required String ratingID,
    required String shopID,
    required String memberID,
    required int rating,
  }) : _ratingID = ratingID,
        _shopID = shopID,
        _memberID = memberID,
        _rating = rating;

  Rating.fromMap(DocumentSnapshot<Object> data) {
    _ratingID = data['ratingID'];
    _shopID = data['shopID'];
    _memberID = data['memberID'];
    _rating = data['rating'];
  }

  int get rating => _rating;

  set rating(int value) {
    _rating = value;
  }

  String get memberID => _memberID;

  set memberID(String value) {
    _memberID = value;
  }

  String get shopID => _shopID;

  set shopID(String value) {
    _shopID = value;
  }

  String get ratingID => _ratingID;

  set ratingID(String value) {
    _ratingID = value;
  }
}
