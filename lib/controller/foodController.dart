import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsiii/model/foodModel.dart';

class FoodController extends GetxController {
  List<StreamSubscription<QuerySnapshot>> streamList = [];
  List<Food> listItem = [];
  final fireStoreInstance = FirebaseFirestore.instance;
  late DocumentSnapshot? currDoc;

  // late DocumentSnapshot? currDoc = null;
  bool firstTime = true;

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

  Future<String?> dataToStorage(Map<String, dynamic> data) async {
    var name = data['file'].name;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(data['restaurantID'])
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

  Future<void> addNewFoodData(Map<String, dynamic> data) async {
    await fireStoreInstance
        .collection('restaurant')
        .doc(data['restaurantID'])
        .collection('foodList')
        .doc(data['foodID'])
        .set({
      'foodID': data['foodID'],
      'foodName': data['foodName'],
      'foodImageURL': data['foodImageURL'],
      'detailNotes': data['detailNotes'],
      'price': data['price'],
      'qty': data['qty'],
    }).whenComplete(() {
      debugPrint('adding new data is successful');
    }).catchError((error) {
      debugPrint('error : $error');
    });
  }

  Future<void> updateFoodData(Map<String, dynamic> data) async {
    await fireStoreInstance
        .collection('restaurant')
        .doc(data['restaurantID'])
        .collection('foodList')
        .doc(data['foodID'])
        .update({
      'foodID': data['foodID'],
      'foodName': data['foodName'],
      'foodImageURL': data['foodImageURL'],
      'detailNotes': data['detailNotes'],
      'price': data['price'],
      'qty': data['qty'],
    }).whenComplete(() {
      debugPrint('updating data is successful');
    }).catchError((error) {
      debugPrint('error : $error');
    });
  }

  void deleteStream() {
    streamList.last.cancel();
    streamList.removeLast();
    getLastDocSnapshots();
    print('streamList : ${streamList}');
  }

  void getLastDocSnapshots() async {
    var query = fireStoreInstance
        .collection('testList')
        .doc(listItem.last.foodID.toString());
    currDoc = await query.get();
  }

  Future<void> getFoodList(Map<String, dynamic> data) async {
    late Query query;
    if (firstTime) {
      query = fireStoreInstance
          .collection('restaurant')
          .doc(data['restaurantID'])
          .collection('foodList')
          .orderBy('date', descending: false)
          .limit(10);

      firstTime = false;
    } else if (currDoc != null) {
      query = fireStoreInstance
          .collection('restaurant')
          .doc(data['restaurantID'])
          .collection('foodList')
          .orderBy('date', descending: false)
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
            // if (addData == false) addData = true;
            debugPrint("added : ${Food.fromMap(value.doc).foodID}");
            // When a data is deleted in the database it will trigger
            // changes (type = added) to retrieve more data and then it
            // retrieves data after the last one of this snapshot initial
            // retrieve thus, there'll be duplication inside the list
            // so it has to be removed
            listItem.removeWhere(
                (element) => element.foodID == Food.fromMap(value.doc).foodID);
            listItem.add(Food.fromMap(value.doc));
            break;
          case DocumentChangeType.modified:
            debugPrint("modified : ${Food.fromMap(value.doc).foodID}");
            int i = listItem.indexWhere(
                (element) => element.foodID == Food.fromMap(value.doc).foodID);
            listItem[i] = Food.fromMap(value.doc);
            break;
          case DocumentChangeType.removed:
            // if (removeData == false) removeData = true;
            debugPrint("removed : ${Food.fromMap(value.doc).foodID}");
            listItem.removeWhere(
                (element) => element.foodID == Food.fromMap(value.doc).foodID);
            break;
        }
      });
      listItem.sort((a, b) => b.foodID.compareTo(a.foodID));

      debugPrint(
          'index : $index, streamList.length : ${streamList.length}, event.size : ${event.size}');
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
}
