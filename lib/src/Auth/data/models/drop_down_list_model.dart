class DropDownListValuesModel {
  List<String>? tutorProvincesList;
  List<String>? tutorUniversitysList;

  DropDownListValuesModel({this.tutorProvincesList, this.tutorUniversitysList});

  DropDownListValuesModel.fromJson(Map<String, dynamic> json) {
    tutorProvincesList = json['tutor_provinces_list'].cast<String>();
    tutorUniversitysList = json['tutor_universitys_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tutor_provinces_list'] = tutorProvincesList;
    data['tutor_universitys_list'] = tutorUniversitysList;
    return data;
  }
}
