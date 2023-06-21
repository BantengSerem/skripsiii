import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';
import 'package:skripsiii/widget/nodata.dart';
import 'package:skripsiii/widget/restauranOrderCardList.dart';

class ShopHistoryPage extends StatefulWidget {
  const ShopHistoryPage({Key? key, required this.pageVM}) : super(key: key);
  final ShopHistoryVM pageVM;
  @override
  State<ShopHistoryPage> createState() => _ShopHistoryPageState();
}

class _ShopHistoryPageState extends State<ShopHistoryPage> {
  late final ShopHistoryVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageVM = widget.pageVM;
    // pageVM = Get.put(ShopHistoryVM());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Get.delete<ShopHistoryVM>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
      ),
      body: Obx(
        () {
          if (pageVM.isLoading.value) {
            return Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Colors.lightBlue,
                size: 50,
              ),
            );
          } else {
            if (pageVM.transactionController.listHistoryItem.isEmpty) {
              return const NoDataWidget();
            } else {
              return ListView.builder(
                controller: pageVM.scrollController,
                itemCount: pageVM.transactionController.listHistoryItem.length,
                itemBuilder: (context, idx) {
                  return RestaurantOrderCartList(
                    func: () async {},
                    t: pageVM.transactionController.listHistoryItem[idx],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

class ShopHistoryVM extends GetxController {
  final ShopController shopController = Get.find<ShopController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  RxBool isLoading = true.obs;
  late ScrollController scrollController;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    await transactionController
        .getShopHistoryList(shopController.shop.value.shopID);
    scrollController = ScrollController();
    isLoading.value = false;
  }

  void scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      try {
        isLoading.value = true;
        await transactionController
            .getShopHistoryList(shopController.shop.value.shopID);
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
    transactionController.resetShopHistory();
    super.dispose();
  }
}
