import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skripsiii/helper/databaseHelper.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/model/userModel.dart';
import 'dart:developer' as devtools show log;

class LoginController extends GetxController {
  final fireStoreInstance = FirebaseFirestore.instance;
  late final GoogleSignInAuthentication googleSignInAuthentication;

  late final GoogleSignIn googleSignIn =
      GoogleSignIn(scopes: <String>["email"]);
  late GoogleSignInAccount? _googleUser;

  Future<bool> checkLogin() async {
    bool res = await DatabaseHelper.instance.checkLogin();
    return res;
  }

  Future<void> updateRoleDB(String role, String userid) async {
    await DatabaseHelper.instance.updateRole(role, userid);
  }

  Future<void> getUser() async {
    var res = await DatabaseHelper.instance.getUser();
  }

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
      print('Sign-in with email and password failed: $e');
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
      print(shop.docs[0].data());
      // Shop s = Shop.fromMap(shop.docs[0]);
      Shop s = Shop.fromJson(shop.docs[0].data());
      print(s.password);
      var map = {
        'userID': s.shopID,
        // 'password': s.password,
        'email': s.email,
        'role': 'shop',
      };
      await DatabaseHelper.instance.loginUser(map);
      return s;
    }
    return null;
  }

  Future<void> registerMember(Map<String, dynamic> data) async {
    await fireStoreInstance
        .collection('member')
        .doc(data['uid'])
        .set({
          'email': data['email'],
          'memberID': data['uid'],
        })
        .then((value) => print('success registering new member'))
        .onError((error, stackTrace) {
          print('error while registering new member : $error');
        });
  }

  Future<void> registerShop(Map<String, dynamic> data) async {
    await fireStoreInstance
        .collection('shop')
        .doc(data['uid'])
        .set({
          'email': data['email'],
          'shopID': data['uid'],
        })
        .then((value) => print('success registering new user'))
        .onError((error, stackTrace) {
          print('error while registering new user : $error');
        });
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
      print('Sign-in with email and password failed: $e');
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

  Future<dynamic> getUserData(String? email) async {
    // User? user = userCredential.user;
    var member = await fireStoreInstance
        .collection('member')
        .where('email', isEqualTo: email)
        // .where('password', isEqualTo: '')
        // .where('uid', isEqualTo: user?.uid.toString())
        .get();

    var shop = await fireStoreInstance
        .collection('shop')
        .where('email', isEqualTo: email)
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
    return null;
  }

  Future<dynamic> googleLogin() async {
    try {
      _googleUser = await googleSignIn.signIn().onError((error, stackTrace) {
        print(error);
      });

      print('_googleUser : ${_googleUser != null}');
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
      return await getUserData(userCredential.user!.email);
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
    print('current user : ${FirebaseAuth.instance.currentUser}');
  }
}
