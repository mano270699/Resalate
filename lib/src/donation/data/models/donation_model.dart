class DonationsResponse {
  final String? status;
  final Pagination? pagination;
  final List<Post>? posts;

  DonationsResponse({this.status, this.pagination, this.posts});

  factory DonationsResponse.fromJson(Map<String, dynamic> json) {
    return DonationsResponse(
      status: json['status'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      posts: json['posts'] != null
          ? List<Post>.from(json['posts'].map((x) => Post.fromJson(x)))
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

class Post {
  final int? id;
  final String? title;
  final String? excerpt;
  final String? content;
  final String? image;
  final String? date;
  final Donation? donation;
  final Masjid? masjid;

  Post({
    this.id,
    this.title,
    this.excerpt,
    this.content,
    this.image,
    this.date,
    this.donation,
    this.masjid,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      excerpt: json['excerpt'],
      content: json['content'],
      image: json['image'],
      date: json['date'],
      donation:
          json['donation'] != null ? Donation.fromJson(json['donation']) : null,
      masjid: json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'excerpt': excerpt,
        'content': content,
        'image': image,
        'date': date,
        'donation': donation?.toJson(),
        'masjid': masjid?.toJson(),
      };
}

class Donation {
  final int? total;
  final int? paid;
  final String? currency;
  final int? percent;

  Donation({this.total, this.paid, this.currency, this.percent});

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      total: json['total'],
      paid: json['paid'],
      currency: json['currency'],
      percent: json['percent'],
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'paid': paid,
        'currency': currency,
        'percent': percent,
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
