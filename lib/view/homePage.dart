import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/controller/foodController.dart';
import 'package:skripsiii/controller/loginController.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/model/foodModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.find<LoginController>();
  final MemberController memberController = Get.find<MemberController>();
  final HomeVM pageVM = Get.find<HomeVM>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  color: Colors.blueGrey,
                  // alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: pageVM.searchBarTextController,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.blueGrey,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onTap: () async {
                      // FocusScope.of(context).unfocus();
                      var a = await showSearch(
                          context: context, delegate: SearchFood());
                      print('result : $a');
                      pageVM.getSearch(a);
                      // pageVM.openSeachBar();
                    },
                    autofillHints: const ['nasi padang', 'burger', 'soto ayam'],
                    onTapOutside: (_) {
                      // pageVM.closeSearchbar();
                      FocusScope.of(context).unfocus();
                    },
                    onSubmitted: (submitted) {
                      // pageVM.closeSearchbar();
                    },
                    enableSuggestions: true,
                  ),
                ),
                Container(
                  // color: Colors.yellow,
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: [
                      const Text(
                        'Welcome, ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Obx(
                        () => Text(
                          memberController.member.value.username,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.red,
                  // margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 250,
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
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO redirect to browsing page
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
                      Expanded(
                        child: ListView.builder(
                          key: const Key('sellingNow'),
                          scrollDirection: Axis.horizontal,
                          itemCount: 20,
                          itemBuilder: (context, idx) => Container(
                            height: 30,
                            width: 60,
                            color: Colors.greenAccent,
                            margin: const EdgeInsets.all(5),
                            child: Text('item $idx'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.red,
                  // margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 250,
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
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO redirect to browsing page
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
                      Expanded(
                        child: ListView.builder(
                          key: Key('sellingSoon'),
                          scrollDirection: Axis.horizontal,
                          itemCount: 20,
                          itemBuilder: (context, idx) => Container(
                            height: 30,
                            width: 60,
                            color: Colors.greenAccent,
                            margin: const EdgeInsets.all(5),
                            child: Text('item $idx'),
                          ),
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
        onPressed: () {},
        label: Row(
          children: const [
            Text(
              'Share Food',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeVM extends GetxController {
  // RxBool searchBarOpen = false.obs;
  final TextEditingController searchBarTextController = TextEditingController();
  // final FoodController foodController = Get.find<FoodController>();

  RxBool isLoadingSellingNow = false.obs;
  RxBool isLoadingSellingSoon = false.obs;

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
    print('buildResults');
    return FutureBuilder(
      future: shopController.getSuggestedRestaurant(query),
      builder: (context, snapshot) {
        print('sdfasdfasdfadfasdfasfdasfd=========');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          print("has data ");
          print('snapshot.data!.docs : ${snapshot.data!.docs}');
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, idx) => ListTile(
              title: Text('${snapshot.data!.docs[idx].data()['shopName']}'),
              onTap: () {
                final restaurantData = snapshot.data!.docs[idx].data();
                query = restaurantData['shopName'];
                close(context, query);
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
      print('buildSuggestions');
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
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, idx) => ListTile(
                title: Text('${snapshot.data!.docs[idx].data()['shopName']}'),
                onTap: () {
                  final restaurantData = snapshot.data!.docs[idx].data();
                  query = restaurantData['shopName'];
                  close(context, query);
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

  @override
  void close(BuildContext context, result) {
    super.close(context, result);
  }
}
