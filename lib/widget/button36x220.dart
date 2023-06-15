import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Button36x220 extends StatelessWidget {
  String text;
  Function() func;

  Button36x220({Key? key, required this.text, required this.func})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 220,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(174, 230, 230, 1.0)),
        onPressed: () async {
          func();
        },
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromRGBO(56, 56, 56, 1),
          ),
        ),
      ),
    );
  }
}
