import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skripsiii/controller/memberController.dart';
import 'package:skripsiii/controller/shopContoller.dart';
import 'package:skripsiii/transition/slideFadeTransition.dart';
import 'package:skripsiii/view/memberCartPage.dart';
import 'package:skripsiii/view/restaurantOrderMenupage.dart';
import 'package:skripsiii/widget/nodata.dart';
import 'package:skripsiii/widget/shopListCard.dart';

class BrowseRestaurantPage extends StatefulWidget {
  const BrowseRestaurantPage(
      {Key? key, required this.title, required this.type})
      : super(key: key);
  final String title;
  final String type;

  @override
  State<BrowseRestaurantPage> createState() => _BrowseRestaurantPageState();
}

class _BrowseRestaurantPageState extends State<BrowseRestaurantPage> {
  late final String title;
  late final String type;
  late BrowseRestaurantVM pageVM;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    type = widget.type;
    pageVM = Get.put(BrowseRestaurantVM(type));
  }

  @override
  void dispose() {
    Get.delete<BrowseRestaurantVM>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
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
      body: Obx(
        () {
          if (pageVM.isLoading.value) {
            return Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Colors.lightBlue,
                size: 50,
              ),
            );
          } else {
            if (type == 'soon') {
              return ListView.builder(
                controller: pageVM.scrollController,
                itemCount: pageVM.shopController.browseSoonList.length,
                itemBuilder: (context, idx) {
                  return ShopListCard(
                      shop: pageVM.shopController.browseSoonList[idx],
                      type: type,
                      func: () {
                        Get.to(RestaurantOrderMenuPage(
                            shop: pageVM.shopController.browseSoonList[idx]));
                      });
                },
              );
            } else if (type == 'now') {
              return ListView.builder(
                controller: pageVM.scrollController,
                itemCount: pageVM.shopController.browseNowList.length,
                itemBuilder: (context, idx) {
                  return ShopListCard(
                      type: type,
                      shop: pageVM.shopController.browseNowList[idx],
                      func: () {
                        Get.to(RestaurantOrderMenuPage(
                            shop: pageVM.shopController.browseNowList[idx]));
                      });
                },
              );
            }
            return const NoDataWidget();
          }
        },
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: const Color.fromRGBO(255, 218, 119, 1),
            onPressed: () async {
              // var m = pageVM.memberController.member.value;
              // await pageVM.shopController.getBrowseSoon(m);
              // print(pageVM.shopController.browseSoonList);
              // pageVM.shopController.browseSoonList.forEach((element) {
              //   print(element.shopID);
              // });
              pageVM.shopController.test();
              // Navigator.push(
              //     context,
              //     SlideFadeTransition(
              //       child: const MemberCartPage(),
              //     ));
            },
            child: const Icon(
              Icons.shopping_cart,
              color: Color.fromRGBO(56, 56, 56, 1),
            ),
          ),
        ),
      ),
    );
  }
}

class BrowseRestaurantVM extends GetxController {
  final ShopController shopController = Get.find<ShopController>();
  final MemberController memberController = Get.find<MemberController>();
  final RxBool isLoading = false.obs;
  late ScrollController scrollController;
  final String type;

  BrowseRestaurantVM(this.type);

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    if (type == 'soon') {
      await shopController.getBrowseSoon(memberController.member.value);
      shopController.browseSoonList
          .sort((a, b) => a.sellingTime.compareTo(b.sellingTime));
      scrollController = ScrollController();
      scrollController.addListener(scrollListener);
    } else if (type == 'now') {
      await shopController.getBrowseNow(memberController.member.value);
      scrollController = ScrollController();
      scrollController.addListener(scrollListener);
    }

    isLoading.value = false;
  }

  void scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      try {
        isLoading.value = true;
        if (type == 'soon') {
          await shopController.getBrowseSoon(memberController.member.value);
        } else if (type == 'now') {
          await shopController.getBrowseNow(memberController.member.value);
        }
      } catch (e) {
        isLoading.value = false;
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  InternalFinalCallback<void> get onDelete {
    if (type == 'soon') {
      shopController.cleanBrowseSoon();
    } else if (type == 'now') {
      shopController.cleanBrowseNow();
    }

    return super.onDelete;
  }
}
