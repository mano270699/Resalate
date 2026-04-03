class UserMasjedsModel {
  String? status;
  List<Masjids>? masjids;

  UserMasjedsModel({this.status, this.masjids});

  UserMasjedsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['masjids'] != null) {
      masjids = <Masjids>[];
      json['masjids'].forEach((v) {
        masjids!.add(Masjids.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (masjids != null) {
      data['masjids'] = masjids!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Masjids {
  int? id;
  String? name;
  String? description;
  String? email;
  String? phone;
  String? image; // profile image
  String? cover; // cover/banner image
  String? country;
  String? province;
  String? city;
  List<MasjidLanguage>? languages;
  double? lat;
  double? lng;
  bool isFollowing;

  Masjids({
    this.id,
    this.name,
    this.description,
    this.email,
    this.phone,
    this.image,
    this.cover,
    this.country,
    this.province,
    this.city,
    this.languages,
    this.lat,
    this.lng,
    this.isFollowing = true,
  });

  Masjids.fromJson(Map<String, dynamic> json)
      : isFollowing = json['is_following'] ?? true {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    country = json['country'];
    province = json['province'];
    city = json['city'];
    if (json['languages'] != null) {
      languages = <MasjidLanguage>[];
      json['languages'].forEach((v) {
        languages!.add(MasjidLanguage.fromJson(v));
      });
    }
    lat = (json['lat'] as num?)?.toDouble();
    lng = (json['lng'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['cover'] = cover;
    data['country'] = country;
    data['province'] = province;
    data['city'] = city;
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    data['lat'] = lat;
    data['lng'] = lng;
    data['is_following'] = isFollowing;
    return data;
  }
}

class MasjidLanguage {
  String title;

  MasjidLanguage({required this.title});

  MasjidLanguage.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '';

  Map<String, dynamic> toJson() => {'title': title};
}
