class LiveFeedsResponse {
  final String? status;
  final Pagination? pagination;
  final List<LivePost>? posts;

  LiveFeedsResponse({this.status, this.pagination, this.posts});

  factory LiveFeedsResponse.fromJson(Map<String, dynamic> json) {
    return LiveFeedsResponse(
      status: json['status'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      posts: json['posts'] != null
          ? List<LivePost>.from(json['posts'].map((x) => LivePost.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'pagination': pagination?.toJson(),
        'posts': posts?.map((x) => x.toJson()).toList(),
      };
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

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'per_page': perPage,
        'total_pages': totalPages,
        'total_posts': totalPosts,
        'next_page_url': nextPageUrl,
        'prev_page_url': prevPageUrl,
      };
}

class LivePost {
  final int? id;
  final String? title;
  final String? excerpt;
  final String? content;
  final String? iframe;
  final String? date;
  final Masjid? masjid;

  LivePost({
    this.id,
    this.title,
    this.excerpt,
    this.content,
    this.iframe,
    this.date,
    this.masjid,
  });

  factory LivePost.fromJson(Map<String, dynamic> json) {
    return LivePost(
      id: json['id'],
      title: json['title'],
      excerpt: json['excerpt'],
      content: json['content'],
      iframe: json['iframe'],
      date: json['date'],
      masjid: json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'excerpt': excerpt,
        'content': content,
        'iframe': iframe,
        'date': date,
        'masjid': masjid?.toJson(),
      };
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photo': photo,
      };
}
