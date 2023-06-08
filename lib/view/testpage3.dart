import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';

class TestPage3 extends StatelessWidget {
  TestPage3({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.find<LoginController>();
  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();

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
            ElevatedButton(
              onPressed: () async {
                await loginController.signInWithEmailPassword(
                    email: 'member123@test.com', password: '123456');
                Map<String, dynamic> map = {
                  'email': 'member123@test.com',
                  'password': '123456',
                };
                var u = await loginController.manualLogin(map);
                print(u);
                // print('${u?.password} ${u?.email}');
              },
              child: const Text('login'),
            ),
            ElevatedButton(
              onPressed: () async {
                await loginController.logout();
              },
              child: const Text('logout'),
            ),
            ElevatedButton(
              onPressed: () async {
                await loginController.checkLogin();
              },
              child: const Text('check login'),
            ),
            ElevatedButton(
              onPressed: () async {
                await loginController.getUser();
              },
              child: const Text('get user'),
            ),
            ElevatedButton(
              onPressed: () async {
                await loginController.googleLogin();
              },
              child: const Text('google login'),
            ),
            ElevatedButton(
              onPressed: () async {
                var userCred = await loginController.firebaseLogOut();
              },
              child: const Text('google logout'),
            ),
            ElevatedButton(
              onPressed: () async {
                loginController.test();
              },
              child: const Text('test google login'),
            ),
            ElevatedButton(
              onPressed: () async {
                foodController.test();
              },
              child: const Text('test food controller'),
            ),
            ElevatedButton(
              onPressed: () async {
                print(memberController.member);
              },
              child: const Text('test member controller'),
            ),
            ElevatedButton(
              onPressed: () async {
                var a = await loginController.getUserEmailRoleAndUid();
                print(a);
              },
              child: const Text('test getUserEmailAndUid'),
            ),
          ],
        ),
      ),
    );
  }
}

// SnbHf89VLIeyzF84C5OHxMj0vZA2
