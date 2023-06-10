import 'package:flutter/material.dart';

class FindFoodPage extends StatefulWidget {
  const FindFoodPage({Key? key}) : super(key: key);

  @override
  State<FindFoodPage> createState() => _FindFoodPageState();
}

class _FindFoodPageState extends State<FindFoodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Food'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, idx) {
            return Container(
              height: 80,
              color: Colors.yellow,
            );
          },
        ),
      ),
    );
  }
}
