import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/view/addFoodPage.dart';

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
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, idx) {
                  return Container(
                    height: 50,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const AddFoodPage(),
              //   ),
              // );
              await pageVM.foodController
                  .test(pageVM.shopController.shop.value.shopID);
            },
            child: const Icon(
              Icons.add,
              size: 35,
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
