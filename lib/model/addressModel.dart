import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  late final String addressID;
  late final String userID;
  late final String address;
  late final String province;
  late final String city;
  late final String poscode;
  late final double latitude;
  late final double longitude;

  Address({
    required this.addressID,
    required this.userID,
    required this.address,
    required this.province,
    required this.city,
    required this.poscode,
    required this.latitude,
    required this.longitude,
  });
  Address.fromMap(DocumentSnapshot data){
    addressID= data['addressID'];
    userID= data['userID'];
    address= data['address'];
    province= data['province'];
    city= data['city'];
    poscode= data['postalCode'];
    latitude= data['latitude'];
    longitude= data['longitude'];
  }
  @override
  String toString() {
    return 'Address{addressID: $addressID, userID: $userID, address: $address, '
        'province: $province, city: $city, poscode: $poscode, '
        'latitude: $latitude, longitude: $longitude}';
  }
}