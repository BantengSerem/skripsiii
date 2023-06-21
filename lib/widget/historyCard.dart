import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsiii/model/sharedFoodModel.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    Key? key,
    required this.func,
    required this.sf,
  }) : super(key: key);
  final Function() func;
  final SharedFood sf;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await func();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          // color: Colors.green,
        ),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    color: Colors.red,
                    height: 80,
                    width: 80,
                    child: Image.network(
                      sf.sharedFoodImageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          sf.sharedFoodName,
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          sf.memberName,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy').format(sf.date),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: 130,
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                'Rp. ${NumberFormat("#,##0.00", "en_US").format(sf.price)}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
