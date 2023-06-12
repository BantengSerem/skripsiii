import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skripsiii/model/userModel.dart';

class Shop extends UserParent {
  // @override
  // late final String email;
  // @override
  // late final String password;
  late final String shopID;
  late final String shopName;
  late final String contacts;
  late final double ratingAVG;
  late final int closingTime;
  late final int sellingTime;
  late final String isOpen;
  late double distance;

  Shop.blank({
    String password = '',
    String email = '',
    this.shopName = '',
    this.contacts = '',
    // DateTime? closingTime,
    this.closingTime = 0,
    this.ratingAVG = 0.0,
    // DateTime? sellingTime,
    this.sellingTime = 0,
    this.shopID = '',
    this.isOpen = '',
  }) :
        // closingTime = closingTime ?? DateTime.now(),
        // sellingTime = sellingTime ?? DateTime.now(),
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
    required this.isOpen,
  }) : super(email: email, password: password);

  Shop.fromMap(DocumentSnapshot<Object?> data)
      : super(email: data['email']! ?? '', password: data['password']! ?? '') {
    shopID = data['shopID'] ?? '';
    shopName = data['name'] ?? '';
    contacts = data['contacts'] ?? '';
    ratingAVG = double.parse(data['ratingAVG'].toString()) ?? 0.0;
    closingTime = data['closingTime'] ?? 0;
    sellingTime = data['sellingTime'] ?? 0;
    isOpen = data['isOpen'] ?? '';
  }

  factory Shop.fromJson(Map<String, dynamic>? json) => Shop(
        email: json!['email'] ?? '',
        password: json['password'] ?? '',
        shopID: json['shopID'] ?? '',
        shopName: json['name'] ?? '',
        contacts: json['contacts'] ?? '',
        ratingAVG: double.parse(json['ratingAVG'].toString()) ?? 0.0,
        closingTime: json['closingTime'] ?? 0,
        sellingTime: json['sellingTime'] ?? 0,
        isOpen: json['isOpen'] ?? '',
      );

  @override
  String toString() {
    return 'Shop: { email: $email, password: $password, shopID: $shopID, shopName: $shopName, contacts: $contacts, ratingAVG: $ratingAVG, closingTime: $closingTime, sellingTime: $sellingTime, isOpen: $isOpen }';
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'shopID': shopID,
      'shopName': shopName,
      'contacts': contacts,
      'ratingAVG': ratingAVG,
      'closingTime': closingTime,
      'sellingTime': sellingTime,
      'isOpen': isOpen,
      'distance': distance,
    };
  }
}
