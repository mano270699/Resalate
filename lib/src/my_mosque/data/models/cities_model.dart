class CityModel {
  final int id;
  final String name;

  CityModel({
    required this.id,
    required this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class CitiesResponseModel {
  final String? status;
  final int? count;
  final int? provinceId;
  final List<CityModel>? cities;

  CitiesResponseModel({
    this.status,
    this.count,
    this.provinceId,
    this.cities,
  });

  factory CitiesResponseModel.fromJson(Map<String, dynamic> json) {
    return CitiesResponseModel(
      status: json['status'] as String,
      count: json['count'] as int,
      provinceId: json['province_id'] as int,
      cities: (json['cities'] as List)
          .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'count': count,
      'province_id': provinceId,
      'cities': cities?.map((e) => e.toJson()).toList(),
    };
  }
}
