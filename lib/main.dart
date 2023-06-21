import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:skripsiii/binding/homeBinding.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/view/bottomNavigationBarPage.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/loginPage.dart';

import 'package:skripsiii/view/registerPage.dart';

import 'package:skripsiii/view/splashScreen.dart';

import 'package:skripsiii/view/welcomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // getCurrentUser() {
  //   var user = FirebaseAuth.instance.currentUser;
  //   return user;
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // home: const MapSample(),
      // initialRoute: 'test',
      // initialRoute: botNavRoute,
      initialRoute: splashScrRoute,
      routes: {
        welcomeRoute: (context) => const WelcomePage(),
        loginRoute: (context) => const LoginPage(),
        // homeRoute: (context) => HomePage(),
        registerRoute: (context) => const RegisterPage(),
        botNavRouteMember: (context) =>
            BottomNavigationPage(userType: 'member'),
        botNavRouteShop: (context) => BottomNavigationPage(userType: 'shop'),
        splashScrRoute: (context) => const SplashScreenPage(),
        // 'test': (context) => const Test3(),
        // browseRoute: (context) => BrowseRestaurantPage(title: title),
      },
      initialBinding: HomeBinding(),
      builder: EasyLoading.init(),
    );
  }
}
