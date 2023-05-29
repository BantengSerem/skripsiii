import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  late final String shopID;
  late final String memberID;
  late final double rating;

  Rating({
    required this.shopID,
    required this.memberID,
    required this.rating,
  });

  Rating.fromMap(DocumentSnapshot<Object> data) {
    shopID = data['shopID'];
    memberID = data['memberID'];
    rating = data['rating'];
  }
}
