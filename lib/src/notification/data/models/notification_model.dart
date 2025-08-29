class NotificationModel {
  String? status;
  int? count;
  List<Notifications>? notifications;

  NotificationModel({this.status, this.count, this.notifications});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['count'] = count;
    if (notifications != null) {
      data['notifications'] = notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int? id;
  String? title;
  int? postId;
  dynamic postUrl;
  String? postType;
  bool? seen;
  String? createdAt;

  Notifications(
      {this.id,
      this.title,
      this.postId,
      this.postUrl,
      this.postType,
      this.seen,
      this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    postId = json['post_id'];
    postUrl = json['post_url'];
    postType = json['post_type'];
    seen = json['seen'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['post_id'] = postId;
    data['post_url'] = postUrl;
    data['post_type'] = postType;
    data['seen'] = seen;
    data['created_at'] = createdAt;
    return data;
  }
}
