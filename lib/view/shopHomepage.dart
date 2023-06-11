import 'package:flutter/material.dart';

class ShopHomePage extends StatelessWidget {
  const ShopHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant'),
      ),
      body: Row(
        children: [
          Text('Selling Hour'),

        ],
      ),
    );
  }
}
