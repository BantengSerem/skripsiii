import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skripsiii/model/userModel.dart';

class Shop extends UserParent {
  // @override
  // late final String email;
  // @override
  // late final String password;
  late String shopID;
  late String shopName;
  late String contacts;
  late double ratingAVG;
  late int closingTime;
  late int sellingTime;
  late String isOpen;
  late int totalReview;
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
    this.totalReview = 0,
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
    required this.totalReview,
  }) : super(email: email, password: password);

  Shop.fromMap(DocumentSnapshot<Object?> data)
      : super(email: data['email']! ?? '', password: data['password']! ?? '') {
    shopID = data['shopID'] ?? '';
    shopName = data['name'] ?? '';
    contacts = data['contacts'] ?? '';
    ratingAVG = double.parse(data['ratingAVG'].toString());
    closingTime = data['closingTime'] ?? 0;
    sellingTime = data['sellingTime'] ?? 0;
    isOpen = data['isOpen'] ?? '';
    totalReview = data['totalReview'];
  }

  factory Shop.fromJson(Map<String, dynamic>? json) => Shop(
        email: json!['email'] ?? '',
        password: json['password'] ?? '',
        shopID: json['shopID'] ?? '',
        shopName: json['name'] ?? '',
        contacts: json['contacts'] ?? '',
        ratingAVG: double.parse(json['ratingAVG'].toString()),
        closingTime: json['closingTime'] ?? 0,
        sellingTime: json['sellingTime'] ?? 0,
        isOpen: json['isOpen'] ?? '',
        totalReview: json['totalReview'] ?? 0,
      );

  @override
  String toString() {
    return 'Shop: { email: $email, password: $password, shopID: $shopID, shopName: $shopName, contacts: $contacts, ratingAVG: $ratingAVG, closingTime: $closingTime, sellingTime: $sellingTime, isOpen: $isOpen, totalReview: $totalReview }';
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
      'totalReview': totalReview,
    };
  }

  Map<String, dynamic> essentialMap() {
    return {
      'email': email,
      'password': password,
      'shopID': shopID,
    };
  }
}
