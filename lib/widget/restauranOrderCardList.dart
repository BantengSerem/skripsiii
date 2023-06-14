import 'package:flutter/material.dart';
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
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.all(
        //   Radius.circular(10),
        // ),
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
        // color: Colors.redAccent,
      ),
      child: InkWell(
        onTap: () async {
          await func();
        },
        child: Row(
          children: [
            Column(
              children: [
                Text(t.date.toString()),
                Text(t.memberName),
                Text(t.totalPrice.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
