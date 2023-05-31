import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/loginController.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.find<LoginController>();

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
                // Map<String, dynamic> map = {
                //   'email': '321@test.com',
                //   'password': '321',
                // };
                Map<String, dynamic> map = {
                  'email': 'member123@test.com',
                  'password': '123456',
                };
                await loginController.signInWithEmailPassword(
                    email: 'member123@test.com', password: '123456');
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
          ],
        ),
      ),
    );
  }
}
