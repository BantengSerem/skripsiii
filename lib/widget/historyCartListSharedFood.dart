import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsiii/model/sharedFoodModel.dart';
import 'package:skripsiii/model/transactionModel.dart';
import 'package:skripsiii/model/transctionShareFood.dart';

class HistoryCartListShareFoodSell extends StatelessWidget {
  const HistoryCartListShareFoodSell({Key? key, required this.tsf})
      : super(key: key);

  final TransactionShareFoodModel tsf;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
                margin: EdgeInsets.all(10),
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
                    'buyer : ${tsf.memberBuyName}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              'Rp. ${tsf.price}',
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
