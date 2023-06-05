import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/widget/button';
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
            const Text(
              'Welcome To \n [App Name]',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 70,
            ),
            Button36x220(
              text: 'Login',
              func: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Button36x220(
              text: 'Register',
              func: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
