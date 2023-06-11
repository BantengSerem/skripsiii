import 'package:flutter/material.dart';

class ShopListCard extends StatelessWidget {
  const ShopListCard({Key? key, required this.func}) : super(key: key);
  final Function() func;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await func();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          // color: Colors.green,
        ),
        height: 100,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              color: Colors.red,
              height: 80,
              width: 80,
              child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/5223/5223909.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Restaurant'),
                Row(
                  children: [
                    const Text('0.0 km'),
                    const Text(' | '),
                    Row(
                      children: const [
                        Text(
                          '5',
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                  ],
                ),
                const Text('Open'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
