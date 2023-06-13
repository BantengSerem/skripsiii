import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/model/addressModel.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ShopController extends GetxController {
  late Rx<Shop> shop = Shop.blank().obs;
  final fireStoreInstance = FirebaseFirestore.instance;
  final RxList<Shop> sellSoonList = RxList<Shop>();
  final RxList<Shop> sellNowList = RxList<Shop>();
  final RxList<Shop> browseSoonList = RxList<Shop>();
  final RxList<Shop> browseNowList = RxList<Shop>();
  StreamSubscription<QuerySnapshot>? sellNowListSnapshot;
  StreamSubscription<QuerySnapshot>? sellSoonListSnapshot;
  List<StreamSubscription<QuerySnapshot>> streamListNow = [];
  List<StreamSubscription<QuerySnapshot>> streamListSoon = [];

  bool firstTimeSoon = true;
  bool firstTimeNow = true;
  late DocumentSnapshot? currDocSoon;
  late DocumentSnapshot? currDocNow;

  // final MemberController memberController = Get.find();

  void reset() {
    shop = Shop.blank().obs;
    sellNowList.clear();
    sellSoonList.clear();
    browseNowList.clear();
    browseSoonList.clear();
    if (sellNowListSnapshot != null) sellNowListSnapshot?.cancel();
    if (sellSoonListSnapshot != null) sellSoonListSnapshot?.cancel();
  }

  void cleanBrowseSoon() {
    for (var element in streamListSoon) {
      element.cancel();
    }
    streamListSoon.clear();
    browseSoonList.clear();
    currDocSoon = null;
    firstTimeSoon = true;
    // print('finish cleaning ');
  }

  void cleanBrowseNow() {
    for (var element in streamListNow) {
      element.cancel();
    }
    streamListNow.clear();
    browseNowList.clear();
    currDocNow = null;
    firstTimeNow = true;
    // print('finish cleaning ');
  }

  Future<void> init(Member member) async {
    await getSellSoon(member);
    await getSellNow(member);
    print('finished init');
  }

  Future<Address> getShopLoc(Shop shop) async {
    var res = await fireStoreInstance
        .collection('address')
        .where('userID', isEqualTo: shop.shopID)
        // .where('userID', isEqualTo: 'O5vObIuWE9WwotA2gwkcVuXhW5z1')
        .limit(1)
        .get();

    // res.docs.asMap().forEach((key, value) {
    //   print(value.data());
    // });
    final List addresses = res.docs.map((doc) => Address.fromMap(doc)).toList();

    return addresses[0];
    // print(res.);
    // Address address = Address
  }

  Future<void> getSellNow(Member member) async {
    // print('call getSellSoon');
    var a = DateFormat('HHmmss').format(DateTime.now());
    var b = int.parse(a);
    var snapshot = fireStoreInstance
        .collection('shop')
        .where('sellingTime', isLessThanOrEqualTo: b)
        .where('sellingTime', isNotEqualTo: -1)
        .where('isOpen', isEqualTo: 'true')
        .limit(5)
        .orderBy('sellingTime')
        .snapshots()
        .listen((event) {
      // print(event.docChanges.asMap());
      event.docChanges.asMap().forEach((key, value) async {
        switch (value.type) {
          case DocumentChangeType.added:
            var shop = Shop.fromJson(value.doc.data());
            var sl = await getShopLoc(shop);
            var distance = calculateDistance(
              lat1: sl.latitude,
              lon1: sl.longitude,
              lat2: member.latitude,
              lon2: member.longitude,
            );
            shop.distance = double.parse(distance.toStringAsFixed(2));
            // print('added item $shop');
            sellNowList.add(shop);
            break;
          case DocumentChangeType.modified:
            var shop = Shop.fromJson(value.doc.data());
            int i = sellNowList
                .indexWhere((element) => element.shopID == shop.shopID);

            var sl = await getShopLoc(shop);
            var distance = calculateDistance(
              lat1: sl.latitude,
              lon1: sl.longitude,
              lat2: member.latitude,
              lon2: member.longitude,
            );
            shop.distance = double.parse(distance.toStringAsFixed(2));
            // print('update item $shop');
            sellNowList[i] = shop;
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            // print('delete item ${Shop.fromJson(value.doc.data())}');
            sellNowList.removeWhere((element) =>
                element.shopID == Shop.fromJson(value.doc.data()).shopID);
            break;
        }
      });
    });

    sellNowListSnapshot = snapshot;
  }

  Future<void> getSellSoon(Member member) async {
    // print('call getSellSoon');
    var a = DateFormat('HHmmss').format(DateTime.now());
    var b = int.parse(a);
    var snapshot = fireStoreInstance
        .collection('shop')
        .where('sellingTime', isGreaterThan: b)
        .where('sellingTime', isNotEqualTo: -1)
        // .where('isOpen', isEqualTo: 'true')
        .limit(5)
        // .orderBy('sellingTime')
        .snapshots()
        .listen((event) {
      // print(event.docChanges.asMap());
      event.docChanges.asMap().forEach((key, value) async {
        switch (value.type) {
          case DocumentChangeType.added:
            var shop = Shop.fromJson(value.doc.data());
            var sl = await getShopLoc(shop);
            var distance = calculateDistance(
              lat1: sl.latitude,
              lon1: sl.longitude,
              lat2: member.latitude,
              lon2: member.longitude,
            );
            shop.distance = double.parse(distance.toStringAsFixed(2));
            // print('added item $shop');
            sellSoonList.add(shop);
            break;
          case DocumentChangeType.modified:
            var shop = Shop.fromJson(value.doc.data());
            int i = sellSoonList
                .indexWhere((element) => element.shopID == shop.shopID);

            var sl = await getShopLoc(shop);
            var distance = calculateDistance(
              lat1: sl.latitude,
              lon1: sl.longitude,
              lat2: member.latitude,
              lon2: member.longitude,
            );
            shop.distance = double.parse(distance.toStringAsFixed(2));
            // print('update item $shop');
            sellSoonList[i] = shop;
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            // print('delete item ${Shop.fromJson(value.doc.data())}');
            sellSoonList.removeWhere((element) =>
                element.shopID == Shop.fromJson(value.doc.data()).shopID);
            break;
        }
      });
    });

    sellSoonListSnapshot = snapshot;
  }

  void deleteStreamNow() {
    if(streamListNow.isNotEmpty){
      streamListNow.last.cancel();
      streamListNow.removeLast();
      getLastDocSnapshotsNow();
    }
    // print('streamList : ${streamListNow}');
  }

  void deleteStreamSoon() {
    if(streamListSoon.isNotEmpty){
      streamListSoon.last.cancel();
      streamListSoon.removeLast();
      getLastDocSnapshotsSoon();
    }
    // print('streamList : ${streamListSoon}');
  }

  void getLastDocSnapshotsNow() async {
    var query = fireStoreInstance
        .collection('shop')
        .doc(browseNowList.last.shopID.toString());
    currDocNow = await query.get();
  }

  void getLastDocSnapshotsSoon() async {
    var query = fireStoreInstance
        .collection('shop')
        .doc(browseSoonList.last.shopID.toString());
    currDocSoon = await query.get();
  }

  Future<void> getBrowseSoon(Member member) async {
    // print('getBrowseSoon');
    Query? query;
    var a = DateFormat('HHmmss').format(DateTime.now());
    var b = int.parse(a);
    if (firstTimeSoon) {
      query = fireStoreInstance
          .collection('shop')
          .where('sellingTime', isGreaterThan: b)
          .where('sellingTime', isNotEqualTo: -1)
          .orderBy('sellingTime', descending: false)
          .limit(10);

      firstTimeSoon = false;
    } else if (currDocSoon != null) {
      query = fireStoreInstance
          .collection('shop')
          .where('sellingTime', isGreaterThan: b)
          .where('sellingTime', isNotEqualTo: -1)
          .orderBy('sellingTime', descending: false)
          .limit(10)
          .startAfterDocument(currDocSoon!);
    }

    if (query != null) {
      var index = streamListSoon.length + 1;

      var snapshot = query.snapshots().listen((event) {
        if (event.size == 0) return deleteStreamSoon();

        // print(event.docChanges.asMap());
        event.docChanges.asMap().forEach((key, value) async {
          switch (value.type) {
            case DocumentChangeType.added:
              var shop = Shop.fromMap(value.doc);

              browseSoonList
                  .removeWhere((element) => element.shopID == shop.shopID);
              var sl = await getShopLoc(shop);
              var distance = calculateDistance(
                lat1: sl.latitude,
                lon1: sl.longitude,
                lat2: member.latitude,
                lon2: member.longitude,
              );
              shop.distance = double.parse(distance.toStringAsFixed(2));
              // print('added item $shop');
              browseSoonList.add(shop);
              break;
            case DocumentChangeType.modified:
              var shop = Shop.fromMap(value.doc);
              int i = browseSoonList
                  .indexWhere((element) => element.shopID == shop.shopID);

              var sl = await getShopLoc(shop);
              var distance = calculateDistance(
                lat1: sl.latitude,
                lon1: sl.longitude,
                lat2: member.latitude,
                lon2: member.longitude,
              );
              shop.distance = double.parse(distance.toStringAsFixed(2));
              // print('update item $shop');
              browseSoonList[i] = shop;
              break;
            case DocumentChangeType.removed:
              // if (removeData == false) removeData = true;
              // print('delete item ${Shop.fromMap(value.doc)}');
              browseSoonList.removeWhere((element) =>
                  element.shopID == Shop.fromMap(value.doc).shopID);
              break;
          }
        });

        browseSoonList.sort((a, b) => a.sellingTime.compareTo(b.sellingTime));

        if (index == streamListSoon.length && event.size == 10) {
          currDocSoon = event.docs.last;
        } else if (index == streamListSoon.length && event.size < 10) {
          currDocSoon = null;
        }
      });
      streamListSoon.add(snapshot);
    } else {
      // print("can't retrieve data, already max or no currDoc");
    }
  }

  Future<void> getBrowseNow(Member member) async {
    late Query? query;
    var a = DateFormat('HHmmss').format(DateTime.now());
    var b = int.parse(a);
    if (firstTimeNow) {
      query = fireStoreInstance
          .collection('shop')
          .where('sellingTime', isLessThanOrEqualTo: b)
          .where('sellingTime', isNotEqualTo: -1)
          .where('isOpen', isEqualTo: 'true')
          .orderBy('sellingTime')
          .limit(10);
      firstTimeNow = false;
    } else if (currDocNow != null) {
      query = fireStoreInstance
          .collection('shop')
          .where('sellingTime', isLessThanOrEqualTo: b)
          .where('sellingTime', isNotEqualTo: -1)
          .where('isOpen', isEqualTo: 'true')
          .orderBy('sellingTime')
          .limit(10)
          .startAfterDocument(currDocNow!);
    }

    if (query != null) {
      var index = streamListNow.length + 1;

      var snapshot = query.snapshots().listen((event) {
        if (event.size == 0) return deleteStreamNow();

        // print(event.docChanges.asMap());
        event.docChanges.asMap().forEach((key, value) async {
          switch (value.type) {
            case DocumentChangeType.added:
              var shop = Shop.fromMap(value.doc);
              browseSoonList
                  .removeWhere((element) => element.shopID == shop.shopID);
              var sl = await getShopLoc(shop);
              var distance = calculateDistance(
                lat1: sl.latitude,
                lon1: sl.longitude,
                lat2: member.latitude,
                lon2: member.longitude,
              );
              shop.distance = double.parse(distance.toStringAsFixed(2));
              // print('added item $shop');
              browseNowList.add(shop);
              break;
            case DocumentChangeType.modified:
              var shop = Shop.fromMap(value.doc);
              int i = browseNowList
                  .indexWhere((element) => element.shopID == shop.shopID);
              var sl = await getShopLoc(shop);
              var distance = calculateDistance(
                lat1: sl.latitude,
                lon1: sl.longitude,
                lat2: member.latitude,
                lon2: member.longitude,
              );
              shop.distance = double.parse(distance.toStringAsFixed(2));
              // print('update item $shop');
              browseNowList[i] = shop;
              break;
            case DocumentChangeType.removed:
              // if (removeData == false) removeData = true;
              // print('delete item ${Shop.fromMap(value.doc)}');
              browseNowList.removeWhere((element) =>
                  element.shopID == Shop.fromMap(value.doc).shopID);
              break;
          }
        });
        // browseSoonList.sort((a, b) => a.sellingTime.compareTo(b.sellingTime));

        if (index == streamListNow.length && event.size == 10) {
          currDocNow = event.docs.last;
        } else if (index == streamListNow.length && event.size < 10) {
          currDocNow = null;
        }
      });
      streamListNow.add(snapshot);
    }
  }

  Future<void> test() async {
    // calculateDistance();
    // var a = DateFormat('HHmmss').format(DateTime.now());
    // var b = int.parse(a);
    // b = 223300;
    //
    // var m = '2300';
    // var h = m.substring(0, 2);
    // var h1 = m.substring(2);
    // var h2 = "$h'.'$h1";

    var a = DateFormat('HHmmss').format(DateTime.now());
    var b = int.parse(a);
    b = 223000;
    var res = await fireStoreInstance
        .collection('shop')
        .where('time'[0], isGreaterThan: b)
        .where('time'[1], isLessThanOrEqualTo: b)
        // .where('sellingTime', isNotEqualTo: -1)
        // .where('isOpen', isEqualTo: 'true')
        // .limit(5)
        // .orderBy('sellingTime')
        // .where('closingTime', isGreaterThanOrEqualTo: b)
        .get();

    print(res.docs.asMap());
    res.docs.asMap().forEach((key, value) {
      print(value.data());
    });

    // var res = await fireStoreInstance
    //     .collection('address')
    //     .where('userID', isEqualTo: 'O5vObIuWE9WwotA2gwkcVuXhW5z1')
    //     .limit(1)
    //     .get();
    //
    // // res.docs.asMap().forEach((key, value) {
    // //   print(value.data());
    // // });
    // final List addresses = res.docs.map((doc) => Address.fromMap(doc)).toList();
    //
    // print(addresses);
    // return addresses.first;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSuggestedRestaurant(
      String query) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return await fireStoreInstance
        .collection('shop')
        .where('name', isGreaterThanOrEqualTo: query)
        // .where('sellingTime', isLessThanOrEqualTo: DateTime.now())
        // .orderBy('sellingTime', descending: true)
        .limit(10)
        .get();
  }

  double calculateDistance(
      {required double lat1,
      required double lon1,
      required double lat2,
      required double lon2}) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    // Convert latitude and longitude from degrees to radians
    // final double latRad1 = degreesToRadians(lat1);
    // final double lonRad1 = degreesToRadians(lon1);
    // final double latRad2 = degreesToRadians(lat2);
    // final double lonRad2 = degreesToRadians(lon2);
    //
    // // Calculate the differences between the coordinates
    // final double dLat = latRad2 - latRad1;
    // final double dLon = lonRad2 - lonRad1;
    //
    // // Apply the Haversine formula
    // final double a = pow(sin(dLat / 2), 2) +
    //     cos(latRad1) * cos(latRad2) * pow(sin(dLon / 2), 2);
    // final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    // final double distance = earthRadius * c;

    final double latDifference = (lat2 - lat1).abs() *
        0.01745329252; // Convert latitude difference to radians
    final double lonDifference = (lon2 - lon1).abs() *
        0.01745329252; // Convert longitude difference to radians

    final double a = sin(latDifference / 2) * sin(latDifference / 2) +
        cos(lat1 * 0.01745329252) *
            cos(lat2 * 0.01745329252) *
            sin(lonDifference / 2) *
            sin(lonDifference / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * 3.14 / 180;
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
