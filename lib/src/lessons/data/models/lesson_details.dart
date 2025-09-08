class LessonDetailsModel {
  String? status;
  Lesson? lesson;

  LessonDetailsModel({this.status, this.lesson});

  LessonDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    lesson = json['lesson'] != null ? Lesson.fromJson(json['lesson']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (lesson != null) {
      data['lesson'] = lesson!.toJson();
    }
    return data;
  }
}

class Lesson {
  int? id;
  String? title;
  String? content;
  String? image;
  String? date;
  List<Categories>? categories;
  Masjid? masjid;

  Lesson(
      {this.id,
      this.title,
      this.content,
      this.image,
      this.date,
      this.categories,
      this.masjid});

  Lesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    image = json['image'];
    date = json['date'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    masjid = json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['image'] = image;
    data['date'] = date;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (masjid != null) {
      data['masjid'] = masjid!.toJson();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? slug;

  Categories({this.id, this.name, this.slug});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
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
