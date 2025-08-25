class NotificationBody {
  int? courseId;
  String? url;

  NotificationBody({
    this.courseId,
    this.url,
  });

  NotificationBody.fromJson(Map<String, dynamic> json) {
    courseId = json['course_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['course_id'] = courseId;
    data['url'] = url;
    return data;
  }
}
