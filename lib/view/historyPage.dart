import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';
import 'package:skripsiii/model/transctionShareFood.dart';
import 'package:skripsiii/widget/historyCartListShareFoodBuy.dart';
import 'package:skripsiii/widget/historyCartListSharedFood.dart';
import 'package:skripsiii/widget/historyListCard.dart';
import 'package:skripsiii/widget/nodata.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoryPageVM pageVM = Get.put(HistoryPageVM());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
        elevation: 0,
      ),
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              color: const Color.fromRGBO(255, 164, 91, 1),
              height: 50,
              child: Row(
                children: [
                  const SizedBox(
                    width: 25,
                  ),
                  Obx(
                    () => TextButton(
                      onPressed: () {
                        if (pageVM.currButton.value != 0) {
                          pageVM.buttonPressed(0);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: pageVM.activeButton[0]
                            ? const MaterialStatePropertyAll<Color>(
                                Colors.black)
                            : const MaterialStatePropertyAll<Color>(
                                Colors.black26),
                      ),
                      child: Text(
                        'Buy',
                        style: TextStyle(
                          color: pageVM.activeButton[0]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Obx(
                    () => TextButton(
                      onPressed: () {
                        if (pageVM.currButton.value != 1) {
                          pageVM.buttonPressed(1);
                        }
                        pageVM.activeButton[1];
                      },
                      style: ButtonStyle(
                        backgroundColor: pageVM.activeButton[1]
                            ? const MaterialStatePropertyAll<Color>(
                                Colors.black)
                            : const MaterialStatePropertyAll<Color>(
                                Colors.black26),
                      ),
                      child: Text(
                        'Shared Food',
                        style: TextStyle(
                          color: pageVM.activeButton[1]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Obx(
                    () => TextButton(
                      onPressed: () {
                        if (pageVM.currButton.value != 2) {
                          pageVM.buttonPressed(2);
                        }
                        pageVM.activeButton[2];
                      },
                      style: ButtonStyle(
                        backgroundColor: pageVM.activeButton[2]
                            ? const MaterialStatePropertyAll<Color>(
                                Colors.black)
                            : const MaterialStatePropertyAll<Color>(
                                Colors.black26),
                      ),
                      child: Text(
                        'Buy Shared Food',
                        style: TextStyle(
                          color: pageVM.activeButton[2]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (pageVM.isLoading.value) {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.lightBlue,
                  size: 50,
                ),
              );
            } else {
              if (pageVM.currButton.value == 0) {
                if (pageVM.transactionController.listHistoryItem.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount:
                          pageVM.transactionController.listHistoryItem.length,
                      itemBuilder: (context, idx) {
                        return HistoryListCardBuy(
                            t: pageVM
                                .transactionController.listHistoryItem[idx]);
                      },
                    ),
                  );
                } else {
                  return const Expanded(child: NoDataWidget());
                }
              } else if (pageVM.currButton.value == 1) {
                if (pageVM.sellSharedFoodMemberList.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: pageVM.sellSharedFoodMemberList.length,
                      itemBuilder: (context, idx) {
                        return HistoryCartListShareFoodSell(
                            tsf: pageVM.sellSharedFoodMemberList[idx]);
                      },
                    ),
                  );
                } else {
                  return const Expanded(child: NoDataWidget());
                }
              } else {
                if (pageVM.buySharedFoodMemberList.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: pageVM.buySharedFoodMemberList.length,
                      itemBuilder: (context, idx) {
                        return HistoryCartListShareFoodBuy(
                          tsf: pageVM.buySharedFoodMemberList[idx],
                        );
                      },
                    ),
                  );
                } else {
                  return const Expanded(child: NoDataWidget());
                }
              }
            }
          }),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     pageVM.transactionController.getSellSharedFoodMember(
      //         pageVM.memberController.member.value.memberID);
      //   },
      // ),
    );
  }
}

class HistoryPageVM extends GetxController {
  RxList<bool> activeButton = [true, false, false].obs;
  RxInt currButton = 0.obs;
  RxBool isLoading = false.obs;

  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();
  final ShopController shopController = Get.find<ShopController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  RxBool isLoading1 = true.obs;
  late ScrollController scrollController;

  List<TransactionShareFoodModel> sellSharedFoodMemberList =
      RxList<TransactionShareFoodModel>();
  List<TransactionShareFoodModel> buySharedFoodMemberList =
      RxList<TransactionShareFoodModel>();

  Future<void> buttonPressed(int i) async {
    activeButton[currButton.value] = false;
    activeButton[i] = true;
    currButton.value = i;
    if (i == 0) {
      transactionController.resetShopHistory();
      await transactionController
          .getMemberHistoryList(memberController.member.value.memberID);
    } else if (i == 1) {
      sellSharedFoodMemberList = await transactionController
          .getSellSharedFoodMember(memberController.member.value.memberID);
    } else if (i == 2) {
      buySharedFoodMemberList = await transactionController
          .getBuySharedFoodMember(memberController.member.value.memberID);
    }
    // print(activeButton);
  }

// Future<void> init1() async {
//   isLoading.value = true;
//   await transactionController.getMemberHistoryList(shopID)
// }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    transactionController.resetShopHistory();
    await transactionController
        .getMemberHistoryList(memberController.member.value.memberID);
  }
}
