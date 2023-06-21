import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/helper/location.dart';
import 'package:skripsiii/model/memberModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/loginPage.dart';
import 'package:skripsiii/view/registerPage.dart';
import 'package:skripsiii/widget/button36x220.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final LoginController loginController = Get.find<LoginController>();
  final MemberController memberController = Get.find<MemberController>();
  final ShopController shopController = Get.find<ShopController>();

  Future<String?> googleLogin() async {
    var x = await loginController.googleLogin();
    if (x.runtimeType == Member) {
      var location = await LocationHelper.instance.getCurrentLocation();
      x.latitude = location.latitude;
      x.longitude = location.longitude;
      memberController.member.value = x;
      return 'member';
    } else if (x.runtimeType == Shop) {
      shopController.shop.value = x;
      return 'shop';
    } else if (x == null) {
      return null;
    }
    // TODO user is not finished to fill all required data
    else {
      return 'error';
    }
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
      barrierDismissible: true,
    );
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return const AlertDialog(
      title: Center(child: Text('Please pick an account')),
      // content: Text('Please check your email and password'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text(
                  'Welcome To',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'GigaBites',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 164, 91, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(
              height: 70,
            ),
            Button36x220(
              text: 'Login',
              func: () {
                Navigator.push(
                    context,
                    SlideFadeTransition(
                      child: const LoginPage(),
                    ));
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Button36x220(
              text: 'Register',
              func: () {
                Navigator.push(
                  context,
                  SlideFadeTransition(
                    child: const RegisterPage(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('continue with google'),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              style: const ButtonStyle(
                shadowColor: MaterialStatePropertyAll<Color>(Colors.black),
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              ),
              onPressed: () async {
                await EasyLoading.show(
                  dismissOnTap: false,
                  maskType: EasyLoadingMaskType.black,
                );
                var u = await googleLogin();
                if (mounted) {
                  if (u == 'error') {
                    EasyLoading.dismiss();
                    await _showExitDialog(context);
                  } else if (u == 'member') {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      botNavRouteMember,
                      (route) => false,
                    );
                  } else if (u == 'shop') {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      botNavRouteShop,
                      (route) => false,
                    );
                  } else if (u == null) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  } else {
                    // // TODO have to complete filling data first (role)
                    // // await _showExitDialog(context);
                    // if (mounted) {
                    //   // EasyLoading.dismiss();
                    //   // Navigator.of(context).pop();
                    //   // Navigator.popUntil(context, (route) => route.isFirst);
                    // }
                  }
                }
                // EasyLoading.dismiss();
              },
              icon: Image.asset(
                'data/images/googleIcon.png',
                width: 25,
                height: 25,
              ),
              label: const Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
