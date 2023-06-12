import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:skripsiii/main.dart';
import 'package:skripsiii/view/FindFoodPage.dart';
import 'package:skripsiii/view/historyPage.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/profilePage.dart';
import 'package:skripsiii/view/shopHistoryPage.dart';
import 'package:skripsiii/view/shopHomepage.dart';
import 'package:skripsiii/view/shopProfilePage.dart';
import 'package:skripsiii/view/testpage3.dart';

class BottomNavigationPage extends StatelessWidget {
  BottomNavigationPage({Key? key, required this.userType}) : super(key: key);
  final String userType;

  // final HomeVM homeVM = Get.put(HomeVM());
  // final HistoryPageVM historyVM = Get.put(HistoryPageVM());

  List<SalomonBottomBarItem> memberList = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Home"),
      selectedColor: Colors.purple,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.food_bank_outlined),
      title: const Text("Find Food"),
      selectedColor: Colors.red,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.history_rounded),
      title: const Text("History"),
      selectedColor: Colors.pink,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      title: const Text("Profile"),
      selectedColor: Colors.teal,
    ),
  ];

  List<SalomonBottomBarItem> shopList = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Home"),
      selectedColor: Colors.purple,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.food_bank_outlined),
      title: const Text("Find Food"),
      selectedColor: Colors.red,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.history_rounded),
      title: const Text("History"),
      selectedColor: Colors.pink,
    ),
  ];

  final List<Widget> shopPages = [
    const ShopHomePage(
      key: PageStorageKey<String>('ShopHomePage'),
    ),
    const ShopHistoryPage(
      key: PageStorageKey<String>('ShopHistoryPage'),
    ),
    const ShopProfilePage(
      key: PageStorageKey<String>('ShopProfilePage'),
    )
  ];
  final List<Widget> userPages = [
    // Test1(
    //   key: PageStorageKey<String>('HomePage'),
    // ),
    // Test2(
    //   key: PageStorageKey<String>('HomePage'),
    // ),c
    HomePage(
      key: const PageStorageKey<String>('HomePage'),
    ),
    const FindFoodPage(
      key: PageStorageKey<String>('FindFoodPage'),
    ),
    HistoryPage(
      key: const PageStorageKey<String>('HistoryPage'),
    ),
    const ProfilePage(
      key: PageStorageKey<String>('ProfilePage'),
    ),
  ];
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    // TODO change later on to shopPages
    final List<Widget> pages = userType == 'member' ? userPages : shopPages;
    BottomNavController pageVM = Get.put(BottomNavController());
    print('build whole botNav page');
    return Scaffold(
      body: Obx(() {
        print('rebuild body');
        return PageStorage(bucket: bucket, child: pages[pageVM.idx.value]);
      }),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () {
            print('rebuld bottom nav');
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
              child: SalomonBottomBar(
                currentIndex: pageVM.idx.value,
                onTap: (i) {
                  pageVM.changeIdx(i);
                },
                items: userType == 'member' ? memberList : shopList,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BottomNavController extends GetxController {
  RxInt idx = 0.obs;

  void changeIdx(int i) {
    idx.value = i;
  }
}
