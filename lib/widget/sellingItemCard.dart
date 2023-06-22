import 'package:flutter/material.dart';

class SellingItemCard extends StatelessWidget {
  const SellingItemCard({
    Key? key,
    required this.func,
    required this.data,
    required this.type,
  }) : super(key: key);
  final Function() func;
  final Map<String, dynamic> data;

  final String type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        func();
      },
      child: Container(
        height: 220,
        width: 150,
        // color: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // color: Colors.yellow,
              width: 150,
              height: 130,
              child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/5223/5223909.png',
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
                  children: [
                    Text(
                      '${data['ratingAVG'].toStringAsFixed(2) ?? ''}',
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

            type == 'sellingNow' ? const Text(
              'Open',
              style: TextStyle(color: Colors.green, fontSize: 15),
            ): Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Open on  ',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                Text(
                  '${data['sellingTime'].toString().substring(0,2)}.${data['sellingTime'].toString().substring(2,4)}',
                  style: const TextStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
