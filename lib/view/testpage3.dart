import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/view/welcomePage.dart';

class TestPage3 extends StatefulWidget {
  const TestPage3({Key? key}) : super(key: key);

  @override
  State<TestPage3> createState() => _TestPage3State();
}

class _TestPage3State extends State<TestPage3> {
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.find<LoginController>();
  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();
  final ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () async {
            //     await loginController.signInWithEmailPassword(
            //         email: 'member123@test.com', password: '123456');
            //     Map<String, dynamic> map = {
            //       'email': 'member123@test.com',
            //       'password': '123456',
            //     };
            //     var u = await loginController.manualLogin(map);
            //     print(u);
            //     // print('${u?.password} ${u?.email}');
            //   },
            //   child: const Text('login'),
            // ),
            ElevatedButton(
              onPressed: () async {
                await loginController.logout();
                foodController.reset();
                shopController.reset();
                memberController.reset();
                if (mounted) {
                  Get.offAll(const WelcomePage());
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil(welcomeRoute, (route) => false);
                }
              },
              child: const Text('logout'),
            ),
            ElevatedButton(
                onPressed: () async {
                  await shopController.test();
                },
                child: const Text('test')),
            // ElevatedButton(
            //   onPressed: () async {
            //     await loginController.checkLogin();
            //   },
            //   child: const Text('check login'),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await loginController.getUser();
            //   },
            //   child: const Text('get user'),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await loginController.googleLogin();
            //   },
            //   child: const Text('google login'),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     var userCred = await loginController.firebaseLogOut();
            //   },
            //   child: const Text('google logout'),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     loginController.test();
            //   },
            //   child: const Text('test google login'),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     foodController.test();
            //   },
            //   child: const Text('test food controller'),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     print(memberController.member);
            //   },
            //   child: const Text('test member controller'),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     var a = await loginController.getUserEmailRoleAndUid();
            //     print(a);
            //   },
            //   child: const Text('test getUserEmailAndUid'),
            // ),
          ],
        ),
      ),
    );
  }
}
