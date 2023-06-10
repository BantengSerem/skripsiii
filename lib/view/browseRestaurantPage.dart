import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsiii/widget/shopListCard.dart';

class BrowseRestaurantPage extends StatelessWidget {
  const BrowseRestaurantPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, idx) {
          return ShopListCard(func: () {});
        },
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.shopping_cart),
          ),
        ),
      ),
    );
  }
}

class BrowseRestaurantVM extends GetxController {}
