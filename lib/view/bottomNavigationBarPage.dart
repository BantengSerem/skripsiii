import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:skripsiii/view/FindFoodPage.dart';
import 'package:skripsiii/view/historyPage.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/profilePage.dart';
import 'package:skripsiii/view/shopHistoryPage.dart';
import 'package:skripsiii/view/shopHomepage.dart';
import 'package:skripsiii/view/shopProfilePage.dart';

class BottomNavigationPage extends StatelessWidget {
  BottomNavigationPage({Key? key, required this.userType}) : super(key: key);
  final String userType;

  final List<SalomonBottomBarItem> memberList = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      activeIcon: const Icon(
        Icons.home,
        color: Color.fromRGBO(56, 56, 56, 1),
      ),
      unselectedColor: const Color.fromRGBO(56, 56, 56, 1),
      title: const Text(
        "Home",
        style: TextStyle(color: Color.fromRGBO(56, 56, 56, 1)),
      ),
      selectedColor: const Color.fromRGBO(255, 218, 119, 1),
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.food_bank_outlined),
      activeIcon: const Icon(
        Icons.food_bank_outlined,
        color: Color.fromRGBO(56, 56, 56, 1),
      ),
      title: const Text(
        "Find Food",
        style: TextStyle(color: Color.fromRGBO(56, 56, 56, 1)),
      ),
      selectedColor: const Color.fromRGBO(255, 218, 119, 1),
      unselectedColor: const Color.fromRGBO(56, 56, 56, 1),
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.history_rounded),
      activeIcon: const Icon(
        Icons.history_rounded,
        color: Color.fromRGBO(56, 56, 56, 1),
      ),
      unselectedColor: const Color.fromRGBO(56, 56, 56, 1),
      title: const Text(
        "History",
        style: TextStyle(color: Color.fromRGBO(56, 56, 56, 1)),
      ),
      selectedColor: const Color.fromRGBO(255, 218, 119, 1),
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      activeIcon: const Icon(
        Icons.person,
        color: Color.fromRGBO(56, 56, 56, 1),
      ),
      unselectedColor: const Color.fromRGBO(56, 56, 56, 1),
      title: const Text(
        "Profile",
        style: TextStyle(color: Color.fromRGBO(56, 56, 56, 1)),
      ),
      selectedColor: const Color.fromRGBO(255, 218, 119, 1),
    ),
  ];

  final List<SalomonBottomBarItem> shopList = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      activeIcon: const Icon(
        Icons.home,
        color: Color.fromRGBO(56, 56, 56, 1),
      ),
      unselectedColor: const Color.fromRGBO(56, 56, 56, 1),
      title: const Text(
        "Home",
        style: TextStyle(color: Color.fromRGBO(56, 56, 56, 1)),
      ),
      selectedColor: const Color.fromRGBO(255, 218, 119, 1),
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.history_rounded),
      activeIcon: const Icon(
        Icons.history_rounded,
        color: Color.fromRGBO(56, 56, 56, 1),
      ),
      unselectedColor: const Color.fromRGBO(56, 56, 56, 1),
      title: const Text(
        "History",
        style: TextStyle(color: Color.fromRGBO(56, 56, 56, 1)),
      ),
      selectedColor: const Color.fromRGBO(255, 218, 119, 1),
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      activeIcon: const Icon(
        Icons.person,
        color: Color.fromRGBO(56, 56, 56, 1),
      ),
      unselectedColor: const Color.fromRGBO(56, 56, 56, 1),
      title: const Text(
        "Profile",
        style: TextStyle(color: Color.fromRGBO(56, 56, 56, 1)),
      ),
      selectedColor: const Color.fromRGBO(255, 218, 119, 1),
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
    HomePage(
      key: const PageStorageKey<String>('HomePage'),
    ),
    const FindFoodPage(
      key: PageStorageKey<String>('FindFoodPage'),
    ),
    const HistoryPage(
      key: PageStorageKey<String>('HistoryPage'),
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

    return Scaffold(
      body: Obx(() {
        return PageStorage(bucket: bucket, child: pages[pageVM.idx.value]);
      }),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () {
            return SalomonBottomBar(
              selectedColorOpacity: 0.6,
              backgroundColor: const Color.fromRGBO(255, 164, 91, 1),
              currentIndex: pageVM.idx.value,
              onTap: (i) {
                pageVM.changeIdx(i);
              },
              items: userType == 'member' ? memberList : shopList,
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
