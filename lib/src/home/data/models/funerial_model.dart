class FuneralsResponse {
  final String? status;
  final Pagination? pagination;
  final List<FuneralPost>? posts;

  FuneralsResponse({this.status, this.pagination, this.posts});

  factory FuneralsResponse.fromJson(Map<String, dynamic> json) {
    return FuneralsResponse(
      status: json['status'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      posts: (json['posts'] as List<dynamic>?)
          ?.map((x) => FuneralPost.fromJson(x))
          .toList(),
    );
  }
}

class Pagination {
  final int? currentPage;
  final int? perPage;
  final int? totalPages;
  final int? totalPosts;
  final String? nextPageUrl;
  final String? prevPageUrl;

  Pagination({
    this.currentPage,
    this.perPage,
    this.totalPages,
    this.totalPosts,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      perPage: json['per_page'],
      totalPages: json['total_pages'],
      totalPosts: json['total_posts'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }
}

class FuneralPost {
  final int? id;
  final String? title;
  final String? excerpt;
  final String? content;
  final String? image;
  final String? date;
  final Masjid? masjid;

  FuneralPost({
    this.id,
    this.title,
    this.excerpt,
    this.content,
    this.image,
    this.date,
    this.masjid,
  });

  factory FuneralPost.fromJson(Map<String, dynamic> json) {
    return FuneralPost(
      id: json['id'],
      title: json['title'],
      excerpt: json['excerpt'],
      content: json['content'],
      image: json['image'],
      date: json['date'],
      masjid: json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null,
    );
  }
}

class Masjid {
  final int? id;
  final String? name;
  final String? email;
  final String? photo;

  Masjid({this.id, this.name, this.email, this.photo});

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return Masjid(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}
