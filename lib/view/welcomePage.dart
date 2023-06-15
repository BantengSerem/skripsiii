import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/bottomNavigationBarPage.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/loginPage.dart';
import 'package:skripsiii/view/registerPage.dart';
import 'package:skripsiii/widget/button36x220.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children:  const [
                Text(
                  'Welcome To',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Center(
                //   child: ShaderMask(
                //     shaderCallback: (Rect bounds) {
                //       return const LinearGradient(
                //         colors: [Color.fromRGBO(255, 164, 91, 1), Colors.blue],
                //         begin: Alignment.centerLeft,
                //         end: Alignment.centerRight,
                //       ).createShader(bounds);
                //     },
                //     child: const Text(
                //       'GigaBites',
                //       style: TextStyle(
                //         fontSize: 44,
                //         fontWeight: FontWeight.bold,
                //         color: Color.fromRGBO(255, 164, 91, 1),
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
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
            // Button36x220(
            //   text: 'Register',
            //   func: () {
            //     final a = Get.find<BottomNavController>();
            //     final b = Get.find<HomePageVM>();
            //     print(a.idx);
            //     print(b.isLoadingSellingSoon);
            //     // Navigator.push(
            //     //   context,
            //     //   SlideFadeTransition(
            //     //     child: const RegisterPage(),
            //     //   ),
            //     // );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
