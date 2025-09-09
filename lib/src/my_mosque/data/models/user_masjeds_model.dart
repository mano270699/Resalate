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
  String? email;
  String? photo;
  String? profileUrl;

  Masjids({this.id, this.name, this.email, this.photo, this.profileUrl});

  Masjids.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    photo = json['photo'];
    profileUrl = json['profile_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['photo'] = photo;
    data['profile_url'] = profileUrl;
    return data;
  }
}
