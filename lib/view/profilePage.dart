import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';
import 'package:skripsiii/model/sharedFoodModel.dart';
import 'package:skripsiii/view/FindFoodPage.dart';
import 'package:skripsiii/view/bottomNavigationBarPage.dart';
import 'package:skripsiii/view/historyPage.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/welcomePage.dart';
import 'package:skripsiii/widget/nodata.dart';
import 'package:skripsiii/widget/profileSharedCartList.dart';

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

  Future<void> alertCanceled(
      {required BuildContext context, required SharedFood sf}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            textAlign: TextAlign.center,
            'Confirm to cancel this order',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
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
                Navigator.of(context).pop();
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
                'Confirm',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () async {
                await EasyLoading.show(
                  dismissOnTap: false,
                  maskType: EasyLoadingMaskType.clear,
                );
                var res = await pageVM.foodController.deleteSharedFoodData(sf);
                EasyLoading.dismiss();
                if (res) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Share food has been deleted'),
                    ));
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Something went wrong'),
                    ));
                  }
                }
                if (mounted) {
                  Navigator.pop(context);
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
          'Profile',
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
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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
                    color: const Color.fromRGBO(56, 56, 56, 1),
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
                        color: Color.fromRGBO(56, 56, 56, 1),
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
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
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Email',
                      style: TextStyle(
                        color: Color.fromRGBO(56, 56, 56, 1),
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
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
              'My shared Food',
              style: TextStyle(
                color: Color.fromRGBO(56, 56, 56, 1),
                fontSize: 23,
                fontWeight: FontWeight.w900,
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
            child: Obx(() {
              if (pageVM.foodController.shareMemberFoodList.isNotEmpty) {
                return ListView.builder(
                  controller: pageVM.scrollController,
                  itemCount: pageVM.foodController.shareMemberFoodList.length,
                  itemBuilder: (context, idx) {
                    return ProfileSharedCartList(
                      sf: pageVM.foodController.shareMemberFoodList[idx],
                      func: () async {
                        await alertCanceled(
                          context: context,
                          sf: pageVM.foodController.shareMemberFoodList[idx],
                        );
                      },
                    );
                  },
                );
              } else {
                return const NoDataWidget();
              }
            }),
          )
        ],
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
    foodController.resetProfileSharedFood();
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
      try {
        isLoading.value = true;
        await foodController
            .getMemberShareFoodList(memberController.member.value.memberID);
      } catch (e) {
        isLoading.value = false;
      } finally {
        isLoading.value = false;
      }
    }
  }
}
