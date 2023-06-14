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
      height: 80,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: InkWell(
        onTap: () async {
          await func();
        },
        child: Row(
          children: [
            Container(
              color: Colors.redAccent,
              width: 80,
              child: Column(
                children: [
                  Text(t.transactionID),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
