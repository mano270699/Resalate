class FCMTokenModel {
  String? status;
  String? message;
  int? userId;
  String? fcmToken;

  FCMTokenModel({this.status, this.message, this.userId, this.fcmToken});

  FCMTokenModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    fcmToken = json['fcm_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['user_id'] = userId;
    data['fcm_token'] = fcmToken;
    return data;
  }
}
