import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/controller/transactionController.dart';

class SellingTimeSettingsPage extends StatefulWidget {
  const SellingTimeSettingsPage({Key? key}) : super(key: key);

  @override
  State<SellingTimeSettingsPage> createState() =>
      _SellingTimeSettingsPageState();
}

class _SellingTimeSettingsPageState extends State<SellingTimeSettingsPage> {
  late SettingsPageVM pageVM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageVM = Get.put(SettingsPageVM());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<SettingsPageVM>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Selling Time',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Interact to change your settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        const Text(
                          'Selling Time : ',
                          style: TextStyle(
                            color: Color.fromRGBO(56, 56, 56, 1),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 164, 91, 1),
                            ),
                            onPressed: () async {
                              final TimeOfDay selectedTime = TimeOfDay.now();
                              final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                                initialEntryMode: TimePickerEntryMode.dialOnly,
                              );

                              if (timeOfDay != null) {
                                var s =
                                    '${timeOfDay.hour}${timeOfDay.minute}00';
                                int a = int.parse(s);
                                print(a);
                                pageVM.sellingTime.value =
                                    '${timeOfDay.hour}.${timeOfDay.minute}';
                                pageVM.changeSell.value = a;
                                pageVM.isChange.value = true;
                              }
                            },
                            child: Text(
                              pageVM.sellingTime.value,
                              style: const TextStyle(
                                color: Color.fromRGBO(56, 56, 56, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        const Text(
                          'Closing Time : ',
                          style: TextStyle(
                            color: Color.fromRGBO(56, 56, 56, 1),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 164, 91, 1),
                            ),
                            onPressed: () async {
                              final TimeOfDay selectedTime = TimeOfDay.now();
                              final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                                initialEntryMode: TimePickerEntryMode.dialOnly,
                              );

                              if (timeOfDay != null) {
                                var s =
                                    '${timeOfDay.hour}${timeOfDay.minute}00';
                                int a = int.parse(s);
                                pageVM.closingTime.value =
                                    '${timeOfDay.hour}.${timeOfDay.minute}';
                                pageVM.changeClose.value = a;
                                print(a);
                                pageVM.isChange.value = true;
                              }
                            },
                            child: Text(
                              pageVM.closingTime.value,
                              style: const TextStyle(
                                color: Color.fromRGBO(56, 56, 56, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: pageVM.isChange.value
                            ? const MaterialStatePropertyAll<Color>(
                                Colors.greenAccent,
                              )
                            : const MaterialStatePropertyAll<Color>(
                                Colors.grey,
                              ),
                      ),
                      onPressed: () async {
                        if (pageVM.isChange.value) {
                          await pageVM.shopController.changeShopTime(
                              pageVM.changeClose.value,
                              pageVM.changeSell.value);
                          pageVM.shopController.shop.value.closingTime =
                              pageVM.changeClose.value;
                          pageVM.shopController.shop.value.sellingTime =
                              pageVM.changeSell.value;
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text('Save Changes'),
                            ));
                          }
                          print(pageVM.changeClose.value);
                          print(pageVM.changeSell.value);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('No Changes'),
                          ));
                        }
                      },
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                            color: pageVM.isChange.value
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingsPageVM extends GetxController {
  final FoodController foodController = Get.find<FoodController>();
  final ShopController shopController = Get.find<ShopController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  RxBool isShopOpen = false.obs;
  RxString sellingTime = ''.obs;
  RxString closingTime = ''.obs;
  RxInt changeSell = 0.obs;
  RxInt changeClose = 0.obs;
  RxBool isChange = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isShopOpen =
        shopController.shop.value.isOpen == 'false' ? false.obs : true.obs;

    if (shopController.shop.value.sellingTime != -1) {
      var s = shopController.shop.value.sellingTime.toString();
      var slen = s.length;
      sellingTime.value =
          '${s.substring(0, slen - 4)}.${s.substring(slen - 4, slen - 2)}';
    } else {
      sellingTime.value = '-1';
    }
    if (shopController.shop.value.closingTime != -1) {
      var c = shopController.shop.value.closingTime.toString();
      var clen = c.length;
      closingTime.value =
          '${c.substring(0, clen - 4)}.${c.substring(clen - 4, clen - 2)}';
    } else {
      closingTime.value = '-1';
    }
  }
}
