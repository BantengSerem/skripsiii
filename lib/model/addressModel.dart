import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  late final String _addressID;
  late final String _userID;
  late final String _address;
  late final String _province;
  late final String _city;
  late final String _poscode;
  late final double _latitude;
  late final double _longitude;

   Address({
    required String addressID,
    required String userID,
    required String address,
    required String province,
    required String city,
    required String poscode,
    required double latitude,
    required double longitude,
  })  : _addressID = addressID,
        _userID = userID,
        _address = address,
        _province = province,
        _city = city,
        _poscode = poscode,
        _latitude = latitude,
        _longitude = longitude;

  Address.fromMap(DocumentSnapshot data) {
    _addressID = data['addressID'];
    _userID = data['userID'];
    _address = data['address'];
    _province = data['province'];
    _city = data['city'];
    _poscode = data['postalCode'];
    _latitude = data['latitude'];
    _longitude = data['longitude'];
  }
  @override
  String toString() {
    return 'Address{addressID: $_addressID, userID: $_userID, address: $_address, '
        'province: $_province, city: $_city, poscode: $_poscode, '
        'latitude: $_latitude, longitude: $_longitude}';
  }

  String get addressID => _addressID;

  set addressID(String value) {
    _addressID = value;
  }

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get province => _province;

  set province(String value) {
    _province = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get poscode => _poscode;

  set poscode(String value) {
    _poscode = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }
}
