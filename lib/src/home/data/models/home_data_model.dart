class HomeDataModel {
  String? logo;
  String? primaryColor;
  ContactData? contactData;
  PrivacyPolicy? privacyPolicy;
  PrivacyPolicy? terms;
  AboutMobilePage? aboutMobilePage;
  List<Faq>? faq;
  Home? home;

  HomeDataModel({
    this.logo,
    this.primaryColor,
    this.contactData,
    this.privacyPolicy,
    this.terms,
    this.aboutMobilePage,
    this.faq,
    this.home,
  });

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    primaryColor = json['primary_color'];
    contactData = json['contact_data'] != null
        ? ContactData.fromJson(json['contact_data'])
        : null;
    privacyPolicy = json['privacy_policy'] != null
        ? PrivacyPolicy.fromJson(json['privacy_policy'])
        : null;
    terms =
        json['terms'] != null ? PrivacyPolicy.fromJson(json['terms']) : null;
    aboutMobilePage = json['about_mobile_page'] != null
        ? AboutMobilePage.fromJson(json['about_mobile_page'])
        : null;
    if (json['faq'] != null) {
      faq = (json['faq'] as List).map((v) => Faq.fromJson(v)).toList();
    }
    home = json['home'] != null ? Home.fromJson(json['home']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['logo'] = logo;
    data['primary_color'] = primaryColor;
    if (contactData != null) data['contact_data'] = contactData!.toJson();
    if (privacyPolicy != null) data['privacy_policy'] = privacyPolicy!.toJson();
    if (terms != null) data['terms'] = terms!.toJson();
    if (aboutMobilePage != null) {
      data['about_mobile_page'] = aboutMobilePage!.toJson();
    }
    if (faq != null) data['faq'] = faq!.map((v) => v.toJson()).toList();
    if (home != null) data['home'] = home!.toJson();
    return data;
  }
}

class ContactData {
  String? phoneEn;
  String? whatsappEn;
  String? emailEn;

  ContactData({this.phoneEn, this.whatsappEn, this.emailEn});

  ContactData.fromJson(Map<String, dynamic> json) {
    phoneEn = json['phone_en'];
    whatsappEn = json['whatsapp_en'];
    emailEn = json['email_en'];
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_en': phoneEn,
      'whatsapp_en': whatsappEn,
      'email_en': emailEn,
    };
  }
}

class PrivacyPolicy {
  String? url;
  int? id;
  String? content;

  PrivacyPolicy({this.url, this.id, this.content});

  PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    id = json['id'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'id': id,
      'content': content,
    };
  }
}

class AboutMobilePage {
  int? id;
  String? url;
  String? title;

  AboutMobilePage({this.id, this.url, this.title});

  AboutMobilePage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
    };
  }
}

class Faq {
  String? question;
  String? answer;

  Faq({this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class Home {
  List<Gallery>? gallery;
  List<Sponsor>? sponsor;
  String? ayah1;
  AboutSection? aboutSection;
  Numbers? numbers;
  String? ayah2;

  Home({
    this.gallery,
    this.sponsor,
    this.ayah1,
    this.aboutSection,
    this.numbers,
    this.ayah2,
  });

  Home.fromJson(Map<String, dynamic> json) {
    if (json['gallery'] != null) {
      gallery =
          (json['gallery'] as List).map((v) => Gallery.fromJson(v)).toList();
    }
    if (json['sponser'] != null) {
      sponsor =
          (json['sponser'] as List).map((v) => Sponsor.fromJson(v)).toList();
    }
    ayah1 = json['ayah_1'];
    aboutSection = json['about_section'] != null
        ? AboutSection.fromJson(json['about_section'])
        : null;
    numbers =
        json['numbers'] != null ? Numbers.fromJson(json['numbers']) : null;
    ayah2 = json['ayah_2'];
  }

  Map<String, dynamic> toJson() {
    return {
      'gallery': gallery?.map((v) => v.toJson()).toList(),
      'sponser': sponsor?.map((v) => v.toJson()).toList(),
      'ayah_1': ayah1,
      'about_section': aboutSection?.toJson(),
      'numbers': numbers?.toJson(),
      'ayah_2': ayah2,
    };
  }
}

class Gallery {
  int? id;
  String? url;
  String? alt;

  Gallery({this.id, this.url, this.alt});

  Gallery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    alt = json['alt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'alt': alt,
    };
  }
}

class AboutSection {
  String? title;
  String? description;
  String? link;

  AboutSection({this.title, this.description, this.link});

  AboutSection.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'link': link,
    };
  }
}

class Numbers {
  String? title;
  List<NumberItem>? list;

  Numbers({this.title, this.list});

  Numbers.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['list'] != null) {
      list = (json['list'] as List).map((v) => NumberItem.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'list': list?.map((v) => v.toJson()).toList(),
    };
  }
}

/// ✅ Renamed from `List` to avoid Dart conflict
class NumberItem {
  String? value;
  String? label;

  NumberItem({this.value, this.label});

  NumberItem.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}

class Sponsor {
  int? id;
  String? name;
  String? logo;

  Sponsor({this.id, this.name, this.logo});

  Sponsor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
    };
  }
}
