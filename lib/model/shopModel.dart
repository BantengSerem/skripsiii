import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skripsiii/model/userModel.dart';

class Shop extends UserParent {
  // @override
  // late final String email;
  // @override
  // late final String password;
  late String _shopID;
  late String _shopName;
  late String _contacts;
  late double _ratingAVG;
  late int _closingTime;
  late int _sellingTime;
  late String _isOpen;
  late int _totalReview;
  late double _distance;

  Shop.blank({
    String password = '',
    String email = '',
    String shopName = '',
    String contacts = '',
    // DateTime? closingTime,
    int closingTime = 0,
    double ratingAVG = 0.0,
    // DateTime? sellingTime,
    int sellingTime = 0,
    String shopID = '',
    String isOpen = '',
    int totalReview = 0,
  }) :
        // closingTime = closingTime ?? DateTime.now(),
        // sellingTime = sellingTime ?? DateTime.now(),
        super(email: email, password: password);

  Shop({
    required String password,
    required String email,
    required String shopName,
    required String contacts,
    required int closingTime,
    required double ratingAVG,
    required int sellingTime,
    required String shopID,
    required String isOpen,
    required int totalReview,
  }) : _shopName = shopName,
        _contacts = contacts,
        _closingTime = closingTime,
        _ratingAVG = ratingAVG,
        _sellingTime = sellingTime,
        _shopID = shopID,
        _isOpen = isOpen,
        _totalReview = totalReview,
        super(email: email, password: password);

  Shop.fromMap(DocumentSnapshot<Object?> data)
      : super(email: data['email']! ?? '', password: data['password']! ?? '') {
    _shopID = data['shopID'] ?? '';
    _shopName = data['name'] ?? '';
    _contacts = data['contacts'] ?? '';
    _ratingAVG = double.parse(data['ratingAVG'].toString());
    _closingTime = data['closingTime'] ?? 0;
    _sellingTime = data['sellingTime'] ?? 0;
    _isOpen = data['isOpen'] ?? '';
    _totalReview = data['totalReview'];
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
      'shopID': _shopID,
      'shopName': _shopName,
      'contacts': _contacts,
      'ratingAVG': _ratingAVG,
      'closingTime': _closingTime,
      'sellingTime': _sellingTime,
      'isOpen': _isOpen,
      'distance': _distance,
      'totalReview': _totalReview,
    };
  }

  Map<String, dynamic> essentialMap() {
    return {
      'email': email,
      'password': password,
      'shopID': _shopID,
    };
  }

  double get distance => _distance;

  set distance(double value) {
    _distance = value;
  }

  int get totalReview => _totalReview;

  set totalReview(int value) {
    _totalReview = value;
  }

  String get isOpen => _isOpen;

  set isOpen(String value) {
    _isOpen = value;
  }

  int get sellingTime => _sellingTime;

  set sellingTime(int value) {
    _sellingTime = value;
  }

  int get closingTime => _closingTime;

  set closingTime(int value) {
    _closingTime = value;
  }

  double get ratingAVG => _ratingAVG;

  set ratingAVG(double value) {
    _ratingAVG = value;
  }

  String get contacts => _contacts;

  set contacts(String value) {
    _contacts = value;
  }

  String get shopName => _shopName;

  set shopName(String value) {
    _shopName = value;
  }

  String get shopID => _shopID;

  set shopID(String value) {
    _shopID = value;
  }
}
