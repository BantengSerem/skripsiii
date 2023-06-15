import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsiii/model/transactionModel.dart';

class RestaurantOrderCartList extends StatelessWidget {
  const RestaurantOrderCartList({Key? key, required this.t, required this.func})
      : super(key: key);
  final TransactionModel t;
  final Function() func;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1,),
        ),
        // color: Colors.red,
      ),
      child: InkWell(
        onTap: () async {
          await func();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.memberName,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat('dd MMMM yyyy, HH:mm').format(t.date),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              'Rp. ${NumberFormat("#,##0.00", "en_US").format(t.totalPrice)}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
