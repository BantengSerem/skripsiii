import 'package:flutter/material.dart';
import 'package:skripsiii/model/foodModel.dart';

class CartListCard extends StatelessWidget {
  const CartListCard(
      {Key? key,
      required this.foodName,
      required this.qty,
      required this.subPrice,
      required this.foodURL})
      : super(key: key);

  final String foodName;
  final String foodURL;
  final int qty;
  final double subPrice;

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
              foodURL,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 5,),
          Text(
            qty.toString(),
          ),
          const SizedBox(width: 5,),
          Text(
            foodName,
          ),
          const SizedBox(width: 5,),
          Text(
            subPrice.toString(),
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
