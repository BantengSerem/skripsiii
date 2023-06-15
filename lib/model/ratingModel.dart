import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  late final String ratingID;
  late final String shopID;
  late final String memberID;
  late final int rating;

  Rating({
    required this.ratingID,
    required this.shopID,
    required this.memberID,
    required this.rating,
  });

  Rating.fromMap(DocumentSnapshot<Object> data) {
    ratingID = data['ratingID'];
    shopID = data['shopID'];
    memberID = data['memberID'];
    rating = data['rating'];
  }
}
