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

  // final ShopProfileVM pageVM;
  @override
  State<ShopProfilePage> createState() => _ShopProfilePageState();
}

class _ShopProfilePageState extends State<ShopProfilePage> {
  final ShopProfileVM pageVM = Get.put(ShopProfileVM());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // pageVM = widget.pageVM;
    // pageVM = Get.put(ShopProfileVM());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Get.delete<ShopProfileVM>();
  }

  Future<void> alertClose({required BuildContext context}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            textAlign: TextAlign.left,
            'All food quantity will be 0 when closing the shop',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          // content: const Text('Confirm closing'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(
                  width: 1.0,
                  color: Color.fromRGBO(56, 56, 56, 1),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(
                  width: 1.0,
                  color: Color.fromRGBO(56, 56, 56, 1),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () async {
                await pageVM.shopController.closeShop();
                await pageVM.shopController.zeroingAllFoodQty();
                if (mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
        title: const Text(
          'Restaurant Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
        actions: [
          Container(
            width: 90,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 218, 119, 1),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: TextButton(
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
                }
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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
                    color: const Color.fromRGBO(56, 56, 56, 1),
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
                        color: Color.fromRGBO(56, 56, 56, 1),
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
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(56, 56, 56, 1),
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
            child: Row(
              children: [
                const Text(
                  'Your shop is ',
                  style: TextStyle(fontSize: 18),
                ),
                Obx(
                  () {
                    var s = pageVM.isOpen.value ? 'OPEN' : 'CLOSE';
                    return Text(
                      s,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const Text(
                  ' now',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                SizedBox(
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
                      pageVM.isOpen.value = false;
                      await alertClose(context: context);
                      // await pageVM.shopController.closeShop();
                      // // // pageVM.shopController.shop.value.isOpen = 'false';
                      // await pageVM.shopController.zeroingAllFoodQty();
                      // setState(() {
                      //   // pageVM.shopController.shop.value.isOpen = 'false';
                      // });
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
                      pageVM.isOpen.value = true;
                      await pageVM.shopController.openShop();
                      // // pageVM.shopController.shop.value.isOpen = 'true';
                      // setState(() {
                      //   // pageVM.shopController.shop.value.isOpen = 'true';
                      // });
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
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
                    child: const SellingTimeSettingsPage(),
                  ),
                );
              },
              title: 'Selling Time Setting'),
        ],
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

  RxBool isOpen = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    isOpen.value = shopController.shop.value.isOpen == 'false' ? false : true;
    super.onInit();
  }
}
