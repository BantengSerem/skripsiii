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

  Future<UserParent?> manualLogin(Map<String, dynamic> data) async {
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

  Future<UserParent?> getUserData(UserCredential userCredential) async {
    User? user = userCredential.user;
    var member = await fireStoreInstance
        .collection('member')
        .where('email', isEqualTo: user?.email.toString())
        // .where('password', isEqualTo: '')
        // .where('uid', isEqualTo: user?.uid.toString())
        .get();

    var shop = await fireStoreInstance
        .collection('shop')
        .where('email', isEqualTo: user?.email.toString())
        // .where('password', isEqualTo: '')
        // .where('uid', isEqualTo: user?.uid.toString())
        .get();
    if (member.docs.isNotEmpty) {
      Member m = Member.fromJson(member.docs[0].data());
      var map = {
        'userID': m.memberID,
        'password': m.password,
        'email': m.email,
      };
      await DatabaseHelper.instance.loginUser(map);
      return m;
    } else if (shop.docs.isNotEmpty) {
      Shop s = Shop.fromJson(shop.docs[0].data());
      var map = {
        'userID': s.shopID,
        'password': s.password,
        'email': s.email,
      };
      await DatabaseHelper.instance.loginUser(map);
      return s;
    }
    return null;
  }

  Future<UserParent?> googleLogin() async {
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
      return await getUserData(userCredential);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    // if (googleSignInAccount != null) {
    //   googleSignInAuthentication = await googleSignInAccount!.authentication;
    //
    //   final AuthCredential credential = GoogleAuthProvider.credential(
    //     accessToken: googleSignInAuthentication.accessToken,
    //     idToken: googleSignInAuthentication.idToken,
    //   );
    //   try {
    //     final UserCredential userCredential =
    //         await FirebaseAuth.instance.signInWithCredential(credential);
    //
    //
    //     var member = await fireStoreInstance
    //         .collection('member')
    //         .where('email', isEqualTo: data['email'])
    //         .where('password', isEqualTo: data['password'])
    //         .get();
    //
    //     var shop = await fireStoreInstance
    //         .collection('shop')
    //         .where('email', isEqualTo: data['email'])
    //         .where('password', isEqualTo: data['password'])
    //         .get();
    //
    //     if(member.docs.isNotEmpty){
    //       Member m = Member.fromJson(member.docs[0].data());
    //       var map = {
    //         'userID': m.memberID,
    //         'password': m.password,
    //         'email': m.email,
    //       };
    //       await DatabaseHelper.instance.loginUser(map);
    //       return m;
    //     }else if(shop.docs.isNotEmpty){
    //       Shop s = Shop.fromJson(shop.docs[0].data());
    //       var map = {
    //         'userID': s.shopID,
    //         'password': s.password,
    //         'email': s.email,
    //       };
    //       await DatabaseHelper.instance.loginUser(map);
    //       return s;
    //     }
    //     // return userCredential.user;
    //   } on FirebaseAuthException catch (e) {
    //     if (e.code == 'account-exists-with-different-credential') {
    //       // await EasyLoading.showError(
    //       //     'The account already exists with a different credential',
    //       //     dismissOnTap: true);
    //       return null;
    //     } else if (e.code == 'invalid-credential') {
    //       // await EasyLoading.showError(
    //       //     'Error occurred while accessing credentials. Try again.',
    //       //     dismissOnTap: true);
    //       return null;
    //     }
    //   } catch (e) {
    //     // await EasyLoading.showError(
    //     //     'Error occurred using Google Sign In. Try again.',
    //     //     dismissOnTap: true);
    //     return null;
    //   }
    // }
  }

  Future<void> firebaseLogOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    _googleUser = null;
  }

  void test() {
    print('current user : ${FirebaseAuth.instance.currentUser}');
  }
}
