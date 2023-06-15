import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                color: Colors.red,
                height: 80,
                width: 80,
                child: Image.network(
                  foodURL,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Qty : ${qty.toString()}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          Text(
            'Rp. ${NumberFormat("#,##0.00", "en_US").format(subPrice)}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
