import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/addFoodPage.dart';
import 'package:skripsiii/view/editFoodPage.dart';
import 'package:skripsiii/widget/foodCustomListCard.dart';

class RestaurantMenuPage extends StatefulWidget {
  const RestaurantMenuPage({Key? key}) : super(key: key);

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  late final RestaurantMenuVM pageVM;

  // final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    pageVM = Get.put<RestaurantMenuVM>(RestaurantMenuVM());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<RestaurantMenuVM>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Menus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color.fromRGBO(56, 56, 56, 1),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Material(
              elevation: 5,
              child: Column(
                children: [
                  Container(
                    color: Colors.black38,
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: const Icon(Icons.photo_size_select_actual_outlined),
                  ),
                  Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pageVM.shopController.shop.value.shopName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              pageVM.shopController.shop.value.ratingAVG
                                  .toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Text(
                              'review (${pageVM.shopController.shop.value.totalReview.toString()})',
                              style: const TextStyle(fontSize: 18),
                            ),
                            // Text('(${pageVM.shopController.shop.value.})'),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
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
                return Expanded(
                  child: ListView.builder(
                    controller: pageVM.scrollController,
                    itemCount: pageVM.foodController.foodList.length,
                    itemBuilder: (context, idx) {
                      // return Container(
                      //   margin: EdgeInsets.symmetric(vertical: 10),
                      //   height: 50,
                      //   color: Colors.grey,
                      //   child:
                      //       Text(pageVM.foodController.foodList[idx].foodName),
                      // );
                      return FoodCustomListCard(
                          food: pageVM.foodController.foodList[idx],
                          func: () async {
                            Navigator.push(
                                context,
                                SlideFadeTransition(
                                  child: EditFoodPage(
                                    food: pageVM.foodController.foodList[idx],
                                  ),
                                ));
                          });
                    },
                  ),
                );
              }
            }),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: const Color.fromRGBO(255, 218, 119, 1),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddFoodPage(),
                ),
              );
            },
            child: const Icon(
              Icons.add,
              size: 35,
              color: Color.fromRGBO(56, 56, 56, 1),
            ),
          ),
        ),
      ),
    );
  }
}

class RestaurantMenuVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final ShopController shopController = Get.find<ShopController>();
  RxBool isLoading = false.obs;
  late ScrollController scrollController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    foodController.getFoodList(shopController.shop.value.essentialMap());
    scrollController = ScrollController();
    isLoading.value = false;
  }

  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete {
    foodController.cleanFoodData();

    return super.onDelete;
  }

  void scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      try {
        isLoading.value = true;
        await foodController
            .getFoodList(shopController.shop.value.essentialMap());
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }
}
