import 'package:flutter/material.dart';

class SellingItemCard extends StatelessWidget {
  const SellingItemCard({Key? key, required this.func, required this.data})
      : super(key: key);
  final Function() func;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        func();
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
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              data['shopName'],
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data['distance']} Km',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children:  [
                    Text(
                      '${data['ratingAVG'] ?? ''}',
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Open',
              style: TextStyle(color: Colors.green, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
