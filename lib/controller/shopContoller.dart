import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:intl/intl.dart';

class ShopController extends GetxController {
  late Rx<Shop> shop = Shop.blank().obs;
  final fireStoreInstance = FirebaseFirestore.instance;
  final RxList<Shop> sellSoonList = RxList<Shop>();
  final RxList<Shop> sellNowList = RxList<Shop>();
  final RxList<Shop> browseSoonList = RxList<Shop>();
  final RxList<Shop> browseNowList = RxList<Shop>();
  late StreamSubscription<QuerySnapshot> sellNowListSnapshot;

  void reset() {
    shop = Shop.blank().obs;
    sellNowList.clear();
    sellSoonList.clear();
    browseNowList.clear();
    browseSoonList.clear();
    if (sellNowListSnapshot != null) sellNowListSnapshot.cancel();
  }

  Future<void> init() async {
    getSellSoon();
    getSellNow();
  }

  Future<void> getSellNow() async {
    print('call getSellSoon');
    var a = DateFormat('HHmmss').format(DateTime.now());
    var b = int.parse(a);
    var snapshot = fireStoreInstance
        .collection('shop')
        .where('sellingTime', isLessThanOrEqualTo: b)
        .where('isOpen', isEqualTo: 'open')
        .limit(5)
        .orderBy('sellingTime')
        .snapshots()
        .listen((event) {
      print(event.docChanges.asMap());
      event.docChanges.asMap().forEach((key, value) {
        switch (value.type) {
          case DocumentChangeType.added:
            sellNowList.add(Shop.fromJson(value.doc.data()));
            break;
          case DocumentChangeType.modified:
            int i = sellNowList.indexWhere((element) =>
                element.shopID == Shop.fromJson(value.doc.data()).shopID);
            sellNowList[i] = Shop.fromJson(value.doc.data());
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            sellNowList.removeWhere((element) =>
                element.shopID == Shop.fromJson(value.doc.data()).shopID);
            break;
        }
      });
    });

    sellNowListSnapshot = snapshot;
  }

  Future<void> getSellSoon() async {
    print('call getSellSoon');
    var a = DateFormat('HHmmss').format(DateTime.now());
    var b = int.parse(a);
    var snapshot = fireStoreInstance
        .collection('shop')
        .where('sellingTime', isGreaterThan: b)
        .limit(5)
        .orderBy('sellingTime')
        .snapshots()
        .listen((event) {
      print(event.docChanges.asMap());
      event.docChanges.asMap().forEach((key, value) {
        switch (value.type) {
          case DocumentChangeType.added:
            sellSoonList.add(Shop.fromJson(value.doc.data()));
            break;
          case DocumentChangeType.modified:
            int i = sellSoonList.indexWhere((element) =>
                element.shopID == Shop.fromJson(value.doc.data()).shopID);
            sellSoonList[i] = Shop.fromJson(value.doc.data());
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            sellSoonList.removeWhere((element) =>
                element.shopID == Shop.fromJson(value.doc.data()).shopID);
            break;
        }
      });
    });

    sellNowListSnapshot = snapshot;
  }

  Future<void> test() async {
    var a = DateFormat('HHmmss').format(DateTime.now());
    var b = int.parse(a);
    b = 223300;

    var m = '2300';
    var h = m.substring(0, 2);
    var h1 = m.substring(2);
    var h2 = "$h'.'$h1";

    var res = await fireStoreInstance
        .collection('shop')
        .where('sellingTime', isLessThanOrEqualTo: b)
        .where('isOpen', isEqualTo: 'open')
        // .where('closingTime', isGreaterThanOrEqualTo: b)
        .get();

    // await FirebaseFirestore.instance
    //     .collection('shop')
    //     .where('openingHours', arrayContains: {
    //   'startTime':
    //       '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}',
    //   'endTime':
    //       '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}',
    // }).get();
    res.docs.asMap().forEach((key, value) {
      print(value.data());
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSuggestedRestaurant(
      String query) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return await fireStoreInstance
        .collection('shop')
        .where('shopName', isGreaterThanOrEqualTo: query)
        // .where('sellingTime', isLessThanOrEqualTo: DateTime.now())
        // .orderBy('sellingTime', descending: true)
        .limit(10)
        .get();
  }

// On progress, don't change
  Map<String, double> getLatLongRange({double radius = 1}) {
    // double latRange = radius / 6371.0 * (180 / pi);
    // double lonRange =
    //     radius / (6371.0 * cos(latitude * pi / 180)) * (180 / pi);
    return {};
  }

  Map<String, double> getLatLongFilter({
    double latRange = 0.009,
    double lonRange = 0.014,
    required double latitude,
    required double longitude,
  }) {
    double minLat = latitude - latRange;
    double maxLat = latitude + latRange;
    double minLon = longitude - lonRange;
    double maxLon = longitude + lonRange;

    return {
      'minLat': minLat,
      'maxLat': maxLat,
      'minLon': minLon,
      'maxLon': maxLon,
    };
  }
}
