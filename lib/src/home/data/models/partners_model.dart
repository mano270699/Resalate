class PartnersResponse {
  String? status;
  String? title;
  List<Partner>? partners;

  PartnersResponse({this.status, this.title, this.partners});

  PartnersResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    title = json['title'];
    if (json['partners'] != null) {
      partners = <Partner>[];
      json['partners'].forEach((v) {
        partners!.add(Partner.fromJson(v));
      });
    }
  }
}

class Partner {
  String? name;
  String? image;
  String? url;

  Partner({this.name, this.image, this.url});

  Partner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    url = json['url'];
  }
}
