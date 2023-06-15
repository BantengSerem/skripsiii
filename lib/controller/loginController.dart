import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skripsiii/helper/databaseHelper.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'dart:developer' as devtools show log;

class LoginController extends GetxController {
  final fireStoreInstance = FirebaseFirestore.instance;
  late final GoogleSignInAuthentication googleSignInAuthentication;

  late final GoogleSignIn googleSignIn =
      GoogleSignIn(scopes: <String>["email"]);
  late GoogleSignInAccount? _googleUser;

  Future verifyEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<bool> checkLogin() async {
    bool res = await DatabaseHelper.instance.checkLogin();
    return res;
  }

  Future<void> updateRoleDB(String role, String userid) async {
    await DatabaseHelper.instance.updateRole(role, userid);
  }

  // Future<void> getUser() async {
  //   var res = await DatabaseHelper.instance.getUser();
  // }

  Future<void> logout() async {
    await DatabaseHelper.instance.logoutUser();
    await firebaseLogOut();
    // Get.offAll(() => LoginPage(), binding: HomeBinding());
  }

  Future<UserCredential?> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      devtools.log(userCredential.toString());
      // Authentication successful, return the UserCredential object
      return userCredential;
    } catch (e) {
      // Handle any errors that occur during authentication
      return null;
    }
  }

  Future<dynamic> manualLogin(Map<String, dynamic> data) async {
    var member = await fireStoreInstance
        .collection('member')
        .where('email', isEqualTo: data['email'])
        // .where('password', isEqualTo: data['password'])
        .get();

    var shop = await fireStoreInstance
        .collection('shop')
        .where('email', isEqualTo: data['email'])
        // .where('password', isEqualTo: data['password'])
        .get();

    if (member.docs.isNotEmpty) {
      Member m = Member.fromJson(member.docs[0].data());
      var map = {
        'userID': m.memberID,
        // 'password': m.password,
        'email': m.email,
        'role': 'member',
      };
      await DatabaseHelper.instance.loginUser(map);
      return m;
    } else if (shop.docs.isNotEmpty) {
      // Shop s = Shop.fromMap(shop.docs[0]);
      Shop s = Shop.fromJson(shop.docs[0].data());
      var map = {
        'userID': s.shopID,
        // 'password': s.password,
        'email': s.email,
        'role': 'shop',
      };
      await DatabaseHelper.instance.loginUser(map);
      return s;
    }

    // TODO command this line so user can change user and don't stuck on the register page
    // var map = {
    //   'userID': data['uid'],
    //   'email': data['email'],
    // };
    // await DatabaseHelper.instance.loginUser(map);
    return null;
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

  Future<Member> getMemberData(String email) async {
    var member = await fireStoreInstance
        .collection('member')
        .where('email', isEqualTo: email)
        .get();
    Member m = Member.fromJson(member.docs[0].data());
    var map = {
      'userID': m.memberID,
      'email': m.email,
      'role': 'member',
    };
    await DatabaseHelper.instance.loginUser(map);
    return m;
  }

  Future<Shop> getShopData(String email) async {
    var shop = await fireStoreInstance
        .collection('shop')
        .where('email', isEqualTo: email)
        .get();
    Shop s = Shop.fromJson(shop.docs[0].data());
    var map = {
      'userID': s.shopID,
      'email': s.email,
      'role': 'shop',
    };
    await DatabaseHelper.instance.loginUser(map);
    return s;
  }

  Future<dynamic> getUserData(UserCredential userCredential) async {
    User? user = userCredential.user;
    var member = await fireStoreInstance
        .collection('member')
        .where('email', isEqualTo: user?.email)
        // .where('password', isEqualTo: '')
        // .where('uid', isEqualTo: user?.uid.toString())
        .get();

    var shop = await fireStoreInstance
        .collection('shop')
        .where('email', isEqualTo: user?.email)
        // .where('password', isEqualTo: '')
        // .where('uid', isEqualTo: user?.uid.toString())
        .get();
    if (member.docs.isNotEmpty) {
      Member m = Member.fromJson(member.docs[0].data());
      var map = {
        'userID': m.memberID,
        'email': m.email,
        'role': 'member',
      };
      await DatabaseHelper.instance.loginUser(map);
      return m;
    } else if (shop.docs.isNotEmpty) {
      Shop s = Shop.fromJson(shop.docs[0].data());
      var map = {
        'userID': s.shopID,
        'email': s.email,
        'role': 'shop',
      };
      await DatabaseHelper.instance.loginUser(map);
      return s;
    }

    // TODO command this line so user can change user and don't stuck on the register page
    // var map = {
    //   'userID': user?.uid,
    //   'email': user?.email,
    // };
    // await DatabaseHelper.instance.loginUser(map);
    return null;
  }

  Future<dynamic> googleLogin() async {
    try {
      _googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await _googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // userCredential.user?.uid;
      return await getUserData(userCredential);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> firebaseLogOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    _googleUser = null;
  }

  Future<Map<String, dynamic>> getUserEmailRoleAndUid() async {
    return await DatabaseHelper.instance.getUserEmailRoleAndUid();
  }

  void test() {
  }
}
