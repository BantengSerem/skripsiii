import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:skripsiii/view/FindFoodPage.dart';
import 'package:skripsiii/view/historyPage.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/testpage3.dart';

class BottomNavigationPage extends StatelessWidget {
  BottomNavigationPage({Key? key}) : super(key: key);

  // final HomeVM homeVM = Get.put(HomeVM());
  // final HistoryPageVM historyVM = Get.put(HistoryPageVM());

  final BottomNavController pageVM =
      Get.put<BottomNavController>(BottomNavController(), permanent: false);

  final List<Widget> pages = [
    HomePage(
      key: PageStorageKey<String>('HomePage'),
    ),
    const FindFoodPage(
      key: PageStorageKey<String>('FindFoodPage'),
    ),
    const HistoryPage(
      key: PageStorageKey<String>('HistoryPage'),
    ),
    // const TestPage2(
    //   key: PageStorageKey<String>('TestPage2'),
    // ),
    const TestPage3(
      key: PageStorageKey<String>('TestPage3'),
    ),
  ];
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
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
                items: [
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
                ],
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
