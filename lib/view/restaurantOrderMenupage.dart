import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/model/foodModel.dart';
import 'package:skripsiii/model/ratingModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/memberCartPage.dart';
import 'package:skripsiii/widget/foodCustomListCard.dart';
import 'package:uuid/uuid.dart';

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
    RxInt count = 0.obs;
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
                          if (count.value > 0) {
                            count.value -= 1;
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
                          count.value.toString(),
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
                          if (count.value < food.qty) {
                            count.value += 1;
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
                            count.value > 0 && count.value <= food.qty
                                ? const MaterialStatePropertyAll<Color>(
                                    Colors.greenAccent,
                                  )
                                : const MaterialStatePropertyAll<Color>(
                                    Colors.grey,
                                  ),
                      ),
                      onPressed: () async {
                        await func();
                        if (count > 0 && count <= food.qty) {
                          await EasyLoading.show(
                            dismissOnTap: false,
                            maskType: EasyLoadingMaskType.black,
                          );

                          var data = {
                            'memberID':
                                pageVM.memberController.member.value.memberID,
                            'shopID': shop.shopID,
                            'foodID': food.foodID,
                            'qty': count.value,
                            'subPrice': food.price * count.value,
                          };

                          var isThisShopInCart =
                              await pageVM.memberController.checkShopInCart(
                            memberID:
                                pageVM.memberController.member.value.memberID,
                            shopID: shop.shopID,
                          );

                          var isMemberCartEmpty =
                              await pageVM.memberController.checkMemberCart(
                            memberID:
                                pageVM.memberController.member.value.memberID,
                          );

                          if (isMemberCartEmpty) {
                            print('add data to cart $data');
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
                                      duration: Duration(seconds: 1),
                                      content: Text(
                                          'Successfully add item to cart')));
                            }
                          } else if (isThisShopInCart) {
                            var isFoodInCart = await pageVM.memberController
                                .checkFoodCart(data: data);
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
                                      duration: Duration(seconds: 1),
                                      content: Text(
                                          'Successfully add item to cart')));
                            }
                          } else {
                            EasyLoading.dismiss();
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content:
                                          Text('You still unfinished cart')));
                            }
                          }
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: count.value > 0 && count.value <= food.qty
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

  Future<void> alreadyRated({required BuildContext context}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(
            textAlign: TextAlign.center,
            'You have given your rating',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }

  Future<void> notRated({required BuildContext context}) async {
    RxInt rate = 0.obs;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            textAlign: TextAlign.center,
            'Please give your rating!',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          content: SizedBox(
            width: 100,
            height: 110,
            child: ListView(
              children: [
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
                          if (rate.value > 0) {
                            rate.value -= 1;
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
                          rate.value.toString(),
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
                          if (rate.value < 5) {
                            rate.value += 1;
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
                        backgroundColor: rate.value > 0 && rate.value <= 5
                            ? const MaterialStatePropertyAll<Color>(
                                Colors.greenAccent,
                              )
                            : const MaterialStatePropertyAll<Color>(
                                Colors.grey,
                              ),
                      ),
                      onPressed: () async {
                        var uuid = const Uuid();
                        String ratingID = uuid.v4();
                        if (rate.value > 0 && rate.value <= 5) {
                          var rating = Rating(
                            ratingID: ratingID,
                            shopID: pageVM.shop.shopID,
                            memberID:
                                pageVM.memberController.member.value.memberID,
                            rating: rate.value,
                          );

                          await pageVM.memberController
                              .createRating(rating: rating);
                          double avg = pageVM.memberController.calculateAVG(
                              pageVM.shop.ratingAVG,
                              pageVM.shop.totalReview,
                              rate.value);
                          pageVM.shop.ratingAVG = avg;
                          pageVM.shop.totalReview += 1;

                          var res = await pageVM.memberController.setShopRating(
                            shop: pageVM.shop,
                            rating: rating,
                          );
                          if (res) {
                            pageVM.isRated = true;

                            EasyLoading.dismiss();
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text('Thanks for your rate')));
                            }
                          } else {
                            pageVM.isRated = false;
                            EasyLoading.dismiss();
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text('Something went wrong')));
                            }
                          }
                          setState(() {});
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: rate.value > 0 && rate.value <= 5
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
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
        actions: [
          Container(
            width: 110,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                // border: Border.all(
                //   color: const Color.fromRGBO(251, 246, 240, 1),
                //   width: 1,
                // ),
                color: Color.fromRGBO(56, 56, 56, 1),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: TextButton.icon(
              onPressed: () async {
                if (pageVM.isRated) {
                  await alreadyRated(context: context);
                } else {
                  await notRated(context: context);
                }
              },
              icon: const Icon(
                Icons.star_rate,
                size: 20,
                color: Colors.yellow,
              ),
              label: const Text(
                'Rate?',
                style: TextStyle(
                    color: Color.fromRGBO(255, 218, 119, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          )
        ],
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
                          pageVM.shop.shopName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              pageVM.shop.ratingAVG.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Text(
                              'review (${pageVM.shop.totalReview})',
                              style: const TextStyle(fontSize: 18),
                            )
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

                            if (pageVM.shop.sellingTime > b) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 1),
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
            backgroundColor: const Color.fromRGBO(255, 218, 119, 1),
            onPressed: () async {
              Navigator.push(
                  context,
                  SlideFadeTransition(
                    child: const MemberCartPage(),
                  ));
            },
            child: const Icon(
              Icons.shopping_cart, color: Color.fromRGBO(56, 56, 56, 1),
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
  bool isRated = true;
  TextEditingController tc = TextEditingController();

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    foodController.getFoodList(shop.essentialMap());
    isRated = await memberController.isRated(shop.shopID);
    super.onInit();
  }

  void init() async {
    isLoading.value = true;
    // await foodController.getFoodList(shop.essentialMap());
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
        await foodController.getFoodList(shop.essentialMap());
      } catch (e) {
        isLoading.value = false;
      } finally {
        isLoading.value = false;
      }
    }
  }
}
