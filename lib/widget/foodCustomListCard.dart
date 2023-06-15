import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsiii/model/foodModel.dart';

class FoodCustomListCard extends StatelessWidget {
  const FoodCustomListCard({Key? key, required this.food, required this.func})
      : super(key: key);
  final Function() func;
  final Food food;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () async {
          await func();
        },
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
                    child: Image.network(food.foodImageURL),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        food.foodName,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Qty : ${food.qty}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Rp. ${NumberFormat("#,##0.00", "en_US").format(food.price)}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
