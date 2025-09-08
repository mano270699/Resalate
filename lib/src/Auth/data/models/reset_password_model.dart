class ResetPasswordResponse {
  String? status;
  String? message;
  String? token;

  ResetPasswordResponse({this.status, this.message, this.token});

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    return data;
  }
}
