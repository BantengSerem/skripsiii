import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/finalizeOrderPage.dart';
import 'package:skripsiii/widget/nodata.dart';
import 'package:skripsiii/widget/restauranOrderCardList.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({Key? key}) : super(key: key);

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  late ShopHomeVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageVM = Get.put(ShopHomeVM());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<ShopHomeVM>();
  }

  @override
  Widget build(BuildContext context) {
    // ShopHomeVM pageVM = Get.put(ShopHomeVM());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Selling Hour",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Color.fromRGBO(56, 56, 56, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                              color: Color.fromARGB(171, 178, 178, 178)),
                          alignment: Alignment.center,
                          height: 30,
                          width: 60,
                          child: Text(
                            pageVM.sellingTime.value,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'To',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(56, 56, 56, 1),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                            color: Color.fromARGB(171, 178, 178, 178),
                          ),
                          alignment: Alignment.center,
                          height: 30,
                          width: 60,
                          child: Text(
                            pageVM.closingTime.value,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              // width: MediaQuery.of(context).size.width * 0.8,
              child: const Text(
                'Incoming Orders',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(56, 56, 56, 1),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 500,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              // width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(
                () {
                  if (pageVM.isLoading.value) {
                    return Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.lightBlue,
                        size: 50,
                      ),
                    );
                  } else {
                    if (pageVM.transactionController.listItem.isEmpty) {
                      return const NoDataWidget();
                    } else {
                      return ListView.builder(
                        controller: pageVM.scrollController,
                        itemCount: pageVM.transactionController.listItem.length,
                        itemBuilder: (context, idx) {
                          return RestaurantOrderCartList(
                            func: () async {
                              Navigator.push(
                                  context,
                                  SlideFadeTransition(
                                    child: FinalizeOrderPage(
                                      t: pageVM
                                          .transactionController.listItem[idx],
                                    ),
                                  ));
                            },
                            t: pageVM.transactionController.listItem[idx],
                          );
                        },
                      );
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShopHomeVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final ShopController shopController = Get.find<ShopController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  late ScrollController scrollController;

  RxBool isLoading = true.obs;
  RxString sellingTime = ''.obs;
  RxString closingTime = ''.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    await transactionController
        .getAllDataShop(shopController.shop.value.shopID);
    scrollController = ScrollController();
    if (shopController.shop.value.sellingTime != -1) {
      var s = shopController.shop.value.sellingTime.toString();
      var slen = s.length;
      sellingTime.value =
          '${s.substring(0, slen - 4)}.${s.substring(slen - 4, slen - 2)}';
    } else {
      sellingTime.value = '-1';
    }
    if (shopController.shop.value.closingTime != -1) {
      var c = shopController.shop.value.closingTime.toString();
      var clen = c.length;
      closingTime.value =
          '${c.substring(0, clen - 4)}.${c.substring(clen - 4, clen - 2)}';
    } else {
      closingTime.value = '-1';
    }
    isLoading.value = false;
  }

  void scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      try {
        isLoading.value = true;
        await transactionController
            .getAllDataShop(shopController.shop.value.shopID);
      } catch (e) {
        isLoading.value = false;
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    transactionController.resetShopHome();
    super.dispose();
  }
}
