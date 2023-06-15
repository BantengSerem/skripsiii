import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsiii/model/transctionShareFood.dart';

class HistoryCartListShareFoodBuy extends StatelessWidget {
  const HistoryCartListShareFoodBuy({Key? key, required this.tsf})
      : super(key: key);

  final TransactionShareFoodModel tsf;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1))
        // color: Colors.green,
      ),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                // color: Colors.red,
                height: 80,
                width: 80,
                child: Image.asset(
                  'data/images/cartIn.png',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tsf.sharedFoodName,
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat('dd MMMM yyyy').format(tsf.date),
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'seller : ${tsf.memberSellName}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              'Rp. ${NumberFormat("#,##0.00", "en_US").format(tsf.price)}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }
}