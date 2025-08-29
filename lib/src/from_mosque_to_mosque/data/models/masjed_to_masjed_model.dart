class MasjedToMasjedModel {
  String? status;
  Pagination? pagination;
  List<Posts>? posts;

  MasjedToMasjedModel({this.status, this.pagination, this.posts});

  MasjedToMasjedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? totalPages;
  int? totalPosts;
  dynamic nextPageUrl;
  dynamic prevPageUrl;

  Pagination(
      {this.currentPage,
      this.perPage,
      this.totalPages,
      this.totalPosts,
      this.nextPageUrl,
      this.prevPageUrl});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    totalPages = json['total_pages'];
    totalPosts = json['total_posts'];
    nextPageUrl = json['next_page_url'];
    prevPageUrl = json['prev_page_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    data['total_pages'] = totalPages;
    data['total_posts'] = totalPosts;
    data['next_page_url'] = nextPageUrl;
    data['prev_page_url'] = prevPageUrl;
    return data;
  }
}

class Posts {
  int? id;
  String? title;
  String? excerpt;
  String? content;
  String? image;
  String? date;
  List<Categories>? categories;
  Masjid? masjid;

  Posts(
      {this.id,
      this.title,
      this.excerpt,
      this.content,
      this.image,
      this.date,
      this.categories,
      this.masjid});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    excerpt = json['excerpt'];
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
    data['excerpt'] = excerpt;
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
