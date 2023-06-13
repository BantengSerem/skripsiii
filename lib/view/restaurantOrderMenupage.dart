import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/model/foodModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/editFoodPage.dart';
import 'package:skripsiii/widget/foodCustomListCard.dart';

class RestaurantOrderMenuPage extends StatefulWidget {
  const RestaurantOrderMenuPage({Key? key, required this.shop})
      : super(key: key);
  final Shop shop;

  @override
  State<RestaurantOrderMenuPage> createState() =>
      _RestaurantOrderMenuPageState();
}

class _RestaurantOrderMenuPageState extends State<RestaurantOrderMenuPage> {
  late final RestaurantOrderMenuVM pageVM;

  Future<void> alert(
      {required BuildContext context, required Food food}) async {
    RxInt _count = 0.obs;
    TextEditingController tc =
        TextEditingController(text: _count.value.toString());
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            textAlign: TextAlign.center,
            food.foodName,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: 250,
            height: 350,
            child: ListView(
              children: [
                Container(
                  color: Colors.grey,
                  height: 150,
                  width: 200,
                  child: Image.network(food.foodImageURL),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w400
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed mattis mi iaculis ornare consectetur. Sed id sagittis enim. Nunc ut mauris diam. Suspendisse potenti. Ut pulvinar condimentum neque. Morbi convallis imperdiet lacinia. Etiam faucibus sit amet lacus ut lobortis. Vivamus lacus erat, imperdiet luctus commodo in, porta tristique lectus. Aliquam.',
                      maxLines: 5,
                      softWrap: true),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      height: 40,
                      width: 40,
                      child: InkWell(
                        onTap: () {},
                        child: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      height: 40,
                      width: 55,
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.clip,
                        ),
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        // initialValue: _count.value.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: tc,
                        onChanged: (value) {
                          _count.value = int.parse(tc.value.toString());
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      height: 40,
                      width: 40,
                      child: InkWell(
                        onTap: () {},
                        child: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

              ],
            ),
          ),
          // actions: <Widget>[
          //   TextButton(
          //     onPressed: () => Navigator.pop(context, 'Cancel'),
          //     child: const Text('Cancel'),
          //   ),
          //   TextButton(
          //     onPressed: () async {
          //       // await EasyLoading.show(
          //       //   dismissOnTap: false,
          //       //   maskType:
          //       //   EasyLoadingMaskType.black,
          //       // );
          //       // var deleteSuccess = await pageVM
          //       //     .foodController
          //       //     .deleteFoodImage({
          //       //   'shopID': pageVM.shopController
          //       //       .shop.value.shopID,
          //       //   'imgName': widget.food.foodID,
          //       // });
          //       //
          //       // if (deleteSuccess) {
          //       //   await pageVM.foodController
          //       //       .deleteFoodData({
          //       //     'foodID': widget.food.foodID,
          //       //   });
          //       // }
          //       //
          //       // if (mounted) {
          //       //   EasyLoading.dismiss();
          //       //   // int count = 2;
          //       //   // Navigator.of(context).popUntil((_) => count-- <= 0);
          //       //   Navigator.of(context).popUntil(
          //       //           (route) => route.isFirst);
          //       // }
          //       Navigator.pop(context, 'OK');
          //     },
          //     child: const Text('OK'),
          //   ),
          // ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    // var a = RestaurantOrderMenuVM(shop: widget.shop);
    pageVM = Get.put(RestaurantOrderMenuVM(shop: widget.shop));
    pageVM.init();
    // pageVM.shop = widget.shop;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<RestaurantOrderMenuVM>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageVM.shop.shopName,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
                            // Text('(${pageVM.shopController.shop.value.})'),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
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
                return Expanded(
                  child: ListView.builder(
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
                            alert(
                              food: pageVM.foodController.foodList[idx],
                              context: context,
                            );
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
            onPressed: () async {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const AddFoodPage(),
              //   ),
              // );
            },
            child: const Icon(
              Icons.shopping_cart,
              // size: 35,
            ),
          ),
        ),
      ),
    );
  }
}

class RestaurantOrderMenuVM extends GetxController {
  RestaurantOrderMenuVM({
    required this.shop,
  });

  final FoodController foodController = Get.find<FoodController>();
  final ShopController shopController = Get.find<ShopController>();
  final Shop shop;
  RxBool isLoading = false.obs;
  TextEditingController tc = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    // foodController.getFoodList(shop.essentialMap());
    super.onInit();
  }

  void init() async {
    isLoading.value = true;
    foodController.getFoodList(shop.essentialMap());
    isLoading.value = false;
  }

  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete {
    foodController.cleanFoodData();

    return super.onDelete;
  }
}
