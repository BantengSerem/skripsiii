import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key, required this.func, required this.title})
      : super(key: key);
  final Function() func;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      // color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () async {
          await func();
        },
        child: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
            // color: Colors.redAccent,
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
