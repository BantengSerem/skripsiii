import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/model/transactionModel.dart';
import 'package:skripsiii/model/transctionShareFood.dart';

class TransactionController extends GetxController {
  List<StreamSubscription<QuerySnapshot>> streamList = [];
  RxList<TransactionModel> listItem = RxList<TransactionModel>();
  final fireStoreInstance = FirebaseFirestore.instance;
  late DocumentSnapshot? currDoc;

  bool firstTime = true;

  // final MemberController memberController = Get.find<MemberController>();

  List<StreamSubscription<QuerySnapshot>> streamHistoryList = [];
  RxList<TransactionModel> listHistoryItem = RxList<TransactionModel>();
  late DocumentSnapshot? currDocHistory;

  bool firstTimeHistory = true;

  void resetShopHistory() {
    for (var element in streamHistoryList) {
      element.cancel();
    }
    streamHistoryList.clear();
    print('streamList : ${streamHistoryList}');
    listHistoryItem.clear();
    currDocHistory = null;
    firstTimeHistory = true;
  }

  void resetShopHome() {
    print('reset password');
    for (var element in streamList) {
      element.cancel();
    }
    streamList.clear();
    print('streamList : ${streamList}');
    listItem.clear();
    currDoc = null;
    firstTime = true;
  }

  void reset() {
    for (var element in streamList) {
      element.cancel();
    }
    streamList.clear();
    print('streamList : ${streamList}');
    listItem.clear();
    currDoc = null;
    firstTime = true;

    for (var element in streamHistoryList) {
      element.cancel();
    }
    streamHistoryList.clear();
    print('streamList : ${streamHistoryList}');
    listHistoryItem.clear();
    currDocHistory = null;
    firstTimeHistory = true;
  }

  void refreshAllData() {
    for (var element in streamList) {
      element.cancel();
    }
    streamList.clear();
    print('streamList : ${streamList}');
    listItem.clear();
    currDoc = null;
    firstTime = true;
  }

  void deleteStream() {
    if (streamList.isNotEmpty) {
      streamList.last.cancel();
      streamList.removeLast();
      getLastDocSnapshots();
    } else {
      firstTime = true;
    }
    print('streamList : ${streamList}');
  }

  void getLastDocSnapshots() async {
    if (listItem.isNotEmpty) {
      var query = fireStoreInstance
          .collection('shop')
          .doc(listItem.last.transactionID.toString());
      currDoc = await query.get();
    } else {
      firstTime = true;
    }
  }

  Future<void> getAllDataShop(String shopID) async {
    late Query query;
    print(firstTime);
    if (firstTime) {
      query = fireStoreInstance
          .collection('transaction')
          .where('shopID', isEqualTo: shopID)
          .where('status', isEqualTo: 'ongoing')
          .orderBy('date', descending: true)
          .limit(10);
      firstTime = false;
    } else if (currDoc != null) {
      query = fireStoreInstance
          .collection('transaction')
          .where('shopID', isEqualTo: shopID)
          .where('status', isEqualTo: 'ongoing')
          .orderBy('date', descending: true)
          .limit(10)
          .startAfterDocument(currDoc!);
    } else {
      return;
    }

    var index = streamList.length + 1;

    var snapshot = query.snapshots().listen((event) {
      if (event.size == 0 && streamList.length > 1) return deleteStream();

      event.docChanges.asMap().forEach((key, value) {
        switch (value.type) {
          case DocumentChangeType.added:
            debugPrint(
                "added : ${TransactionModel.fromMap(value.doc).transactionID}");
            listItem.removeWhere((element) =>
                element.transactionID ==
                TransactionModel.fromMap(value.doc).transactionID);
            listItem.add(TransactionModel.fromMap(value.doc));
            break;
          case DocumentChangeType.modified:
            debugPrint(
                "modified : ${TransactionModel.fromMap(value.doc).transactionID}");
            int i = listItem.indexWhere((element) =>
                element.transactionID ==
                TransactionModel.fromMap(value.doc).transactionID);
            listItem[i] = TransactionModel.fromMap(value.doc);
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            //   debugPrint("removed : ${Food.fromMap(value.doc).foodID}");
            listItem.removeWhere((element) =>
                element.transactionID ==
                TransactionModel.fromMap(value.doc).transactionID);
            break;
        }
      });
      listItem.sort((a, b) => b.date.compareTo(a.date));

      if (index == streamList.length && event.size == 10) {
        currDoc = event.docs.last;
        debugPrint(
            'change the currDoc on stream : $index, with the streamList.length : ${streamList.length}');
      } else if (index == streamList.length && event.size < 10) {
        currDoc = null;
      }
    });
    streamList.add(snapshot);
  }

  // List<StreamSubscription<QuerySnapshot>> streamHistoryList = [];
  // RxList<TransactionModel> listHistoryItem = RxList<TransactionModel>();
  // late DocumentSnapshot? currDocHistory;
  //
  // bool firstTimeHistory = true;
  void deleteStreamHistory() {
    if (streamHistoryList.isNotEmpty) {
      streamHistoryList.last.cancel();
      streamHistoryList.removeLast();
      getLastDocSnapshotsHistory();
    } else {
      firstTimeHistory = true;
    }
    firstTimeHistory = true;
    print('streamHistoryList : ${streamHistoryList}');
  }

  void getLastDocSnapshotsHistory() async {
    if (listHistoryItem.isNotEmpty) {
      var query = fireStoreInstance
          .collection('shop')
          .doc(listHistoryItem.last.transactionID.toString());
      currDocHistory = await query.get();
    } else {
      firstTimeHistory = true;
    }
  }

  Future<void> getShopHistoryList(String shopID) async {
    late Query query;
    if (firstTimeHistory) {
      query = fireStoreInstance
          .collection('transaction')
          .where('shopID', isEqualTo: shopID)
          .where('status', isNotEqualTo: 'ongoing')
          .orderBy('status')
          .orderBy('date', descending: true)
          .limit(10);
      firstTimeHistory = false;
    } else if (currDocHistory != null) {
      query = fireStoreInstance
          .collection('transaction')
          .where('shopID', isEqualTo: shopID)
          .where('status', isNotEqualTo: 'ongoing')
          .orderBy('status')
          .orderBy('date', descending: true)
          .limit(10)
          .startAfterDocument(currDocHistory!);
    } else {
      return;
    }

    var index = streamHistoryList.length + 1;

    var snapshot = query.snapshots().listen((event) {
      if (event.size == 0 && streamHistoryList.length > 1) return deleteStreamHistory();

      event.docChanges.asMap().forEach((key, value) {
        switch (value.type) {
          case DocumentChangeType.added:
            debugPrint(
                "added : ${TransactionModel.fromMap(value.doc).transactionID}");
            listHistoryItem.removeWhere((element) =>
                element.transactionID ==
                TransactionModel.fromMap(value.doc).transactionID);
            listHistoryItem.add(TransactionModel.fromMap(value.doc));
            break;
          case DocumentChangeType.modified:
            debugPrint(
                "modified : ${TransactionModel.fromMap(value.doc).transactionID}");
            int i = listHistoryItem.indexWhere((element) =>
                element.transactionID ==
                TransactionModel.fromMap(value.doc).transactionID);
            listHistoryItem[i] = TransactionModel.fromMap(value.doc);
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            //   debugPrint("removed : ${Food.fromMap(value.doc).foodID}");
            listHistoryItem.removeWhere((element) =>
                element.transactionID ==
                TransactionModel.fromMap(value.doc).transactionID);
            break;
        }
      });
      listHistoryItem.sort((a, b) => b.date.compareTo(a.date));

      if (index == streamHistoryList.length && event.size == 10) {
        currDocHistory = event.docs.last;
        debugPrint(
            'change the currDocHistory on stream : $index, with the streamHistoryList.length : ${streamHistoryList.length}');
      } else if (index == streamHistoryList.length && event.size < 10) {
        currDocHistory = null;
      }
    });
    streamHistoryList.add(snapshot);
  }

  Future<void> getMemberHistoryList(String memberID) async {
    late Query query;
    if (firstTimeHistory) {
      query = fireStoreInstance
          .collection('transaction')
          .where('memberID', isEqualTo: memberID)
          .orderBy('date', descending: true)
          .limit(10);
      firstTimeHistory = false;
    } else if (currDocHistory != null) {
      query = fireStoreInstance
          .collection('transaction')
          .where('memberID', isEqualTo: memberID)
          .orderBy('date', descending: true)
          .limit(10)
          .startAfterDocument(currDocHistory!);
    } else {
      return;
    }

    var index = streamHistoryList.length + 1;

    var snapshot = query.snapshots().listen((event) {
      if (event.size == 0 && streamHistoryList.length > 1) return deleteStreamHistory();

      event.docChanges.asMap().forEach((key, value) {
        switch (value.type) {
          case DocumentChangeType.added:
            debugPrint(
                "added : ${TransactionModel.fromMap(value.doc).transactionID}");
            listHistoryItem.removeWhere((element) =>
                element.transactionID ==
                TransactionModel.fromMap(value.doc).transactionID);
            listHistoryItem.add(TransactionModel.fromMap(value.doc));
            break;
          case DocumentChangeType.modified:
            debugPrint(
                "modified : ${TransactionModel.fromMap(value.doc).transactionID}");
            int i = listHistoryItem.indexWhere((element) =>
                element.transactionID ==
                TransactionModel.fromMap(value.doc).transactionID);
            listHistoryItem[i] = TransactionModel.fromMap(value.doc);
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            //   debugPrint("removed : ${Food.fromMap(value.doc).foodID}");
            listHistoryItem.removeWhere((element) =>
                element.transactionID ==
                TransactionModel.fromMap(value.doc).transactionID);
            break;
        }
      });
      listHistoryItem.sort((a, b) => b.date.compareTo(a.date));

      if (index == streamHistoryList.length && event.size == 10) {
        currDocHistory = event.docs.last;
        debugPrint(
            'change the currDocHistory on stream : $index, with the streamHistoryList.length : ${streamHistoryList.length}');
      } else if (index == streamHistoryList.length && event.size < 10) {
        currDocHistory = null;
      }
    });
    streamHistoryList.add(snapshot);
  }

  Future<void> test(String memberID) async {
    var res = await fireStoreInstance
        .collection('transaction')
        .where('memberID', isEqualTo: memberID)
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    List<TransactionModel> l = [];

    res.docs.asMap().forEach((key, value) {
      print(value.data());
      l.add(TransactionModel.fromMap(value));
    });

    print(l);
  }

  Future<bool> statusToCompleted(String transactionID) async {
    try {
      await fireStoreInstance
          .collection('transaction')
          .doc(transactionID)
          .update({
        'status': 'completed',
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> statusToCanceled(String transactionID) async {
    try {
      await fireStoreInstance
          .collection('transaction')
          .doc(transactionID)
          .update({
        'status': 'canceled',
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<TransactionShareFoodModel>> getSellSharedFoodMember(
      String memberID) async {
    List<TransactionShareFoodModel> l = [];

    var res = await fireStoreInstance
        .collection('shareFoodTransaction')
        .where('memberSellID', isEqualTo: memberID)
        .get();

    res.docs.asMap().forEach((key, value) {
      var a = TransactionShareFoodModel.fromMap(value);
      l.add(a);
    });
    return l;
  }

  Future<List<TransactionShareFoodModel>> getBuySharedFoodMember(
      String memberID) async {
    List<TransactionShareFoodModel> l = [];

    var res = await fireStoreInstance
        .collection('shareFoodTransaction')
        .where('memberBuyID', isEqualTo: memberID)
        .get();

    res.docs.asMap().forEach((key, value) {
      var a = TransactionShareFoodModel.fromMap(value);
      l.add(a);
    });
    return l;
  }
}
