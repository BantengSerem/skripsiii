import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/model/cart.dart';
import 'package:skripsiii/model/foodModel.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/model/transactionModel.dart';
import 'package:skripsiii/widget/cartListCard.dart';
import 'package:skripsiii/widget/nodata.dart';
import 'package:uuid/uuid.dart';

class MemberCartPage extends StatefulWidget {
  const MemberCartPage({Key? key}) : super(key: key);

  @override
  State<MemberCartPage> createState() => _MemberCartPageState();
}

class _MemberCartPageState extends State<MemberCartPage> {
  late MemberCartVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    // var a = RestaurantOrderMenuVM(shop: widget.shop);
    pageVM = Get.put(MemberCartVM());
    // pageVM.shop = widget.shop;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<MemberCartVM>();
    super.dispose();
  }

  Future<void> alert({required BuildContext context}) async {
    // TextEditingController tc =
    //     TextEditingController(text: _count.value.toString());
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(
            textAlign: TextAlign.center,
            'Oops there are some changes',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'There are some changes to your cart data',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
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
      body: Column(
        children: [
          Obx(
            () => pageVM.isCartEmpty.value
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 50,
                    child: Text(
                      pageVM.shop.shopName,
                      style: const TextStyle(),
                    ),
                  ),
          ),
          Expanded(
            child: Obx(() {
              if (pageVM.isLoading.value) {
                return Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    color: Colors.lightBlue,
                    size: 50,
                  ),
                );
              }
              if (pageVM.isCartEmpty.value) {
                return const NoDataWidget();
              } else {
                return ListView.builder(
                  // controller: pageVM.scrollController,
                  itemCount: pageVM.foodList.length,
                  itemBuilder: (context, idx) => CartListCard(
                    foodName: pageVM.foodList[idx].foodName,
                    foodURL: pageVM.foodList[idx].foodImageURL,
                    qty: pageVM.cartList[idx].qty,
                    subPrice: pageVM.cartList[idx].subPrice,
                  ),
                );
              }
            }),
          ),
          Container(
            height: 100,
            // color: Colors.greenAccent,
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 1))),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Obx(
                      () => Text(
                        'Rp. ${NumberFormat("#,##0.00", "en_US").format(pageVM._totalPrice.value)}',
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  splashColor: Colors.redAccent,
                  onTap: () async {
                    await EasyLoading.show(
                      dismissOnTap: false,
                      maskType: EasyLoadingMaskType.black,
                    );
                    if (!pageVM.isCartEmpty.value) {
                      bool isCorrect = true;
                      pageVM.cartList.forEach((element) async {
                        var isFalse = await pageVM.foodController
                            .checkFoodCartList(element);
                        if (isFalse) {
                          isCorrect = false;
                          await pageVM.memberController.removeCartItem(
                            memberID:
                                pageVM.memberController.member.value.memberID,
                            cart: element,
                          );
                          pageVM.cartList
                              .removeWhere((a) => a.foodID == element.foodID);
                        }
                      });

                      if (pageVM.cartList.isEmpty) {
                        await pageVM.memberController.deleteCart(
                          memberID:
                              pageVM.memberController.member.value.memberID,
                        );
                        pageVM.isCartEmpty.value = true;
                        pageVM.foodList.clear();
                      }
                      if (isCorrect) {
                        List<Map<String, dynamic>> l = [];
                        for (var element in pageVM.cartList) {
                          l.add({
                            'foodID': element.foodID,
                            'subPrice': element.subPrice,
                            'qty': element.qty,
                          });
                          await pageVM.shopController
                              .updateFoodQty(element.foodID, element.qty);
                        }
                        var uuid = const Uuid();
                        String transacID = uuid.v4();

                        var transaction = TransactionModel(
                          shopID: pageVM.shop.shopID,
                          memberID:
                              pageVM.memberController.member.value.memberID,
                          transactionID: transacID,
                          foodList: l,
                          date: DateTime.now(),
                          status: 'ongoing',
                          totalPrice: pageVM._totalPrice.value,
                          memberName: pageVM.memberController.member.value.name,
                          shopName: pageVM.shop.shopName,
                        );
                        await pageVM.memberController
                            .createTransction(transaction);
                        await pageVM.memberController.deleteCart(
                          memberID:
                              pageVM.memberController.member.value.memberID,
                        );

                        pageVM.isCartEmpty.value = true;
                        pageVM.foodList.clear();

                        EasyLoading.dismiss();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(duration: Duration(seconds: 1),
                                  content:
                                      Text('Successfully create transaction')));

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      } else {
                        EasyLoading.dismiss();
                        if (mounted) {
                          alert(context: context);
                        }
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(duration: Duration(seconds: 1),
                            content: Text('Your cart is empty'),
                          ),
                        );
                      }
                    }
                    EasyLoading.dismiss();
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.85,
                    height: 40,
                    decoration: BoxDecoration(
                        color: pageVM.isCartEmpty.value
                            ? Colors.grey
                            : Colors.greenAccent,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    alignment: Alignment.center,
                    child: Text(
                      'Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: pageVM.isCartEmpty.value
                            ? const Color.fromRGBO(56, 56, 56, 1)
                            : Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        // color: Color
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MemberCartVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final ShopController shopController = Get.find<ShopController>();
  final MemberController memberController = Get.find<MemberController>();
  late List<Cart> cartList = [];
  RxList<Food> foodList = RxList<Food>();

  // late ScrollController scrollController;

  RxBool isCartEmpty = true.obs;
  RxBool isLoading = false.obs;

  // late Cart cart;
  late Shop shop;
  final RxDouble _totalPrice = 0.0.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    var a = await memberController.checkMemberCart(
        memberID: memberController.member.value.memberID);
    if (!a) {
      // scrollController = ScrollController();
      var sid = await memberController
          .getCartListShopID(memberController.member.value.memberID);
      shop = await shopController.getShopData(sid);
      cartList = await memberController.getMemberCartList(
          memberID: memberController.member.value.memberID);
      cartList.forEach((element) async {
        var food = await foodController.getFoodData(element.foodID);
        foodList.add(food);
      });
      for (var element in cartList) {
        _totalPrice.value += element.subPrice;
      }
    }
    if (cartList.isNotEmpty) isCartEmpty.value = false;
    isLoading.value = false;

    // shop = await memberController.getCartListShop();
  }

// void scrollListener() async {
//   if (scrollController.offset >= scrollController.position.maxScrollExtent &&
//       !scrollController.position.outOfRange) {
//     print("reach the bottom");
//     try {
//       isLoading.value = true;
//       cartList = await memberController.getMemberCartList(
//           memberID: memberController.member.value.memberID);
//       cartList.forEach((element) async {
//         var food = await foodController.getFoodData(element.foodID);
//         foodList.add(food);
//       });
//     } catch (e) {
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
}
