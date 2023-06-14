import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/oderSharedFoodPage.dart';
import 'package:skripsiii/widget/historyCard.dart';
import 'package:skripsiii/widget/nodata.dart';

class FindFoodPage extends StatefulWidget {
  const FindFoodPage({Key? key}) : super(key: key);

  @override
  State<FindFoodPage> createState() => _FindFoodPageState();
}

class _FindFoodPageState extends State<FindFoodPage> {
  late final FindFoodVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    // var a = RestaurantOrderMenuVM(shop: widget.shop);
    pageVM = Get.put(FindFoodVM());

    // pageVM.shop = widget.shop;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<FindFoodVM>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Food',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
      ),
      body: Obx(() {
        if (pageVM.isLoading.value) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.lightBlue,
              size: 50,
            ),
          );
        } else {
          if (pageVM.foodController.shareFoodList.isEmpty) {
            return const NoDataWidget();
          } else {
            return ListView.builder(
              controller: pageVM.scrollController,
              itemCount: pageVM.foodController.shareFoodList.length,
              itemBuilder: (context, idx) {
                return HistoryCard(
                  func: () async {
                    var sf = pageVM.foodController.shareFoodList[idx];
                    Navigator.of(context).push(
                      SlideFadeTransition(
                        child: OrderedSharedFoodPage(
                          sf: sf,
                        ),
                      ),
                    );
                  },
                  sf: pageVM.foodController.shareFoodList[idx],
                );
              },
            );
          }
        }
      }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // print(pageVM.foodController.shareFoodList);
      //     print(pageVM.foodController.shareFoodList);
      //   },
      // ),
    );
  }
}

class FindFoodVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();

  late ScrollController scrollController;
  RxBool isLoading = true.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    await foodController
        .getSharedFoodList(memberController.member.value.memberID);
    scrollController = ScrollController();
    isLoading.value = false;
  }

  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete {
    foodController.resetShareFoodPage();

    return super.onDelete;
  }

  void scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("reach the bottom");
      try {
        isLoading.value = true;
        await foodController
            .getSharedFoodList(memberController.member.value.memberID);
      } catch (e) {
        print(e);
      } finally {
        isLoading.value = false;
      }
    }
  }
}
