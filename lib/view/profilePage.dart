import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';
import 'package:skripsiii/view/FindFoodPage.dart';
import 'package:skripsiii/view/bottomNavigationBarPage.dart';
import 'package:skripsiii/view/historyPage.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/welcomePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    pageVM = Get.put(ProfileVM());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<ProfileVM>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Account'),
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
                Get.delete<HistoryPageVM>();
                Get.delete<HomePageVM>();
                Get.delete<FindFoodVM>();
                Get.delete<ProfileVM>();
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
                          pageVM.memberController.member.value.username,
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
                          pageVM.memberController.member.value.email,
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
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: const Text(
                'Shared Food',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.5,
              endIndent: 20,
              indent: 20,
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: pageVM.scrollController,
                  itemCount: pageVM.foodController.shareMemberFoodList.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      height: 80,
                      color: Colors.red,
                      child: Text(
                        '${pageVM.foodController.shareMemberFoodList[idx].sharedFoodName} and ${pageVM.foodController.shareMemberFoodList[idx].status}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(pageVM.foodController.streamMemberShareFoodList);
        },
      ),
    );
  }
}

class ProfileVM extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();
  final ShopController shopController = Get.find<ShopController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  ScrollController scrollController = ScrollController();

  RxBool isLoading = true.obs;

  @override
  void onInit() async {
    // TODO: implement onInit

    isLoading.value = true;
    await foodController
        .getMemberShareFoodList(memberController.member.value.memberID);
    // scrollController = ScrollController();
    super.onInit();
    isLoading.value = false;
  }

  void scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("reach the bottom");
      try {
        isLoading.value = true;
        await foodController
            .getMemberShareFoodList(memberController.member.value.memberID);
      } catch (e) {
        print(e);
      } finally {
        isLoading.value = false;
      }
    }
  }
}
