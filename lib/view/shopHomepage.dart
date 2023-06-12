import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopHomePage extends StatelessWidget {
  const ShopHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShopHomeVM pageVM = Get.put(ShopHomeVM());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                'Selling Hour',
                style: TextStyle(),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              // width: MediaQuery.of(context).size.width * 0.8,
              child: const Text(
                'Incoming Order',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 500,
              margin: EdgeInsets.symmetric(horizontal: 20),
              // width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, idx) {
                  return Container(
                    color: Colors.yellow,
                    height: 150,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShopHomeVM extends GetxController {}
