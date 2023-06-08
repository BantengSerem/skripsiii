import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:skripsiii/view/homePage.dart';
import 'package:skripsiii/view/testPage2.dart';
import 'package:skripsiii/view/testpage1.dart';
import 'package:skripsiii/view/testpage3.dart';

class BottomNavigationPage extends StatelessWidget {
  BottomNavigationPage({Key? key}) : super(key: key);

  final BotomNavController pageVM =
      Get.put<BotomNavController>(BotomNavController());
  final List<Widget> pages = [
    HomePage(
      key: const PageStorageKey('Page1'),
    ),
    const TestPage1(
      key: PageStorageKey('page 1}'),
    ),
    const TestPage2(
      key: PageStorageKey('page 2}'),
    ),
    const TestPage3(
      key: PageStorageKey('page 3}'),
    ),
  ];
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
          () => PageStorage(bucket: bucket, child: pages[pageVM.idx.value])),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => SalomonBottomBar(
            currentIndex: pageVM.idx.value,
            onTap: (i) {
              pageVM.changeIdx(i);
            },
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: const Icon(Icons.home),
                title: const Text("Home"),
                selectedColor: Colors.purple,
              ),

              /// Likes
              SalomonBottomBarItem(
                icon: const Icon(Icons.favorite_border),
                title: const Text("Likes"),
                selectedColor: Colors.pink,
              ),

              /// Search
              SalomonBottomBarItem(
                icon: const Icon(Icons.search),
                title: const Text("Search"),
                selectedColor: Colors.orange,
              ),

              /// Profile
              SalomonBottomBarItem(
                icon: const Icon(Icons.person),
                title: const Text("Profile"),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BotomNavController extends GetxController {
  RxInt idx = 0.obs;

  void changeIdx(int i) {
    idx.value = i;
  }
}
