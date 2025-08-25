class LessonsResponse {
  final String? status;
  final Pagination? pagination;
  final List<Lesson>? lessons;

  LessonsResponse({this.status, this.pagination, this.lessons});

  factory LessonsResponse.fromJson(Map<String, dynamic> json) {
    return LessonsResponse(
      status: json['status'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((x) => Lesson.fromJson(x))
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

class Lesson {
  final int? id;
  final String? title;
  final String? excerpt;
  final String? content;
  final String? image;
  final String? date;
  final List<Category>? categories;
  final Masjid? masjid;

  Lesson({
    this.id,
    this.title,
    this.excerpt,
    this.content,
    this.image,
    this.date,
    this.categories,
    this.masjid,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      excerpt: json['excerpt'],
      content: json['content'],
      image: json['image'],
      date: json['date'],
      categories: (json['categories'] as List<dynamic>?)
          ?.map((x) => Category.fromJson(x))
          .toList(),
      masjid: json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null,
    );
  }
}

class Category {
  final int? id;
  final String? name;
  final String? slug;

  Category({this.id, this.name, this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
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
