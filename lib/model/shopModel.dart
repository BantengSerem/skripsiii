import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skripsiii/model/userModel.dart';

enum SellingTime {
  m30,
  m15,
  m60,
  m45,
}

class Shop extends UserParent {
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

  Shop.blank({
    String password = '',
    String email = '',
    this.shopName = '',
    this.contacts = '',
    DateTime? closingTime,
    this.ratingAVG = 0.0,
    this.sellingTime = SellingTime.m15,
    this.shopID = '',
  })  : closingTime = closingTime ?? DateTime.now(),
        super(email: email, password: password);

  Shop({
    required String password,
    required String email,
    required this.shopName,
    required this.contacts,
    required this.closingTime,
    required this.ratingAVG,
    required this.sellingTime,
    required this.shopID,
  }) : super(email: email, password: password);

  // factory Shop.fromMap(DocumentSnapshot<Object> data) {
  //   email = data['email']!;
  //   password = data['password'] ?? '';
  //   shopID = data['shopID'] ?? '';
  //   shopName = data['shopName'] ?? '';
  //   contacts = data['contacts'] ?? '';
  //   ratingAVG = data['ratingAVG'] ?? 0.0;
  //   closingTime = data['closingTime'] ?? DateTime;
  //   sellingTime = data['sellingTime'] ?? SellingTime.m30;
  // }

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        email: json['email'],
        password: json['password'] ?? '',
        shopID: json['shopID'] ?? '',
        shopName: json['shopName'] ?? '',
        contacts: json['contacts'] ?? '',
        ratingAVG: json['ratingAVG'] ?? 0.0,
        closingTime: json['closingTime'] ?? DateTime.now(),
        sellingTime: json['sellingTime'] ?? SellingTime.m30,
      );

  @override
  String toString() {
    return 'Shop: { email: $email, password: $password, shopID: $shopID, shopName: $shopName, contacts: $contacts, ratingAVG: $ratingAVG, closingTime: $closingTime, sellingTime: $sellingTime }';
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'shopName': shopName,
    };
  }
}
