import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skripsiii/binding/homeBinding.dart';
import 'package:skripsiii/constants/route.dart';
import 'package:skripsiii/view/bottomNavigationBarPage.dart';
import 'package:skripsiii/view/browseRestaurantPage.dart';
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
      initialRoute: splashScrRoute,
      // initialRoute: getCurrentUser() != null ? botNavRoute : welcomeRoute,

      routes: {
        welcomeRoute: (context) => const WelcomePage(),
        loginRoute: (context) => const LoginPage(),
        homeRoute: (context) =>  HomePage(),
        registerRoute: (context) => const RegisterPage(),
        botNavRoute: (context) => BottomNavigationPage(),
        splashScrRoute: (context) => const SplashScreenPage(),
        // browseRoute: (context) => BrowseRestaurantPage(title: title),
      },
      initialBinding: HomeBinding(),
    );
  }
}
//
// class MapSample extends StatefulWidget {
//   const MapSample({super.key});
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//
//   static const Marker _marker = Marker(
//     markerId: MarkerId('userPosition'),
//     infoWindow: InfoWindow(title: 'you position'),
//     icon: BitmapDescriptor.defaultMarker,
//     position: LatLng(37.42796133580664, -122.085749655962),
//   );
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         markers: {
//           _marker
//         },
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
