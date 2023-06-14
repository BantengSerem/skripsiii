import 'dart:math';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/helper/location.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/view/bottomNavigationBarPage.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/registerPage.dart';
import 'package:skripsiii/view/welcomePage.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  final LoginController loginController = Get.find<LoginController>();
  final MemberController memberController = Get.find<MemberController>();
  final ShopController shopController = Get.find<ShopController>();

  getCurrentUser() {
    var user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: Image.asset(
        'data/images/splashImage.png',
        width: Get.width * 0.6,
        height: Get.height * 0.4,
      ),
      splashIconSize: 700,
      screenFunction: () async {
        var res = getCurrentUser();
        bool ch = await loginController.checkLogin();
        if (res != null && ch) {
          var data = await loginController.getUserEmailRoleAndUid();
          if (data['role'] == null) return const RegisterPage();
          if (data['role'] == 'member') {
            var m = await loginController.getMemberData(data['email']);
            var location = await LocationHelper.instance.getCurrentLocation();
            m.latitude = location.latitude;
            m.longitude = location.longitude;
            print("this is splash for member : $m");
            memberController.member.value = m;
          } else if (data['role'] == 'shop') {
            var s = await loginController.getShopData(data['email']);
            print("this is splash for shop : $s");
            shopController.shop.value = s;
          }
          print('user role : ${data['role']}');
          return BottomNavigationPage(
            userType: data['role'],
          );
        } else {
          return const WelcomePage();
        }
        // var res = await userController.checkLogin();
        // if (res) {
        //   await userController.getUser();
        //   return AppBottomNavigationBar();
        // } else
        //   return LoginPage();
      },
      duration: 2000,
      // backgroundColor: Theme.of(context).,
      centered: true,
      splashTransition: SplashTransition.scaleTransition,
      animationDuration: const Duration(milliseconds: 2000),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }
}
