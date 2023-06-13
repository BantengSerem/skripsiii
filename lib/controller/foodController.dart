import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsiii/model/cart.dart';
import 'package:skripsiii/model/foodModel.dart';
import 'package:skripsiii/model/sharedFoodModel.dart';
import 'package:skripsiii/model/transctionShareFood.dart';

class FoodController extends GetxController {
  // List<StreamSubscription<QuerySnapshot>> streamList = [];
  List<StreamSubscription<QuerySnapshot>> streamFoodList = [];
  List<StreamSubscription<QuerySnapshot>> streamShareFoodList = [];
  List<StreamSubscription<QuerySnapshot>> streamMemberShareFoodList = [];

  // RxList<Food> listItem = RxList<Food>();
  RxList<Food> foodList = RxList<Food>();
  RxList<SharedFood> shareFoodList = RxList<SharedFood>();
  RxList<SharedFood> shareMemberFoodList = RxList<SharedFood>();

  final fireStoreInstance = FirebaseFirestore.instance;

  // late DocumentSnapshot? currDoc;
  late DocumentSnapshot? currDocFoodList;
  late DocumentSnapshot? currDocShareFoodList;
  late DocumentSnapshot? currDocMemberShareFoodList;

  // late DocumentSnapshot? currDoc = null;
  // bool firstTime = true;
  bool firstTimeFoodList = true;
  bool firstTimeShareFoodList = true;
  bool firstTimeMemberShareFoodList = true;


  void init() {}

  void reset() {
    shareFoodList.clear();
    currDocShareFoodList = null;
    firstTimeShareFoodList = true;
    for (var element in streamShareFoodList) {
      element.cancel();
    }
    streamShareFoodList.clear();

    shareMemberFoodList.clear();
    currDocMemberShareFoodList = null;
    firstTimeMemberShareFoodList = true;
    for (var element in streamMemberShareFoodList) {
      element.cancel();
    }
    streamMemberShareFoodList.clear();
    // listItem.clear();
    // currDoc = null;
    // firstTime = true;
    // for (var element in streamList) {
    //   element.cancel();
    // }
    // streamList.clear();
  }

  void cleanFoodData() {
    foodList.clear();
    currDocFoodList = null;
    firstTimeFoodList = true;
    for (var element in streamFoodList) {
      element.cancel();
    }
    streamFoodList.clear();
  }

  void refreshAllData() {
    // for (var element in streamList) {
    //   element.cancel();
    // }
    // streamList.clear();
    // print('streamList : ${streamList}');
    // listItem.clear();
    // currDoc = null;
    // firstTime = true;
  }

  Future<String?> imgFoodDataToStorage(Map<String, dynamic> data) async {
    // fireStoreInstance.collection('locations').add(data);

    // var name = data['file'].name;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(data['shopID'])
        .child('foodIMG')
        .child(data['imgName']);
    try {
      await reference.putFile(File(data['file'].path));
      var url = await reference.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('error in dataToStorage : $e');
      return null;
    }
  }

  Future<bool> deleteFoodImage(Map<String, dynamic> data) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(data['shopID'])
        .child('foodIMG')
        .child(data['imgName']);

    try {
      await reference.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> imgSharedFoodDataToStorage(Map<String, dynamic> data) async {
    // fireStoreInstance.collection('locations').add(data);

    var name = data['file'].name;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(data['memberID'])
        .child('foodIMG')
        .child(name);
    try {
      await reference.putFile(File(data['file'].path));
      var url = await reference.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('error in dataToStorage : $e');
      return null;
    }
  }

  Future<XFile> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile file = (await imagePicker.pickImage(source: ImageSource.gallery))!;
    return file;
  }

  Future<bool> deleteFoodData(Map<String, dynamic> data) async {
    try {
      await fireStoreInstance.collection('food').doc(data['foodID']).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateFoodData(Map<String, dynamic> data) async {
    await fireStoreInstance.collection('food').doc(data['foodID']).update({
      // 'foodID': data['foodID'],
      'foodName': data['foodName'],
      'foodImageURL': data['foodImageURL'],
      'detailNotes': data['detailNotes'],
      'price': data['price'],
      'qty': data['qty'],
      // 'shopID': data['shopID'],
    }).whenComplete(() {
      debugPrint('adding new data is successful');
    }).catchError((error) {
      debugPrint('error : $error');
    });
  }

  Future<void> addNewSharedFoodData(Map<String, dynamic> data) async {
    await fireStoreInstance
        .collection('sharedFood')
        .doc(data['sharedFoodID'])
        .set({
      'sharedFoodID': data['sharedFoodID'],
      'sharedFoodName': data['sharedFoodName'],
      'sharedFoodImageURL': data['sharedFoodImageURL'],
      'detailNotes': data['detailNotes'],
      'price': data['price'],
      'memberID': data['memberID'],
      'status': data['status'],
      'date': data['date'],
    }).whenComplete(() {
      debugPrint('adding new data is successful');
    }).catchError((error) {
      debugPrint('error : $error');
    });
  }

  Future<void> addNewFoodData(Map<String, dynamic> data) async {
    await fireStoreInstance.collection('food').doc(data['foodID']).set({
      'foodID': data['foodID'],
      'foodName': data['foodName'],
      'foodImageURL': data['foodImageURL'],
      'detailNotes': data['detailNotes'],
      'price': data['price'],
      'qty': data['qty'],
      'shopID': data['shopID'],
    }).whenComplete(() {
      debugPrint('adding new data is successful');
    }).catchError((error) {
      debugPrint('error : $error');
    });
  }

  // Future<void> getFilteredFoodList(Map<String, dynamic> data) async {
  //   late Query query;
  //   if (firstTime) {
  //     query = fireStoreInstance
  //         .collection('shop')
  //         .doc(data['shopID'])
  //         .collection('foodList')
  //         .orderBy('date', descending: false)
  //         .where('latitude', isGreaterThanOrEqualTo: data['minLat'])
  //         .where('latitude', isLessThanOrEqualTo: data['maxLat'])
  //         .where('longitude', isGreaterThanOrEqualTo: data['minLon'])
  //         .where('longitude', isLessThanOrEqualTo: data['maxLon'])
  //         .limit(10);
  //
  //     firstTime = false;
  //   } else if (currDoc != null) {
  //     query = fireStoreInstance
  //         .collection('shop')
  //         .doc(data['shopID'])
  //         .collection('foodList')
  //         .orderBy('date', descending: false)
  //         .where('latitude', isGreaterThanOrEqualTo: data['minLat'])
  //         .where('latitude', isLessThanOrEqualTo: data['maxLat'])
  //         .where('longitude', isGreaterThanOrEqualTo: data['minLon'])
  //         .where('longitude', isLessThanOrEqualTo: data['maxLon'])
  //         .limit(10)
  //         .startAfterDocument(currDoc!);
  //   } else {
  //     return;
  //   }
  //
  //   var index = streamList.length + 1;
  //
  //   var snapshot = query.snapshots().listen((event) {
  //     if (event.size == 0) return deleteStream(data['shopID']);
  //
  //     event.docChanges.asMap().forEach((key, value) {
  //       switch (value.type) {
  //         case DocumentChangeType.added:
  //           // if (addData == false) addData = true;
  //           debugPrint("added : ${Food.fromMap(value.doc).foodID}");
  //           // When a data is deleted in the database it will trigger
  //           // changes (type = added) to retrieve more data and then it
  //           // retrieves data after the last one of this snapshot initial
  //           // retrieve thus, there'll be duplication inside the list
  //           // so it has to be removed
  //           listItem.removeWhere(
  //               (element) => element.foodID == Food.fromMap(value.doc).foodID);
  //           listItem.add(Food.fromMap(value.doc));
  //           break;
  //         case DocumentChangeType.modified:
  //           debugPrint("modified : ${Food.fromMap(value.doc).foodID}");
  //           int i = listItem.indexWhere(
  //               (element) => element.foodID == Food.fromMap(value.doc).foodID);
  //           listItem[i] = Food.fromMap(value.doc);
  //           break;
  //         case DocumentChangeType.removed:
  //           // if (removeData == false) removeData = true;
  //           debugPrint("removed : ${Food.fromMap(value.doc).foodID}");
  //           listItem.removeWhere(
  //               (element) => element.foodID == Food.fromMap(value.doc).foodID);
  //           break;
  //       }
  //     });
  //     listItem.sort((a, b) => b.foodID.compareTo(a.foodID));
  //
  //     debugPrint(
  //         'index : $index, streamList.length : ${streamList.length}, event.size : ${event.size}');
  //     if (index == streamList.length && event.size == 10) {
  //       currDoc = event.docs.last;
  //       debugPrint(
  //           'change the currDoc on stream : $index, with the streamList.length : ${streamList.length}');
  //     } else if (index == streamList.length && event.size < 10) {
  //       currDoc = null;
  //     }
  //   });
  //   streamList.add(snapshot);
  // }

  // void deleteStream(String shopID) {
  //   if (streamList.isNotEmpty) {
  //     streamList.last.cancel();
  //     streamList.removeLast();
  //     getLastDocSnapshots(shopID);
  //   }
  //   print('streamList : ${streamList}');
  // }
  //
  // void getLastDocSnapshots(String shopID) async {
  //   var query = fireStoreInstance
  //       .collection('shop')
  //       .doc(listItem.last.foodID.toString());
  //   currDoc = await query.get();
  // }

  void deleteStreamFoodList(String shopID) {
    if (streamFoodList.isNotEmpty) {
      streamFoodList.last.cancel();
      streamFoodList.removeLast();
      getLastDocSnapshotsFoodList(shopID);
    }
  }

  void getLastDocSnapshotsFoodList(String shopID) async {
    var query = fireStoreInstance
        .collection('food')
        .doc(foodList.last.foodID.toString());
    currDocFoodList = await query.get();
  }

  void deleteStreamShareFoodList() {
    if (streamShareFoodList.isNotEmpty) {
      streamShareFoodList.last.cancel();
      streamShareFoodList.removeLast();
      getLastDocSnapshotsShareFoodList();
    }
  }

  void getLastDocSnapshotsShareFoodList() async {
    var query = fireStoreInstance
        .collection('sharedFood')
        .doc(shareFoodList.last.sharedFoodID.toString());
    currDocShareFoodList = await query.get();
  }

  Future<void> getSharedFoodList(String memberID) async {
    late Query query;
    if (firstTimeShareFoodList) {
      query = fireStoreInstance
          .collection('sharedFood')
          .where('memberID', isNotEqualTo: memberID)
          .orderBy('memberID')
          // .where('sharedFoodID', isEqualTo: data['sharedFoodID'])
          .orderBy('date', descending: true)
          .limit(10);

      firstTimeShareFoodList = false;
    } else if (currDocShareFoodList != null) {
      query = fireStoreInstance
          .collection('sharedFood')
          .where('memberID', isNotEqualTo: memberID)
          .orderBy('memberID')
          // .where('sharedFoodID', isEqualTo: data['sharedFoodID'])
          .orderBy('date', descending: true)
          .limit(10)
          .startAfterDocument(currDocShareFoodList!);
    } else {
      return;
    }

    var index = streamShareFoodList.length + 1;

    var snapshot = query.snapshots().listen((event) {
      if (event.size == 0) return deleteStreamShareFoodList();

      event.docChanges.asMap().forEach((key, value) {
        switch (value.type) {
          case DocumentChangeType.added:
            // if (addData == false) addData = true;
            debugPrint("added : ${SharedFood.fromMap(value.doc).sharedFoodID}");
            // When a data is deleted in the database, it will trigger
            // changes (type = added) to retrieve more data and then it
            // retrieves data after the last one of this snapshot initial
            // retrieve thus, there'll be duplication inside the list
            // so it has to be removed
            shareFoodList.removeWhere((element) =>
                element.sharedFoodID ==
                SharedFood.fromMap(value.doc).sharedFoodID);
            shareFoodList.add(SharedFood.fromMap(value.doc));
            print(shareFoodList);
            break;
          case DocumentChangeType.modified:
            debugPrint(
                "modified : ${SharedFood.fromMap(value.doc).sharedFoodID}");
            int i = shareFoodList.indexWhere((element) =>
                element.sharedFoodID ==
                SharedFood.fromMap(value.doc).sharedFoodID);
            shareFoodList[i] = SharedFood.fromMap(value.doc);
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            debugPrint(
                "removed : ${SharedFood.fromMap(value.doc).sharedFoodID}");
            shareFoodList.removeWhere((element) =>
                element.sharedFoodID ==
                SharedFood.fromMap(value.doc).sharedFoodID);
            break;
        }
      });
      shareFoodList.sort((a, b) => b.date.compareTo(a.date));

      debugPrint(
          'index : $index, streamList.length : ${streamShareFoodList.length}, event.size : ${event.size}');
      if (index == streamShareFoodList.length && event.size == 10) {
        currDocShareFoodList = event.docs.last;
        debugPrint(
            'change the currDoc on stream : $index, with the streamList.length : ${streamShareFoodList.length}');
      } else if (index == streamShareFoodList.length && event.size < 10) {
        currDocShareFoodList = null;
      }
    });
    streamShareFoodList.add(snapshot);
  }

  Future<void> getFoodList(Map<String, dynamic> data) async {
    late Query query;
    if (firstTimeFoodList) {
      query = fireStoreInstance
          .collection('food')
          .where('shopID', isEqualTo: data['shopID'])
          .orderBy('qty', descending: true)
          .limit(10);

      firstTimeFoodList = false;
    } else if (currDocFoodList != null) {
      query = fireStoreInstance
          .collection('shop')
          .where('shopID', isEqualTo: data['shopID'])
          .orderBy('qty', descending: true)
          .limit(10)
          .startAfterDocument(currDocFoodList!);
    } else {
      return;
    }

    var index = streamFoodList.length + 1;

    var snapshot = query.snapshots().listen((event) {
      if (event.size == 0) return deleteStreamFoodList(data['shopID']);

      event.docChanges.asMap().forEach((key, value) {
        switch (value.type) {
          case DocumentChangeType.added:
            // if (addData == false) addData = true;
            debugPrint("added : ${Food.fromMap(value.doc).foodID}");
            // When a data is deleted in the database, it will trigger
            // changes (type = added) to retrieve more data and then it
            // retrieves data after the last one of this snapshot initial
            // retrieve thus, there'll be duplication inside the list
            // so it has to be removed
            foodList.removeWhere(
                (element) => element.foodID == Food.fromMap(value.doc).foodID);
            foodList.add(Food.fromMap(value.doc));
            break;
          case DocumentChangeType.modified:
            debugPrint("modified : ${Food.fromMap(value.doc).foodID}");
            int i = foodList.indexWhere(
                (element) => element.foodID == Food.fromMap(value.doc).foodID);
            foodList[i] = Food.fromMap(value.doc);
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            debugPrint("removed : ${Food.fromMap(value.doc).foodID}");
            foodList.removeWhere(
                (element) => element.foodID == Food.fromMap(value.doc).foodID);
            break;
        }
      });
      foodList.sort((a, b) => b.qty.compareTo(a.qty));

      debugPrint(
          'index : $index, streamList.length : ${streamFoodList.length}, event.size : ${event.size}');
      if (index == streamFoodList.length && event.size == 10) {
        currDocFoodList = event.docs.last;
        debugPrint(
            'change the currDoc on stream : $index, with the streamList.length : ${streamFoodList.length}');
      } else if (index == streamFoodList.length && event.size < 10) {
        currDocFoodList = null;
      }
    });
    streamFoodList.add(snapshot);
  }

  Future<Food> getFoodData(String foodID) async {
    var res = await fireStoreInstance
        .collection('food')
        .where('foodID', isEqualTo: foodID)
        .get();

    return Food.fromMap(res.docs[0]);
  }

  Future<bool> checkFoodCartList(cart) async {
    var res = await fireStoreInstance
        .collection('food')
        .where('foodID', isEqualTo: cart.foodID)
        .where('qty', isGreaterThanOrEqualTo: cart.qty)
        .get();
    var a = res.docs.isNotEmpty;
    print(a);
    return false;
  }

  Future<void> test() async {
    var res = await fireStoreInstance
        .collection('sharedFood')
        .where('memberID', isNotEqualTo: 'cr8mVrJeYBbmDHJ6gNywIOPws7H3')
        .where('status', isEqualTo: 'onsale')
        .orderBy('memberID')
        // .where('sharedFoodID', isEqualTo: data['sharedFoodID'])
        .orderBy('date', descending: true)
        .get();
    res.docs.asMap().forEach((key, value) {
      print(value.data());
    });
    // var l = res.docs.map((doc) {
    //   return Food.fromMap(doc);
    // }).toList();
    // print(l);
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

  Future<bool> createShareFoodTransaction(
      {required TransactionShareFoodModel tsf}) async {
    try {
      await fireStoreInstance
          .collection('shareFoodTransaction')
          .doc(tsf.shareFoodTransactionID)
          .set({
        'memberBuyID': tsf.memberBuyID,
        'shareFoodTransactionID': tsf.shareFoodTransactionID,
        'memberSellID': tsf.memberSellID,
        'date': tsf.date,
        'shareFoodID': tsf.shareFoodID,
        'status': tsf.status,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> shareFoodStatusToBought(SharedFood sf) async {
    await fireStoreInstance
        .collection('sharedFood')
        .doc(sf.sharedFoodID)
        .update({
      'status': 'Bought',
    });
  }





  void getLastDocSnapshotsMemberShareFoodList() async {
    var query = fireStoreInstance
        .collection('sharedFood')
        .doc(shareMemberFoodList.last.sharedFoodID.toString());
    currDocMemberShareFoodList = await query.get();
  }

  void deleteStreamMemberShareFoodList() {
    if (streamMemberShareFoodList.isNotEmpty) {
      streamMemberShareFoodList.last.cancel();
      streamMemberShareFoodList.removeLast();
      getLastDocSnapshotsMemberShareFoodList();
    }
  }
  // shareMemberFoodList.clear();
  // currDocMemberShareFoodList = null;
  // firstTimeMemberShareFoodList = true;
  // for (var element in streamMemberShareFoodList) {
  // element.cancel();
  // }
  // streamMemberShareFoodList.clear();
  Future<void> getMemberShareFoodList(String memberID)async{
    late Query query;
    if (firstTimeMemberShareFoodList) {
      query = fireStoreInstance
          .collection('sharedFood')
          .where('memberID', isEqualTo: memberID)
          .orderBy('date', descending: true)
          .limit(10);

      firstTimeMemberShareFoodList = false;
    } else if (currDocMemberShareFoodList != null) {
      query = fireStoreInstance
          .collection('shop')
          .where('memberID', isEqualTo: memberID)
          .orderBy('date', descending: true)
          .limit(10)
          .startAfterDocument(currDocMemberShareFoodList!);
    } else {
      return;
    }

    var index = streamMemberShareFoodList.length + 1;

    var snapshot = query.snapshots().listen((event) {
      if (event.size == 0) return deleteStreamMemberShareFoodList();

      event.docChanges.asMap().forEach((key, value) {
        switch (value.type) {
          case DocumentChangeType.added:
          // if (addData == false) addData = true;
            debugPrint("added : ${SharedFood.fromMap(value.doc).sharedFoodID}");
            // When a data is deleted in the database, it will trigger
            // changes (type = added) to retrieve more data and then it
            // retrieves data after the last one of this snapshot initial
            // retrieve thus, there'll be duplication inside the list
            // so it has to be removed
            shareMemberFoodList.removeWhere((element) =>
            element.sharedFoodID ==
                SharedFood.fromMap(value.doc).sharedFoodID);
            shareMemberFoodList.add(SharedFood.fromMap(value.doc));
            print(shareMemberFoodList);
            break;
          case DocumentChangeType.modified:
            debugPrint(
                "modified : ${SharedFood.fromMap(value.doc).sharedFoodID}");
            int i = shareMemberFoodList.indexWhere((element) =>
            element.sharedFoodID ==
                SharedFood.fromMap(value.doc).sharedFoodID);
            shareMemberFoodList[i] = SharedFood.fromMap(value.doc);
            break;
          case DocumentChangeType.removed:
          // if (removeData == false) removeData = true;
            debugPrint(
                "removed : ${SharedFood.fromMap(value.doc).sharedFoodID}");
            shareMemberFoodList.removeWhere((element) =>
            element.sharedFoodID ==
                SharedFood.fromMap(value.doc).sharedFoodID);
            break;
        }
      });
      shareMemberFoodList.sort((a, b) => b.date.compareTo(a.date));

      debugPrint(
          'index : $index, streamList.length : ${streamMemberShareFoodList.length}, event.size : ${event.size}');
      if (index == streamMemberShareFoodList.length && event.size == 10) {
        currDocMemberShareFoodList = event.docs.last;
        debugPrint(
            'change the currDoc on stream : $index, with the streamList.length : ${streamMemberShareFoodList.length}');
      } else if (index == streamMemberShareFoodList.length && event.size < 10) {
        currDocMemberShareFoodList = null;
      }
    });
    streamMemberShareFoodList.add(snapshot);
  }
}
