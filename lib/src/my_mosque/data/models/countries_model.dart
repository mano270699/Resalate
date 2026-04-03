class CountryModel {
  final int id;
  final String code;
  final String name;
  final String flag;

  CountryModel({
    required this.id,
    required this.code,
    required this.name,
    required this.flag,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      flag: json['flag'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'flag': flag,
    };
  }
}

class CountriesResponseModel {
  final String? status;
  final int? count;
  final List<CountryModel>? countries;

  CountriesResponseModel({
    this.status,
    this.count,
    this.countries,
  });

  factory CountriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CountriesResponseModel(
      status: json['status'] as String,
      count: json['count'] as int,
      countries: (json['countries'] as List)
          .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'count': count,
      'countries': countries?.map((e) => e.toJson()).toList(),
    };
  }
}
