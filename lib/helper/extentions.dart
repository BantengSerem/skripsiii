import 'package:flutter/material.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }

  String hourTo24Hours(){
    final hour = this.hour.toString().padLeft(2, "0");
    return hour;
  }

  String minuteTo24Hours(){
    final min = this.minute.toString().padLeft(2, "0");
    return min;
  }
}