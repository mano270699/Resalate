class HomeDataModel {
  final String logo;
  final String primaryColor;
  final ContactData? contactData;
  final Policy? privacyPolicy;
  final Policy? terms;
  final AboutPage? aboutMobilePage;
  final List<Faq> faq;
  final HomeSection? home;

  HomeDataModel({
    this.logo = "",
    this.primaryColor = "",
    this.contactData,
    this.privacyPolicy,
    this.terms,
    this.aboutMobilePage,
    this.faq = const [],
    this.home,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      logo: json["logo"] ?? "",
      primaryColor: json["primary_color"] ?? "",
      contactData: json["contact_data"] != null
          ? ContactData.fromJson(json["contact_data"])
          : null,
      privacyPolicy: json["privacy_policy"] != null
          ? Policy.fromJson(json["privacy_policy"])
          : null,
      terms: json["terms"] != null ? Policy.fromJson(json["terms"]) : null,
      aboutMobilePage: json["about_mobile_page"] != null
          ? AboutPage.fromJson(json["about_mobile_page"])
          : null,
      faq: (json["faq"] as List<dynamic>?)
              ?.map((e) => Faq.fromJson(e))
              .toList() ??
          [],
      home: json["home"] != null ? HomeSection.fromJson(json["home"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "logo": logo,
        "primary_color": primaryColor,
        "contact_data": contactData?.toJson(),
        "privacy_policy": privacyPolicy?.toJson(),
        "terms": terms?.toJson(),
        "about_mobile_page": aboutMobilePage?.toJson(),
        "faq": faq.map((e) => e.toJson()).toList(),
        "home": home?.toJson(),
      };
}

class ContactData {
  final String phoneEn;
  final String whatsappEn;
  final String emailEn;

  ContactData({
    this.phoneEn = "",
    this.whatsappEn = "",
    this.emailEn = "",
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      phoneEn: json["phone_en"] ?? "",
      whatsappEn: json["whatsapp_en"] ?? "",
      emailEn: json["email_en"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "phone_en": phoneEn,
        "whatsapp_en": whatsappEn,
        "email_en": emailEn,
      };
}

class Policy {
  final String url;
  final int id;
  final String content;

  Policy({
    this.url = "",
    this.id = 0,
    this.content = "",
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      url: json["url"] ?? "",
      id: json["id"] ?? 0,
      content: json["content"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "id": id,
        "content": content,
      };
}

class AboutPage {
  final int id;
  final String url;
  final String title;

  AboutPage({
    this.id = 0,
    this.url = "",
    this.title = "",
  });

  factory AboutPage.fromJson(Map<String, dynamic> json) {
    return AboutPage(
      id: json["id"] ?? 0,
      url: json["url"] ?? "",
      title: json["title"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "title": title,
      };
}

class Faq {
  final String question;
  final String answer;

  Faq({
    this.question = "",
    this.answer = "",
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json["question"] ?? "",
      answer: json["answer"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
      };
}

class HomeSection {
  final List<MediaItem> gallery;
  final List<MediaItem> sponser;
  final String ayah1;
  final AboutSection? aboutSection;
  final Numbers? numbers;
  final String ayah2;

  HomeSection({
    this.gallery = const [],
    this.sponser = const [],
    this.ayah1 = "",
    this.aboutSection,
    this.numbers,
    this.ayah2 = "",
  });

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    return HomeSection(
      gallery: (json["gallery"] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e))
              .toList() ??
          [],
      sponser: (json["sponser"] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e))
              .toList() ??
          [],
      ayah1: json["ayah_1"] ?? "",
      aboutSection: json["about_section"] != null
          ? AboutSection.fromJson(json["about_section"])
          : null,
      numbers:
          json["numbers"] != null ? Numbers.fromJson(json["numbers"]) : null,
      ayah2: json["ayah_2"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "gallery": gallery.map((e) => e.toJson()).toList(),
        "sponser": sponser.map((e) => e.toJson()).toList(),
        "ayah_1": ayah1,
        "about_section": aboutSection?.toJson(),
        "numbers": numbers?.toJson(),
        "ayah_2": ayah2,
      };
}

class MediaItem {
  final int id;
  final String url;
  final String alt;

  MediaItem({
    this.id = 0,
    this.url = "",
    this.alt = "",
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json["id"] ?? 0,
      url: json["url"] ?? "",
      alt: json["alt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "alt": alt,
      };
}

class AboutSection {
  final String title;
  final String description;
  final String link;

  AboutSection({
    this.title = "",
    this.description = "",
    this.link = "",
  });

  factory AboutSection.fromJson(Map<String, dynamic> json) {
    return AboutSection(
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      link: json["link"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "link": link,
      };
}

class Numbers {
  final String title;
  final List<NumberItem> list;

  Numbers({
    this.title = "",
    this.list = const [],
  });

  factory Numbers.fromJson(Map<String, dynamic> json) {
    return Numbers(
      title: json["title"] ?? "",
      list: (json["list"] as List<dynamic>?)
              ?.map((e) => NumberItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "list": list.map((e) => e.toJson()).toList(),
      };
}

class NumberItem {
  final String value;
  final String label;

  NumberItem({
    this.value = "",
    this.label = "",
  });

  factory NumberItem.fromJson(Map<String, dynamic> json) {
    return NumberItem(
      value: json["value"] ?? "",
      label: json["label"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
      };
}
