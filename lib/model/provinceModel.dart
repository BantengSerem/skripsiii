class ProvinceModel {
  String? _province;
  List<String>? _cities;

  ProvinceModel({String? province, List<String>? cities}) :
        _province = province,
        _cities = cities;

  ProvinceModel.fromJson(Map<String, dynamic> json)
      : _province = json['provinsi'],
        _cities = json['kota'].cast<String>();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provinsi'] = _province;
    data['kota'] = _cities;
    return data;
  }

  List<String> get cities => _cities!;

  set cities(List<String> value) {
    _cities = value;
  }

  String get province => _province!;

  set province(String value) {
    _province = value;
  }
}
