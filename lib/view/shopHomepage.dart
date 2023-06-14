import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/finalizeOrderPage.dart';
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
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                'Selling Hour',
                style: TextStyle(),
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
                        await pageVM.shopController.zeroingAllFoodQty();
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
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              // width: MediaQuery.of(context).size.width * 0.8,
              child: const Text(
                'Incoming Order',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
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
                borderRadius: BorderRadius.circular(10),
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
                      return const Center(
                        child: Text('no Data'),
                      );
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     pageVM.transactionController
      //         .test(pageVM.shopController.shop.value.shopID);
      //   },
      // ),
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

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    await transactionController
        .getAllDataShop(shopController.shop.value.shopID);
    scrollController = ScrollController();
    // print("=====================================");
    // print(transactionController.currDoc);
    // print("=====================================");
    isLoading.value = false;
  }

  void scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("reach the bottom");
      try {
        isLoading.value = true;
        await transactionController
            .getAllDataShop(shopController.shop.value.shopID);
      } catch (e) {
        print(e);
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('dispose =======================');
    transactionController.resetShopHome();
    super.dispose();
  }
}
