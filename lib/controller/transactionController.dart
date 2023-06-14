import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/model/transactionModel.dart';

class TransactionController extends GetxController {
  List<StreamSubscription<QuerySnapshot>> streamList = [];
  List<TransactionModel> listItem = [];
  final fireStoreInstance = FirebaseFirestore.instance;
  late DocumentSnapshot? currDoc;

  bool firstTime = true;

  // final MemberController memberController = Get.find<MemberController>();

  void reset() {
    for (var element in streamList) {
      element.cancel();
    }
    streamList.clear();
    print('streamList : ${streamList}');
    listItem.clear();
    currDoc = null;
    firstTime = true;
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
    }
    print('streamList : ${streamList}');
  }

  void getLastDocSnapshots() async {
    if (listItem.isNotEmpty) {
      var query = fireStoreInstance
          .collection('shop')
          .doc(listItem.last.transactionID.toString());
      currDoc = await query.get();
    }
  }

  Future<void> getAllDataShop(String shopID) async {
    late Query query;
    if (firstTime) {
      query = fireStoreInstance
          .collection('transaction')
          .where('shopID', isEqualTo: shopID)
          .where('status', isEqualTo: 'ongoing')
          .orderBy('date', descending: true)
          .limit(10);
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
      if (event.size == 0) return deleteStream();

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

  Future<void> test(String shopID) async {
    var res = await fireStoreInstance
        .collection('transaction')
        .where('shopID', isEqualTo: shopID)
        .where('status', isEqualTo: 'ongoing')
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
}
