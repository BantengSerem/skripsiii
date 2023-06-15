import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  Future<void> alertComplete({required BuildContext context}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            textAlign: TextAlign.center,
            'Confirm to complete this order',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(
                  width: 1.0,
                  color: Color.fromRGBO(56, 56, 56, 1),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(
                  width: 1.0,
                  color: Color.fromRGBO(56, 56, 56, 1),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () async {
                await EasyLoading.show(
                  dismissOnTap: false,
                  maskType: EasyLoadingMaskType.clear,
                );
                var res = await pageVM.transactionController
                    .statusToCompleted(widget.t.transactionID);
                if (res) {
                  EasyLoading.dismiss();
                  if (mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(duration: Duration(seconds: 1),content: Text('Transaction Complete')));
                  }
                } else {
                  EasyLoading.dismiss();
                  if (mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(duration: Duration(seconds: 1),content: Text('Something went wrong')));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> alertCanceled({required BuildContext context}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            textAlign: TextAlign.center,
            'Confirm to cancel this order',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(
                  width: 1.0,
                  color: Color.fromRGBO(56, 56, 56, 1),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(
                  width: 1.0,
                  color: Color.fromRGBO(56, 56, 56, 1),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () async {
                await EasyLoading.show(
                  dismissOnTap: false,
                  maskType: EasyLoadingMaskType.clear,
                );
                var res = await pageVM.transactionController
                    .statusToCanceled(widget.t.transactionID);
                if (res) {
                  EasyLoading.dismiss();
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(duration: Duration(seconds: 1),content: Text('Transaction Canceled')));
                  }
                } else {
                  EasyLoading.dismiss();
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(duration: Duration(seconds: 1),content: Text('Something went wrong')));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finalize Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
        elevation: 0,
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
          Material(
            elevation: 5,
            child: Container(
              height: 110,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              // color: const Color.fromRGBO(255, 218, 119, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID : ${widget.t.transactionID}',
                    style: const TextStyle(
                        fontSize: 17, color: Color.fromRGBO(56, 56, 56, 1)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Oder by : ${widget.t.memberName}',
                    style: const TextStyle(
                        fontSize: 17, color: Color.fromRGBO(56, 56, 56, 1)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Ordered date : ${DateFormat('dd MMMM yyyy, HH:mm').format(widget.t.date)}',
                    style: const TextStyle(
                        fontSize: 17, color: Color.fromRGBO(56, 56, 56, 1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
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
            // color: const Color.fromRGBO(255, 164, 91, 1),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 1),
              ),
              color: const Color.fromRGBO(255, 164, 91, 1),
            ),
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
                        color: Color.fromRGBO(56, 56, 56, 1),
                      ),
                    ),
                    Text(
                      'Rp. ${NumberFormat("#,##0.00", "en_US").format(widget.t.totalPrice)}',
                      style: const TextStyle(
                        fontSize: 25,
                        color: Color.fromRGBO(56, 56, 56, 1),
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
                        // splashColor: Colors.redAccent,
                        onTap: () async {
                          await alertCanceled(context: context);
                          // if (mounted) {
                          //   Navigator.popUntil(
                          //       context, (route) => route.isFirst);
                          // }
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.85,
                          height: 40,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(241, 59, 59, 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          alignment: Alignment.center,
                          child: const Text(
                            'Canceled',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: InkWell(
                        // splashColor: Colors.redAccent,
                        onTap: () async {
                          await alertComplete(context: context);
                          // if (mounted) {
                          //   Navigator.popUntil(
                          //       context, (route) => route.isFirst);
                          // }
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.85,
                          height: 40,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(152, 227, 109, 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          alignment: Alignment.center,
                          child: const Text(
                            'Completed',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(56, 56, 56, 1),
                            ),
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
