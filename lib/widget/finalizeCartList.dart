import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsiii/model/cart.dart';

class FinalizeCartList extends StatelessWidget {
  const FinalizeCartList({Key? key, required this.c}) : super(key: key);

  final Cart c;

  // final String imgURL;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.5),
        )
            // border: Border.symmetric(
            //   horizontal: BorderSide(color: Colors.grey, width: 1.5),
            // ),
            // color: Colors.redAccent,
            ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  width: 70,
                  height: 70,
                  child: Image.network(c.imgURL),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      c.foodName,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'Rp. : ${NumberFormat("#,##0.00", "en_US").format(c.subPrice)}',
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              child: Text('Qty : ${c.qty}'),
            )
          ],
        ),
      ),
    );
  }
}
