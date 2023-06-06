import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skripsiii/binding/homeBinding.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/loginPage.dart';
import 'package:skripsiii/view/welcomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Get.lazyPut<LoginController>(() => LoginController(), fenix: true);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Get.to(HomePage(), binding: HomeBinding());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
          name: '/',
          page: () => WelcomePage(),
          // binding: HomeBinding(),
        ),
      ],
      routes: {
        loginRoute: (context) => LoginPage(),
        homeRoute: (context) => HomePage()
      },
      initialBinding: HomeBinding(),
    );
  }
}
