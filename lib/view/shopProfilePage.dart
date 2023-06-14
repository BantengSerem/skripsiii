import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/bottomNavigationBarPage.dart';
import 'package:skripsiii/view/restaurantUpdatePage.dart';
import 'package:skripsiii/view/settingsPage.dart';
import 'package:skripsiii/view/shopHistoryPage.dart';
import 'package:skripsiii/view/shopHomepage.dart';
import 'package:skripsiii/view/welcomePage.dart';
import 'package:skripsiii/widget/profileButton.dart';

class ShopProfilePage extends StatefulWidget {
  const ShopProfilePage({Key? key}) : super(key: key);

  @override
  State<ShopProfilePage> createState() => _ShopProfilePageState();
}

class _ShopProfilePageState extends State<ShopProfilePage> {

  late ShopProfileVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageVM = Get.put(ShopProfileVM());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<ShopProfileVM>();
  }
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
              await pageVM.loginController.logout();
              if (mounted) {
                pageVM.foodController.reset();
                pageVM.shopController.reset();
                pageVM.memberController.reset();
                pageVM.transactionController.reset();
                Get.delete<BottomNavController>();
                Get.delete<ShopHomeVM>();
                Get.delete<ShopHistoryVM>();
                Get.delete<ShopProfileVM>();
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
                          pageVM.shopController.shop.value.shopName,
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
                          pageVM.shopController.shop.value.email,
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
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Obx(
                () {
                  return Text(
                    'Your shop is ${pageVM.shopController.shop.value.isOpen == 'false' ? 'Close' : 'Open'} now',
                    style: const TextStyle(fontSize: 20),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Container(
                    height: 35,
                    width: 90,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Colors.red,
                        ),
                      ),
                      child: const Text('Close'),
                      onPressed: () async {
                        await pageVM.shopController.closeShop();
                        // pageVM.shopController.shop.value.isOpen = 'false';
                        await pageVM.shopController.zeroingAllFoodQty();
                        setState(() {
                          // pageVM.shopController.shop.value.isOpen = 'false';
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 35,
                    width: 90,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Colors.green,
                        ),
                      ),
                      child: const Text('Open'),
                      onPressed: () async {
                        await pageVM.shopController.openShop();
                        // pageVM.shopController.shop.value.isOpen = 'true';
                        setState(() {
                          // pageVM.shopController.shop.value.isOpen = 'true';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.5,indent: 20,endIndent: 20,
            ),
            ProfileButton(
              func: () async {
                Navigator.of(context).push(
                  SlideFadeTransition(
                    child: const RestaurantMenuPage(),
                  ),
                );
              },
              title: 'Add New Menu',
            ),
            ProfileButton(
                func: () async {
                  Navigator.of(context).push(
                    SlideFadeTransition(
                      child: const SettingsPage(),
                    ),
                  );
                },
                title: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class ShopProfileVM extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();
  final ShopController shopController = Get.find<ShopController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
}
