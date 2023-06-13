import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/oderSharedFoodPage.dart';
import 'package:skripsiii/widget/historyCard.dart';

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
    Get.delete<FindFoodVM>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Food'),
      ),
      body: Container(
        child: Obx(() {
          if (pageVM.isLoading.value) {
            return Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Colors.lightBlue,
                size: 50,
              ),
            );
          } else {
            if (pageVM.foodController.shareFoodList.isEmpty) {
              return const Center(
                child: Text('no data'),
              );
            } else {
              return ListView.builder(
                itemCount: pageVM.foodController.shareFoodList.length,
                itemBuilder: (context, idx) {
                  return HistoryCard(
                    func: () async {
                      var sf = pageVM.foodController.shareFoodList[idx];
                      Navigator.of(context).push(
                        SlideFadeTransition(
                          child: OrderedSharedFoodPage(
                            sf:sf,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(pageVM.foodController.shareFoodList);
        },
      ),
    );
  }
}

class FindFoodVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final MemberController memberController = Get.find<MemberController>();

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    foodController.getSharedFoodList(memberController.member.value.memberID);
    isLoading.value = false;
  }

  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete {
    foodController.reset();

    return super.onDelete;
  }
}
