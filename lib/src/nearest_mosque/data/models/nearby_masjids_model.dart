class NearbyMasjidsModel {
  String? status;
  int? count;
  List<Masjids>? masjids;

  NearbyMasjidsModel({this.status, this.count, this.masjids});

  NearbyMasjidsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
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
    data['count'] = count;
    if (masjids != null) {
      data['masjids'] = masjids!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Masjids {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  double? lat;
  double? lng;
  String? mapUrl;
  String? country;
  String? province;
  String? city;
  String? distance;

  Masjids(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.image,
      this.lat,
      this.lng,
      this.mapUrl,
      this.country,
      this.province,
      this.city,
      this.distance});

  Masjids.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    lat = json['lat'];
    lng = json['lng'];
    mapUrl = json['map_url'];
    country = json['country'];
    province = json['province'];
    city = json['city'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['lat'] = lat;
    data['lng'] = lng;
    data['map_url'] = mapUrl;
    data['country'] = country;
    data['province'] = province;
    data['city'] = city;
    data['distance'] = distance;
    return data;
  }
}
