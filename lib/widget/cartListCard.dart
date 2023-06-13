import 'package:flutter/material.dart';
import 'package:skripsiii/model/foodModel.dart';

class CartListCard extends StatelessWidget {
  const CartListCard({Key? key, required this.food}) : super(key: key);

  final Food food;
  @override
  Widget build(BuildContext context) {
    return Container(
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
              food.foodImageURL,
              fit: BoxFit.cover,
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text('${food.shopName}'),
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
    );
  }
}
