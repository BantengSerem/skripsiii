import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';
import 'package:skripsiii/model/cart.dart';
import 'package:skripsiii/model/transactionModel.dart';
import 'package:skripsiii/widget/finalizeCartList.dart';

class FinalizeOrderPage extends StatefulWidget {
  const FinalizeOrderPage({Key? key, required this.t}) : super(key: key);
  final TransactionModel t;

  @override
  State<FinalizeOrderPage> createState() => _FinalizeOrderPageState();
}

class _FinalizeOrderPageState extends State<FinalizeOrderPage> {
  late FinalizeOrderVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageVM = Get.put(FinalizeOrderVM(foodListMap: widget.t.foodList));
    pageVM.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<FinalizeOrderVM>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finalize Order',
          style: TextStyle(fontSize: 25),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 15),
              // color: Colors.redAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Oder by : ${widget.t.memberName}',
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.t.date.toString(),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
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
                  return ListView.builder(
                    itemCount: pageVM.foodList.length,
                    itemBuilder: (context, idx) {
                      return FinalizeCartList(
                        c: pageVM.foodList[idx],
                      );
                    },
                  );
                }
              },
            ),
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
                    Text(
                      'Rp. ${widget.t.totalPrice}',
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: InkWell(
                        splashColor: Colors.redAccent,
                        onTap: () {},
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.85,
                          height: 40,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          alignment: Alignment.center,
                          child: const Text(
                            'Order',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: InkWell(
                        splashColor: Colors.redAccent,
                        onTap: () {},
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.85,
                          height: 40,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          alignment: Alignment.center,
                          child: const Text(
                            'Order',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                // const SizedBox(
                //   height: 20,
                // ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print(pageVM.foodListMap);
      //     pageVM.init();
      //   },
      // ),
    );
  }
}

class FinalizeOrderVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final ShopController shopController = Get.find<ShopController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  RxBool isLoading = true.obs;
  final List<dynamic> foodListMap;
  late RxList<Cart> foodList = RxList<Cart>();

  FinalizeOrderVM({required this.foodListMap});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void init() async {
    isLoading.value = true;
    // List<Cart> foodList = [];
    foodListMap.forEach((element) {
      var a = Cart.fromMapData(element);
      foodList.value.add(a);
    });

    for (int i = 0; i < foodList.length; i++) {
      var a = foodList[i];
      var res = await shopController.getFoodData(a.foodID);
      foodList[i].imgURL = res.foodImageURL;
      foodList[i].foodName = res.foodName;
    }
    // print(foodList);
    isLoading.value = false;
  }
}
