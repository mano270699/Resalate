class LiveFeedDetailsModel {
  String? status;
  Post? post;

  LiveFeedDetailsModel({this.status, this.post});

  LiveFeedDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    post = json['post'] != null ? Post.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (post != null) {
      data['post'] = post!.toJson();
    }
    return data;
  }
}

class Post {
  int? id;
  String? title;
  String? content;
  String? iframe;
  String? date;
  Masjid? masjid;

  Post(
      {this.id, this.title, this.content, this.iframe, this.date, this.masjid});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    iframe = json['iframe'];
    date = json['date'];
    masjid = json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['iframe'] = iframe;
    data['date'] = date;
    if (masjid != null) {
      data['masjid'] = masjid!.toJson();
    }
    return data;
  }
}

class Masjid {
  int? id;
  String? name;
  String? email;
  String? photo;

  Masjid({this.id, this.name, this.email, this.photo});

  Masjid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['photo'] = photo;
    return data;
  }
}
