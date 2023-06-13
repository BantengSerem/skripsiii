import 'package:flutter/material.dart';
import 'package:skripsiii/model/sharedFoodModel.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    Key? key,
    required this.func,
    required this.sf,
  }) : super(key: key);
  final Function() func;
  final SharedFood sf;

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
                sf.sharedFoodImageURL,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shared by : ',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                Text(
                  sf.memberName,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            )
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(sf.sharedFoodName),
            //     Row(
            //       children: [
            //         Text('${shop.distance} km'),
            //         const Text(' | '),
            //         Row(
            //           children: [
            //             Text(
            //               '${shop.ratingAVG}',
            //             ),
            //             const Icon(
            //               Icons.star,
            //               color: Colors.yellow,
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //     type == 'now'
            //         ? const Text('Open')
            //         : Row(
            //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         const Text(
            //           'Open on  ',
            //           style: TextStyle(
            //             color: Colors.redAccent,
            //           ),
            //         ),
            //         Text(
            //           '${shop.sellingTime.toString().substring(0, 2)}.${shop.sellingTime.toString().substring(2, 4)}',
            //           style: TextStyle(),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
