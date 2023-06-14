import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/bottomNavigationBarPage.dart';
import 'package:skripsiii/view/restaurantUpdatePage.dart';
import 'package:skripsiii/view/shopHomepage.dart';
import 'package:skripsiii/view/welcomePage.dart';
import 'package:skripsiii/widget/profileButton.dart';

class ShopProfilePage extends StatefulWidget {
  const ShopProfilePage({Key? key}) : super(key: key);

  @override
  State<ShopProfilePage> createState() => _ShopProfilePageState();
}

class _ShopProfilePageState extends State<ShopProfilePage> {
  final LoginController loginController = Get.find<LoginController>();
  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();
  final ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Restaurant Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await loginController.logout();
              if (mounted) {
                foodController.reset();
                shopController.reset();
                memberController.reset();
                Get.delete<BottomNavController>();
                Get.delete<ShopHomeVM>();
                // Get.delete<HomePageVM>();
                Get.offAll(const WelcomePage());
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil(welcomeRoute, (route) => false);
              }
            },
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // color: Colors.red,
              height: 150,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 20, top: 10, bottom: 10, right: 10),
                    // color: Colors.yellow,
                    height: 130,
                    width: 130,
                    child: Image.asset(
                      'data/images/profileIcon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(
                        () => Text(
                          shopController.shop.value.shopName,
                          style: const TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(
                        () => Text(
                          shopController.shop.value.email,
                          style: const TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ProfileButton(
                func: () async {
                  Navigator.of(context).push(
                    SlideFadeTransition(
                      child: const RestaurantMenuPage(),
                    ),
                  );
                },
                title: 'Add New Menu'),
          ],
        ),
      ),
    );
  }
}
