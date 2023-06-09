import 'package:flutter/material.dart';

class SellingItemCard extends StatelessWidget {
  const SellingItemCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('item kepencet');
      },
      child: Container(
        height: 220,
        width: 150,
        // color: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // color: Colors.yellow,
              width: 150,
              height: 130,
              child: Image.network(
                'https://kbu-cdn.com/dk/wp-content/uploads/rendang-daging-sapi-pedas.jpg',
                fit: BoxFit.cover,
              ),
            ),const SizedBox(
              height: 5,
            ),
            const Text(
              'restaurant',
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '0 Km',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
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
            ),const SizedBox(
              height: 5,
            ),
            const Text(
              'Open',
              style: TextStyle(
                color: Colors.green,
                fontSize: 15
              ),
            ),
          ],
        ),
      ),
    );
  }
}