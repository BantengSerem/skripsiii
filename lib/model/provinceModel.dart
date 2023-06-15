class ProvinceModel {
  String? province;
  List<String>? cities;

  ProvinceModel({this.province, this.cities});

  ProvinceModel.fromJson(Map<String, dynamic> json)
      : province = json['provinsi'],
        cities = json['kota'].cast<String>();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provinsi'] = province;
    data['kota'] = cities;
    return data;
  }
}
