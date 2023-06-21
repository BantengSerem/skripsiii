import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/model/shopModel.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/browseRestaurantPage.dart';
import 'package:skripsiii/view/restaurantOrderMenupage.dart';
import 'package:skripsiii/view/shareFoodPage.dart';
import 'package:skripsiii/widget/nodata.dart';
import 'package:skripsiii/widget/sellingItemCard.dart';

// class HomePage extends StatelessWidget {
//   HomePage({Key? key}) : super(key: key);
//
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LoginController loginController = Get.find<LoginController>();
  final MemberController memberController = Get.find<MemberController>();
  final FoodController foodController = Get.find<FoodController>();
  // final HomePageVM pageVM = Get.find<HomePageVM>();
  final HomePageVM pageVM = Get.put(HomePageVM());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                // const SizedBox(
                //   height: 20,
                // ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  color: const Color.fromRGBO(255, 164, 91, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // color: Colors.yellow,
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              'Welcome, ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Color.fromRGBO(56, 56, 56, 1),
                              ),
                            ),
                            Obx(
                                  () => Text(
                                memberController.member.value.username,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(56, 56, 56, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        color: const Color.fromRGBO(255, 218, 119, 1),
                        // alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromRGBO(255, 218, 119, 1)),
                          ),
                          onPressed: () async {
                            // FocusScope.of(context).unfocus();
                            var a = await showSearch(
                                context: context, delegate: SearchFood());
                            pageVM.getSearch(a);
                            // pageVM.openSeachBar();
                          },
                          child: const Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(56, 56, 56, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  // color: Colors.red,
                  // margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 280,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Selling Now',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(56, 56, 56, 1),
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO redirect to browsing page
                                Navigator.push(
                                    context,
                                    SlideFadeTransition(
                                      child: const BrowseRestaurantPage(
                                        title: 'Selling Now',
                                        type: 'now',
                                      ),
                                    ));
                              },
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: Obx(
                              () {
                            if (pageVM.isLoadingSellingNow.value) {
                              return Shimmer.fromColors(
                                baseColor: Colors.black38,
                                highlightColor: Colors.white,
                                period: const Duration(milliseconds: 1500),
                                child: Container(
                                  color: Colors.white,
                                  height: 220,
                                  width:
                                  MediaQuery.of(context).size.width * 0.8,
                                ),
                              );
                            } else {
                              if (pageVM.shopController.sellNowList.isEmpty) {
                                return const NoDataWidget();
                                // return Shimmer.fromColors(
                                //   baseColor: Colors.black38,
                                //   highlightColor: Colors.white,
                                //   period: const Duration(milliseconds: 1500),
                                //   child: Container(
                                //     color: Colors.white,
                                //     height: 220,
                                //     width:
                                //         MediaQuery.of(context).size.width * 0.8,
                                //   ),
                                // );
                              } else {
                                return ListView.builder(
                                  key: const Key('sellingNow'),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                  pageVM.shopController.sellNowList.length,
                                  itemBuilder: (context, idx) =>
                                      SellingItemCard(
                                        type: 'sellingNow',
                                        data: pageVM.shopController.sellNowList[idx]
                                            .toMap(),
                                        func: () async {
                                          Get.to(RestaurantOrderMenuPage(
                                              shop: pageVM.shopController
                                                  .sellNowList[idx]));
                                          // print(pageVM.shopController.sellNowList[idx].essentialMap());
                                        },
                                      ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  // color: Colors.red,
                  // margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 280,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Selling Soon',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(56, 56, 56, 1),
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO redirect to browsing page
                                Navigator.push(
                                    context,
                                    SlideFadeTransition(
                                      child: const BrowseRestaurantPage(
                                        title: 'Selling Soon',
                                        type: 'soon',
                                      ),
                                    ));
                              },
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: Obx(
                              () {
                            if (pageVM.isLoadingSellingSoon.value) {
                              return Shimmer.fromColors(
                                baseColor: Colors.black38,
                                highlightColor: Colors.white,
                                period: const Duration(milliseconds: 1500),
                                child: Container(
                                  color: Colors.white,
                                  height: 220,
                                  width:
                                  MediaQuery.of(context).size.width * 0.8,
                                ),
                              );
                            } else {
                              if (pageVM.shopController.sellSoonList.isEmpty) {
                                return const NoDataWidget();
                                // return Shimmer.fromColors(
                                //   baseColor: Colors.black38,
                                //   highlightColor: Colors.white,
                                //   period: const Duration(milliseconds: 1500),
                                //   child: Container(
                                //     color: Colors.white,
                                //     height: 220,
                                //     width:
                                //         MediaQuery.of(context).size.width * 0.8,
                                //   ),
                                // );
                              } else {
                                return ListView.builder(
                                  key: const Key('sellingSoon'),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                  pageVM.shopController.sellSoonList.length,
                                  itemBuilder: (context, idx) =>
                                      SellingItemCard(
                                        type: 'sellingSoon',
                                        data: pageVM
                                            .shopController.sellSoonList[idx]
                                            .toMap(),
                                        func: () async {
                                          Get.to(RestaurantOrderMenuPage(
                                              shop: pageVM.shopController
                                                  .sellSoonList[idx]));
                                        },
                                      ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(255, 218, 119, 1),
        onPressed: () async {
          // await pageVM.shopController.test();
          Get.to(const SharedFoodPage());
        },
        label: Row(
          children: const [
            Text(
              'Share Food',
              style: TextStyle(
                  color: Color.fromRGBO(56, 56, 56, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


class HomePageVM extends GetxController {
  final TextEditingController searchBarTextController = TextEditingController();

  final ShopController shopController = Get.find<ShopController>();
  final MemberController memberController = Get.find<MemberController>();

  RxBool isLoadingSellingNow = false.obs;
  RxBool isLoadingSellingSoon = false.obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    isLoadingSellingNow.value = true;
    isLoadingSellingSoon.value = true;
    await shopController.init(memberController.member.value);
    isLoadingSellingNow.value = false;
    isLoadingSellingSoon.value = false;
    super.onInit();
  }

  Future<void> init() async {
    isLoadingSellingNow.value = true;
    isLoadingSellingSoon.value = true;

    isLoadingSellingNow.value = false;
    isLoadingSellingSoon.value = false;
  }

  void loadingSN() {
    isLoadingSellingNow.value = true;
  }

  void finishSN() {
    isLoadingSellingNow.value = false;
  }

  void loadingSS() {
    isLoadingSellingSoon.value = true;
  }

  void finishSS() {
    isLoadingSellingSoon.value = false;
  }

  // void openSeachBar() {
  //   searchBarOpen.value = true;
  // }
  //
  // void closeSearchbar() {
  //   searchBarOpen.value = false;
  // }

  void getSearch(String value) {
    searchBarTextController.text = value;
  }
}

class SearchFood extends SearchDelegate<dynamic> {
  // final FoodController foodController = Get.find<FoodController>();
  final ShopController shopController = Get.find<ShopController>();

  // Timer? _timer;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: shopController.getSuggestedRestaurant(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          // final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, idx) => ListTile(
              title: Text('${snapshot.data!.docs[idx].data()['name']}'),
              onTap: () {
                final restaurantData = snapshot.data!.docs[idx].data();
                query = restaurantData['name'];
                close(context, query);
                final shop = Shop.fromMap(snapshot.data!.docs[idx]);
                Get.to(RestaurantOrderMenuPage(shop: shop));
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // print('buildSuggestions');
    if (query.length > 3) {
      return FutureBuilder(
        future: shopController.getSuggestedRestaurant(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            // final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, idx) => ListTile(
                title: Text('${snapshot.data!.docs[idx].data()['name']}'),
                onTap: () {
                  final restaurantData = snapshot.data!.docs[idx].data();
                  query = restaurantData['name'];
                  close(context, query);
                  final shop = Shop.fromMap(snapshot.data!.docs[idx]);
                  Get.to(RestaurantOrderMenuPage(shop: shop));
                  // showResults(context);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );
    }
    return const SizedBox.shrink();
  }
}
