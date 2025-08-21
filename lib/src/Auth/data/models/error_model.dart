class RegisterErrorModel {
  String? status;
  List<String>? errors;

  RegisterErrorModel({this.status, this.errors});

  RegisterErrorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errors = json['errors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['errors'] = errors;
    return data;
  }
}
