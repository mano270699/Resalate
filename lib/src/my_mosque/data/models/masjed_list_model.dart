class MasjidListResponse {
  final String? status;
  final int? currentPage;
  final int? perPage;
  final int? total;
  final int? totalPages;
  final List<Masjid>? masjids;

  MasjidListResponse({
    this.status,
    this.currentPage,
    this.perPage,
    this.total,
    this.totalPages,
    this.masjids,
  });

  factory MasjidListResponse.fromJson(Map<String, dynamic> json) {
    return MasjidListResponse(
      status: json["status"],
      currentPage: json["current_page"],
      perPage: json["per_page"],
      total: json["total"],
      totalPages: json["total_pages"],
      masjids:
          (json["masjids"] as List).map((e) => Masjid.fromJson(e)).toList(),
    );
  }
}

class Masjid {
  final int? id;
  final String? name;
  final String? image; // profile image
  final String? cover; // cover image
  final String? excerpt;
  final String? email;
  final String? phone;
  final List<Language>? languages;
  final String? country;
  final String? province;
  final String? city;
  final String? location;
  final double? lat;
  final double? lng;
  int isFollowing; // Added to handle local state update

  Masjid({
    this.location,
    this.lat,
    this.lng,
    this.id,
    this.name,
    this.image,
    this.cover,
    this.excerpt,
    this.email,
    this.phone,
    this.languages,
    this.country,
    this.province,
    this.city,
    this.isFollowing = 0,
  });

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return Masjid(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      cover: json["cover"],
      excerpt: json["excerpt"] ?? "",
      email: json["email"],
      phone: json["phone"],
      languages: (json["languages"] is List)
          ? (json["languages"] as List)
              .map((e) => Language.fromJson(e))
              .toList()
          : <Language>[],
      country: json["country"],
      province: json["province"],
      city: json["city"],
      lat: json["lat"],
      lng: json["lng"],
      location: json["location"],
      isFollowing: json["is_following"] ?? 0,
    );
  }
}

class Language {
  final String title;

  Language({required this.title});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(title: json["title"]);
  }
}
