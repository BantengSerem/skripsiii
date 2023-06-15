import 'package:flutter/material.dart';
import 'package:skripsiii/model/shopModel.dart';

class ShopListCard extends StatelessWidget {
  const ShopListCard(
      {Key? key, required this.func, required this.shop, required this.type})
      : super(key: key);
  final Function() func;
  final Shop shop;
  final String type;

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
              margin: const EdgeInsets.all(10),
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
                Text(shop.shopName),
                Row(
                  children: [
                    Text('${shop.distance} km'),
                    const Text(' | '),
                    Row(
                      children: [
                        Text(
                          '${shop.ratingAVG}',
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                  ],
                ),
                type == 'now'
                    ? const Text('Open')
                    : Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Open on  ',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            '${shop.sellingTime.toString().substring(0, 2)}.${shop.sellingTime.toString().substring(2, 4)}',
                            style: const TextStyle(),
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
