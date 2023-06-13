import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:skripsiii/model/addressModel.dart';
import 'package:skripsiii/model/cart.dart';
import 'package:skripsiii/model/foodModel.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/model/transactionModel.dart';

class MemberController extends GetxController {
  late Rx<Member> member = Member.blank().obs;
  final Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  final fireStoreInstance = FirebaseFirestore.instance;

  void reset() {
    member = Member.blank().obs;
  }

  Future<void> enableService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  Future<void> grantPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      debugPrint('permission is denied forever');
    }
  }

  Future<void> getLocation() async {
    _locationData = await location.getLocation();
  }

  Future<bool> checkShopInCart(
      {required String memberID, required String shopID}) async {
    var res = await fireStoreInstance
        .collection('cart')
        .where('memberID', isEqualTo: memberID)
        .where('shopID', isEqualTo: shopID)
        .get();

    return res.docs.isNotEmpty;
  }

  Future<bool> checkMemberCart({required String memberID}) async {
    var res = await fireStoreInstance
        .collection('cart')
        .where('memberID', isEqualTo: memberID)
        // .collection('cartList')
        // .collection('cartList')
        .get();

    return res.docs.isEmpty;

    // return res.data() == null;
  }

  Future<void> addMemberShopToCart(
      {required String memberID, required String shopID}) async {
    var res = await fireStoreInstance.collection('cart').doc(memberID).set({
      'memberID': memberID,
      'shopID': shopID,
    });
  }

  Future<bool> checkFoodCart({required Map<String, dynamic> data}) async {
    var res = await fireStoreInstance
        .collection('cart')
        .doc(data['memberID'])
        // .collection('cartList')
        // .doc(data['shopID'])
        .collection('foodList')
        .where('foodID', isEqualTo: data['foodID'])
        .get();

    return res.docs.isNotEmpty;
  }

  Future<bool> addDataToCart({required Map<String, dynamic> data}) async {
    var res = await fireStoreInstance
        .collection('cart')
        .doc(data['memberID'])
        // .collection('cartList')
        // .doc(data['shopID'])
        .collection('foodList')
        .doc(data['foodID'])
        .set({
      'foodID': data['foodID'],
      'qty': data['qty'],
      'subPrice': data['subPrice'],
    });

    return false;
  }

  Future<bool> updateDataToCart({required Map<String, dynamic> data}) async {
    var res = await fireStoreInstance
        .collection('cart')
        .doc(data['memberID'])
        // .collection('cartList')
        // .doc(data['shopID'])
        .collection('foodList')
        .doc(data['foodID'])
        .update({
      'foodID': data['foodID'],
      'qty': data['qty'],
      'subPrice': data['subPrice'],
    });

    return false;
  }

  Future<String> getCartListShopID(String memberID) async {
    var res = await fireStoreInstance
        .collection('cart')
        .where('memberID', isEqualTo: memberID)
        .limit(1)
        .get();
    return res.docs[0].data()['shopID'];
  }

  Future<List<Cart>> getMemberCartList({required String memberID}) async {
    var res = await fireStoreInstance
        .collection('cart')
        .doc(memberID)
        .collection('foodList')
        .get();
    List<Cart> l = [];
    res.docs.asMap().forEach((key, value) {
      var cart = Cart.fromMap(value);
      l.add(cart);
    });

    return l;
  }

  Future<void> removeCartItem(
      {required Cart cart, required String memberID}) async {
    await fireStoreInstance
        .collection('cart')
        .doc(memberID)
        .collection('foodList')
        .doc(cart.foodID)
        .delete();
  }

  Future<void> deleteCart({required String memberID}) async {
    await fireStoreInstance.collection('cart').doc(memberID).delete();
  }

  Future<void> test({required Map<String, dynamic> data}) async {
    var res = await fireStoreInstance
        .collection('cart')
        .where('memberID', isEqualTo: data['memberID'])
        .where('shopID', isEqualTo: data['shopID'])
        .get()
        .then((result) {
      result.docs.asMap().forEach((key, value) {
        // print(value.data()['foodList']);
        print(value.data());
      });
      // result.docs.indexOf(data['list']);
    });
  }

  Future<void> createTransction(TransactionModel t) async {
    await fireStoreInstance.collection('transaction').doc(t.transactionID).set({
      'transactionID': t.transactionID,
      'memberID': t.memberID,
      'shopID': t.shopID,
      'date': t.date,
      'foodList': t.foodList,
      'status': t.status,
    });
  }

  Future<Address> getMemberAddress(String memberID) async {
    var res = await fireStoreInstance
        .collection('address')
        .where('userID', isEqualTo: memberID)
        .get();

    res.docs.asMap().forEach((key, value) {
      print(value.data());
    });
    // print(res.docs[0].data());
    return Address.fromMap(res.docs[0]);
  }
}
