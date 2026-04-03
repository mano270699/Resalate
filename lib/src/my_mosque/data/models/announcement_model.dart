class AnnouncementsResponse {
  String? status;
  Pagination? pagination;
  List<Announcement>? announcements;

  AnnouncementsResponse({this.status, this.pagination, this.announcements});

  AnnouncementsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['announcements'] != null) {
      announcements = <Announcement>[];
      json['announcements'].forEach((v) {
        announcements!.add(Announcement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (announcements != null) {
      data['announcements'] = announcements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnnouncementDetailsResponse {
  String? status;
  Announcement? announcement;

  AnnouncementDetailsResponse({this.status, this.announcement});

  AnnouncementDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    announcement = json['announcement'] != null
        ? Announcement.fromJson(json['announcement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (announcement != null) {
      data['announcement'] = announcement!.toJson();
    }
    return data;
  }
}

class Announcement {
  int? id;
  String? title;
  String? excerpt;
  String? content;
  String? image;
  String? date;
  AnnouncementMasjid? masjid;

  Announcement({
    this.id,
    this.title,
    this.excerpt,
    this.content,
    this.image,
    this.date,
    this.masjid,
  });

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    excerpt = json['excerpt'];
    content = json['content'];
    image = json['image'];
    date = json['date'];
    masjid = json['masjid'] != null
        ? AnnouncementMasjid.fromJson(json['masjid'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['excerpt'] = excerpt;
    data['content'] = content;
    data['image'] = image;
    data['date'] = date;
    if (masjid != null) {
      data['masjid'] = masjid!.toJson();
    }
    return data;
  }
}

class AnnouncementMasjid {
  int? id;
  String? name;
  String? email;
  String? photo;

  AnnouncementMasjid({this.id, this.name, this.email, this.photo});

  AnnouncementMasjid.fromJson(Map<String, dynamic> json) {
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

class Pagination {
  int? currentPage;
  int? perPage;
  int? totalPages;
  int? totalPosts;
  String? nextPageUrl;
  String? prevPageUrl;

  Pagination({
    this.currentPage,
    this.perPage,
    this.totalPages,
    this.totalPosts,
    this.nextPageUrl,
    this.prevPageUrl,
  });

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
