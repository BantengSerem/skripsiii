import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsiii/model/sharedFoodModel.dart';

class ProfileSharedCartList extends StatelessWidget {
  const ProfileSharedCartList({Key? key, required this.sf, required this.func})
      : super(key: key);
  final SharedFood sf;
  final Function() func;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        // color: Colors.green,
      ),
      padding: const EdgeInsets.only(right: 15),
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
                  sf.sharedFoodImageURL,
                  fit: BoxFit.cover,
                ),
              ),
              // const SizedBox(
              //   width: 5,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sf.sharedFoodName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    sf.status,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Rp. ${NumberFormat("#,##0.00", "en_US").format(sf.price)}',
                    style: const TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          sf.status == 'onsale'
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () async {
                    await func();
                    // await alertCanceled(context: context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
