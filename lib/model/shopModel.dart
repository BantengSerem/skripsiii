import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skripsiii/model/userModel.dart';

enum SellingTime {
  M30,
  M15,
  M60,
  M45,
}

class Shop extends User {
  // @override
  // late final String email;
  // @override
  // late final String password;
  late final String shopID;
  late final String shopName;
  late final String contacts;
  late final double ratingAVG;
  late final DateTime closingTime;
  late final SellingTime sellingTime;

  Shop({
    required String password,
    required String email,
    required this.shopName,
    required this.contacts,
    required this.closingTime,
    required this.ratingAVG,
    required this.sellingTime,
    required this.shopID,
  });

  Shop.fromMap(DocumentSnapshot<Object> data) {
    email = data['email'];
    password = data['password'];
    shopID = data['memberID'];
    shopName = data['shopName'];
    contacts = data['contacts'];
    ratingAVG = data['ratingAVG'];
    closingTime = data['closingTime'];
    sellingTime = data['sellingTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'email' : email,
      'password' : password,
      'shopName' : shopName,
    };
  }
}
