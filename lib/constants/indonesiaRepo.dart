import 'package:get/get.dart';
import 'package:skripsiii/constants/listProvinces.dart';
import 'package:skripsiii/controller/registerController.dart';
import 'package:skripsiii/model/provinceModel.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

class IndoRepo {
  List<Map> getAll() => indonesia;

  // getCityByProvince(String province) => indonesia
  //     .map((map) => ProvinceModel.fromJson(map))
  //     .where((element) => element.province == province)
  //     .map((item) => item.cities)
  //     .toString();

  getCityByProvince(String province) {
    List city = indonesia
        .map((map) => ProvinceModel.fromJson(map))
        .where((element) => element.province == province)
        .map((item) => item.cities)
        .toList();

    city = city.expand((element) => element).toList();
    // devtools.log(city.toString());
    return city;
  }

  List<String?> getProvinces() => indonesia
      .map((map) => ProvinceModel.fromJson(map))
      .map((item) => item.province)
      .toList();
}
