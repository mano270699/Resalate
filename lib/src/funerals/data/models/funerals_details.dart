class FuneralsDetailsModel {
  String? status;
  Post? post;

  FuneralsDetailsModel({this.status, this.post});

  FuneralsDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? date;
  Masjid? masjid;

  Post({this.id, this.title, this.content, this.image, this.date, this.masjid});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    image = json['image'];
    date = json['date'];
    masjid = json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['image'] = image;
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
