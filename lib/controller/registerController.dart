import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'dart:developer' as devtools show log;
import 'package:skripsiii/model/addressModel.dart';

class RegisterController extends GetxController {
  final fireStoreInstance = FirebaseFirestore.instance;

  // void createMember() {
  //   currMember = Member.blank();
  //   // currMember.email = FirebaseAuth.instance.currentUser!.email!;
  //   // currMember.memberID = FirebaseAuth.instance.currentUser!.uid;
  // }
  //
  // void cretaShop() {
  //   currShop = Shop.blank();
  // }

  // void addMemberDetail(Map<String, dynamic> data) {
  //   currMember = Member(
  //     email: data['email'],
  //     password: data['password'],
  //     memberID: data['memberID'],
  //     username: data['username'],
  //     name: data['name'],
  //     contacts: data['contacts'],
  //   );
  // }

  Future<UserCredential?> registerMember(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Authentication successful, return the UserCredential object
      return userCredential;
    } catch (e) {
      // Handle any errors that occur during authentication
      devtools.log('register member with email and password failed: $e');
      return null;
    }
  }

  Future<bool> addMemberToFirebase(Member m) async {
    try {
      await fireStoreInstance.collection('member').doc(m.memberID).set({
        'email': m.email,
        'password': m.password,
        'memberID': m.memberID,
        'username': m.username,
        'name': m.name,
        'contacts': m.contacts,
      });
      return true;
    } catch (e) {
      devtools.log('error while registering new member : $e');
      return false;
    }
  }

  Future<bool> addAddressToFirebase(Address address) async {
    try {
      await fireStoreInstance
          .collection('address')
          .doc(address.addressID)
          .set({
        'addressID': address.addressID,
        'userID': address.userID,
        'address': address.address,
        'province': address.province,
        'city': address.city,
        'postalCode': address.poscode,
        'latitude': address.latitude,
        'longitude': address.longitude,
      });
      return true;
    } catch (e) {
      devtools.log('error while registering new address : $e');
      return false;
    }
  }

  Future<bool> addShopToFirebase(Shop s) async {
    try {
      await fireStoreInstance.collection('shop').doc(s.shopID).set({
        'email': s.email,
        'password': s.password,
        'shopID': s.shopID,
        'name': s.shopName,
        'contacts': s.contacts,
        'ratingAVG': s.ratingAVG,
        'closingTime': s.closingTime,
        'sellingTime': s.sellingTime,
        'isOpen': 'false',
        'totalReview': s.totalReview,
      });
      return true;
    } catch (e) {
      devtools.log('error while registering new shop : $e');
      return false;
    }
  }

  Future<void> registerShop(Map<String, dynamic> data) async {
    try {
      await fireStoreInstance.collection('shop').doc(data['uid']).set({
        'email': data['email'],
        'shopID': data['uid'],
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<UserCredential?> registerUserToFirebase(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Authentication successful, return the UserCredential object
      return userCredential;
    } catch (e) {
      // Handle any errors that occur during authentication
      return null;
    }
  }
// Future<dynamic> addMemberToFirebase(Map<String, dynamic> data) async {
//   var member = await fireStoreInstance
//       .collection('member')
//       .where('email', isEqualTo: data['email'])
//   // .where('password', isEqualTo: data['password'])
//       .get();
//
//   if (member.docs.isNotEmpty) {
//     Member m = Member.fromJson(member.docs[0].data());
//     var map = {
//       'userID': m.memberID,
//       // 'password': m.password,
//       'email': m.email,
//       'role': 'member',
//     };
//     await DatabaseHelper.instance.loginUser(map);
//     return m;
//   }
//
//   // TODO command this line so user can change user and don't stuck on the register page
//   // var map = {
//   //   'userID': data['uid'],
//   //   'email': data['email'],
//   // };
//   // await DatabaseHelper.instance.loginUser(map);
//   return null;
// }
}
