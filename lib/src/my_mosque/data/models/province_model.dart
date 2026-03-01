class ProvinceModel {
  final int id;
  final String code;
  final String name;

  ProvinceModel({
    required this.id,
    required this.code,
    required this.name,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }
}

class ProvincesResponseModel {
  final String? status;
  final int? count;
  final int? countryId;
  final List<ProvinceModel>? provinces;

  ProvincesResponseModel({
    this.status,
    this.count,
    this.countryId,
    this.provinces,
  });

  factory ProvincesResponseModel.fromJson(Map<String, dynamic> json) {
    return ProvincesResponseModel(
      status: json['status'] as String,
      count: json['count'] as int,
      countryId: json['country_id'] as int,
      provinces: (json['provinces'] as List)
          .map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'count': count,
      'country_id': countryId,
      'provinces': provinces?.map((e) => e.toJson()).toList(),
    };
  }
}
