import 'package:skripsiii/constants/listProvinces.dart';
import 'package:skripsiii/model/provinceModel.dart';

class IndoRepo {
  List<Map> getAll() => indonesia;



  getCityByProvince(String province) {
    List city = indonesia
        .map((map) => ProvinceModel.fromJson(map))
        .where((element) => element.province == province)
        .map((item) => item.cities)
        .toList();

    city = city.expand((element) => element).toList();
    return city;
  }

  List<String?> getProvinces() => indonesia
      .map((map) => ProvinceModel.fromJson(map))
      .map((item) => item.province)
      .toList();
}
