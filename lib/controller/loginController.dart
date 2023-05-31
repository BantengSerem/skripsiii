import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skripsiii/helper/databaseHelper.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/model/userModel.dart';

class LoginController extends GetxController {
  final fireStoreInstance = FirebaseFirestore.instance;
  late final GoogleSignInAuthentication googleSignInAuthentication;
  late GoogleSignInAccount? googleSignInAccount;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> checkLogin() async {
    bool res = await DatabaseHelper.instance.checkLogin();
    return res;
  }

  Future<void> getUser() async {
    var res = await DatabaseHelper.instance.getUser();
  }

  Future<void> logout() async{
    await DatabaseHelper.instance.logoutUser();
    // Get.offAll(() => LoginPage(), binding: HomeBinding());
  }

  Future<User?> manualLogin(Map<String, dynamic> data) async {
    var member = await fireStoreInstance
        .collection('member')
        .where('email', isEqualTo: data['email'])
        .where('password', isEqualTo: data['password'])
        .get();

    var shop = await fireStoreInstance
        .collection('shop')
        .where('email', isEqualTo: data['email'])
        .where('password', isEqualTo: data['password'])
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
      print(shop.docs[0].data());
      // Shop s = Shop.fromMap(shop.docs[0]);
      Shop s = Shop.fromJson(shop.docs[0].data());
      print(s.password);
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

  Future<bool> googleLogin(Map<String, dynamic> data) async {
    await googleSignIn
        .signIn()
        .then((value) => googleSignInAccount = value)
        .onError((error, stackTrace) {
      print(error);
    });

    // print('googleSignInAccount : ${googleSignInAccount == null}');
    // if (googleSignInAccount == null)
    //   return null;
    // else {
    //   googleSignInAuthentication = await googleSignInAccount.authentication;
    //
    //   final AuthCredential credential = GoogleAuthProvider.credential(
    //     accessToken: googleSignInAuthentication.accessToken,
    //     idToken: googleSignInAuthentication.idToken,
    //   );
    //
    //   try {
    //     final UserCredential userCredential =
    //     await auth.signInWithCredential(credential);
    //
    //     userGoogle = userCredential.user;
    //   } on FirebaseAuthException catch (e) {
    //     if (e.code == 'account-exists-with-different-credential') {
    //       await EasyLoading.showError(
    //           'The account already exists with a different credential',
    //           dismissOnTap: true);
    //       return null;
    //     } else if (e.code == 'invalid-credential') {
    //       await EasyLoading.showError(
    //           'Error occurred while accessing credentials. Try again.',
    //           dismissOnTap: true);
    //       return null;
    //     }
    //   } catch (e) {
    //     await EasyLoading.showError(
    //         'Error occurred using Google Sign In. Try again.',
    //         dismissOnTap: true);
    //     return null;
    //   }
    //   UserModel u = UserModel();
    //   u.email = auth.currentUser.email;
    //   u.signintype = 'google';
    //   // u.signintype = 'google';
    //   // user.value.password = null;
    //   return u;
    // }
    return false;
  }
}
