import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/model/foodModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/editFoodPage.dart';
import 'package:skripsiii/view/memberCartPage.dart';
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
      {required BuildContext context,
      required Food food,
      required Shop shop,
      required Function() func}) async {
    RxInt _count = 0.obs;
    // TextEditingController tc =
    //     TextEditingController(text: _count.value.toString());
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            textAlign: TextAlign.center,
            food.foodName,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Text(food.detailNotes, maxLines: 5, softWrap: true),
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
                        onTap: () {
                          if (_count.value > 0) {
                            _count.value -= 1;
                          }
                        },
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
                      alignment: Alignment.center,
                      height: 40,
                      width: 55,
                      child: Obx(
                        () => Text(
                          _count.value.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
                        onTap: () {
                          // var a = int.parse(tc.text);
                          if (_count.value < food.qty) {
                            _count.value += 1;
                          }
                        },
                        child: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 36,
                  width: 220,
                  child: Obx(
                    () => ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            _count.value > 0 && _count.value <= food.qty
                                ? const MaterialStatePropertyAll<Color>(
                                    Colors.greenAccent,
                                  )
                                : const MaterialStatePropertyAll<Color>(
                                    Colors.grey,
                                  ),
                      ),
                      onPressed: () async {
                        await func();
                        if (_count > 0 && _count <= food.qty) {
                          await EasyLoading.show(
                            dismissOnTap: false,
                            maskType: EasyLoadingMaskType.black,
                          );

                          var data = {
                            'memberID':
                                pageVM.memberController.member.value.memberID,
                            'shopID': shop.shopID,
                            'foodID': food.foodID,
                            'qty': _count.value,
                            'subPrice': food.price * _count.value,
                          };

                          var isThisShopInCart =
                              await pageVM.memberController.checkShopInCart(
                            memberID:
                                pageVM.memberController.member.value.memberID,
                            shopID: shop.shopID,
                          );
                          print(isThisShopInCart);

                          var isMemberCartEmpty =
                              await pageVM.memberController.checkMemberCart(
                            memberID:
                                pageVM.memberController.member.value.memberID,
                          );
                          print(isMemberCartEmpty);

                          if (isMemberCartEmpty) {
                            await pageVM.memberController.addMemberShopToCart(
                              memberID:
                                  pageVM.memberController.member.value.memberID,
                              shopID: shop.shopID,
                            );
                            await pageVM.memberController
                                .addDataToCart(data: data);
                            await EasyLoading.dismiss();
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Successfully add item to cart')));
                            }
                          } else if (isThisShopInCart) {
                            var isFoodInCart = await pageVM.memberController
                                .checkFoodCart(data: data);
                            print(isFoodInCart);
                            if (isFoodInCart) {
                              await pageVM.memberController
                                  .updateDataToCart(data: data);
                            } else {
                              await pageVM.memberController
                                  .addDataToCart(data: data);
                            }
                            EasyLoading.dismiss();
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Successfully add item to cart')));
                            }
                          } else {
                            EasyLoading.dismiss();
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('You still unfinished cart')));
                            }
                          }
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: _count.value > 0 && _count.value <= food.qty
                                ? Colors.black54
                                : Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
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
                    controller: pageVM.scrollController,
                    itemCount: pageVM.foodController.foodList.length,
                    itemBuilder: (context, idx) {
                      return FoodCustomListCard(
                          food: pageVM.foodController.foodList[idx],
                          func: () async {
                            var a = DateFormat('HHmmss').format(DateTime.now());
                            var b = int.parse(a);

                            print(b);
                            print(pageVM.shop.sellingTime);
                            if (pageVM.shop.sellingTime > b) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Store is not open yet')));
                            } else {
                              alert(
                                  food: pageVM.foodController.foodList[idx],
                                  shop: pageVM.shop,
                                  context: context,
                                  func: () async {});
                            }
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
              Navigator.push(
                  context,
                  SlideFadeTransition(
                    child: const MemberCartPage(),
                  ));
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
  final MemberController memberController = Get.find<MemberController>();
  late ScrollController scrollController;

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
    await foodController.getFoodList(shop.essentialMap());    scrollController = ScrollController();

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
      print("reach the bottom");
      try {
        isLoading.value = true;
        await foodController.getFoodList(shop.essentialMap());
      } catch (e) {
        print(e);
      } finally {
        isLoading.value = false;
      }
    }
  }
}
