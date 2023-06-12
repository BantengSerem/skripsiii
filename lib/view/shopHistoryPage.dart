import 'package:flutter/material.dart';

class ShopHistoryPage extends StatelessWidget {
  const ShopHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, idx) {
          return Container(
            height: 150,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.redAccent,
          );
        },
      ),
    );
  }
}
