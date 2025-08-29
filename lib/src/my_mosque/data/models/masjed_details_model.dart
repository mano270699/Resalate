class MasjidDetailsResponse {
  final String? status;
  final Masjid? masjid;
  final Posts? posts;

  MasjidDetailsResponse({this.status, this.masjid, this.posts});

  factory MasjidDetailsResponse.fromJson(Map<String, dynamic> json) {
    return MasjidDetailsResponse(
      status: json['status'],
      masjid: json['masjid'] != null ? Masjid.fromJson(json['masjid']) : null,
      posts: json['posts'] != null ? Posts.fromJson(json['posts']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "masjid": masjid?.toJson(),
        "posts": posts?.toJson(),
      };
}

// ---------------- MASJID ----------------
class Masjid {
  final int? id;
  final String? name;
  final String? image;
  final String? cover;
  final String? description;
  final String? email;
  final String? phone;
  final List<Language>? languages;
  final String? country;
  final String? province;
  final String? city;
  final SocialMedia? socialMedia;
  final List<Service>? services;
  final PaymentInfo? paymentInfo;
  final List<MemorizationDate>? memorizationDates;
  final String? location;
  final bool? isFollowing;

  Masjid({
    this.id,
    this.name,
    this.image,
    this.cover,
    this.description,
    this.email,
    this.phone,
    this.languages,
    this.country,
    this.province,
    this.city,
    this.socialMedia,
    this.services,
    this.paymentInfo,
    this.memorizationDates,
    this.location,
    this.isFollowing,
  });

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return Masjid(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      cover: json['cover'],
      description: json['description'],
      email: json['email'],
      phone: json['phone'],
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => Language.fromJson(e))
          .toList(),
      country: json['country'],
      province: json['province'],
      city: json['city'],
      socialMedia: json['social_media'] != null
          ? SocialMedia.fromJson(json['social_media'])
          : null,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e))
          .toList(),
      paymentInfo: json['payment_info'] != null
          ? PaymentInfo.fromJson(json['payment_info'])
          : null,
      memorizationDates: (json['memorization_dates'] as List<dynamic>?)
          ?.map((e) => MemorizationDate.fromJson(e))
          .toList(),
      location: json['location'],
      isFollowing: json['is_following'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "cover": cover,
        "description": description,
        "email": email,
        "phone": phone,
        "languages": languages?.map((e) => e.toJson()).toList(),
        "country": country,
        "province": province,
        "city": city,
        "social_media": socialMedia?.toJson(),
        "services": services?.map((e) => e.toJson()).toList(),
        "payment_info": paymentInfo?.toJson(),
        "memorization_dates":
            memorizationDates?.map((e) => e.toJson()).toList(),
        "location": location,
        "is_following": isFollowing,
      };
}

class Language {
  final String? title;

  Language({this.title});

  factory Language.fromJson(Map<String, dynamic> json) =>
      Language(title: json['title']);

  Map<String, dynamic> toJson() => {"title": title};
}

class Service {
  final String? value;
  final String? label;

  Service({this.value, this.label});

  factory Service.fromJson(Map<String, dynamic> json) =>
      Service(value: json['value'], label: json['label']);

  Map<String, dynamic> toJson() => {"value": value, "label": label};
}

class SocialMedia {
  final String? facebookUrl;
  final String? xUrl;
  final String? instagramUrl;
  final String? youtubeUrl;
  final String? tiktokUrl;
  final String? linkedinUrl;
  final String? telegramUrl;
  final String? whatsappUrl;
  final String? snapchatUrl;

  SocialMedia({
    this.facebookUrl,
    this.xUrl,
    this.instagramUrl,
    this.youtubeUrl,
    this.tiktokUrl,
    this.linkedinUrl,
    this.telegramUrl,
    this.whatsappUrl,
    this.snapchatUrl,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) => SocialMedia(
        facebookUrl: json['facebook_url'],
        xUrl: json['x_url'],
        instagramUrl: json['instagram_url'],
        youtubeUrl: json['youtube_url'],
        tiktokUrl: json['tiktok_url'],
        linkedinUrl: json['linkedin_url'],
        telegramUrl: json['telegram_url'],
        whatsappUrl: json['whatsapp_url'],
        snapchatUrl: json['snapchat_url'],
      );

  Map<String, dynamic> toJson() => {
        "facebook_url": facebookUrl,
        "x_url": xUrl,
        "instagram_url": instagramUrl,
        "youtube_url": youtubeUrl,
        "tiktok_url": tiktokUrl,
        "linkedin_url": linkedinUrl,
        "telegram_url": telegramUrl,
        "whatsapp_url": whatsappUrl,
        "snapchat_url": snapchatUrl,
      };
}

class MemorizationDate {
  final String? date;
  final String? description;

  MemorizationDate({this.date, this.description});

  factory MemorizationDate.fromJson(Map<String, dynamic> json) =>
      MemorizationDate(date: json['date'], description: json['description']);

  Map<String, dynamic> toJson() => {"date": date, "description": description};
}

// ---------------- PAYMENT INFO ----------------
class PaymentInfo {
  final String? paypalUser;
  final SwitchData? switchData;
  final BankAccount? bankAccount;

  PaymentInfo({this.paypalUser, this.switchData, this.bankAccount});

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        paypalUser: json['paypal_user'],
        switchData:
            json['switch'] != null ? SwitchData.fromJson(json['switch']) : null,
        bankAccount: json['bank_account'] != null
            ? BankAccount.fromJson(json['bank_account'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "paypal_user": paypalUser,
        "switch": switchData?.toJson(),
        "bank_account": bankAccount?.toJson(),
      };
}

class SwitchData {
  final String? number;
  final String? url;
  final QrCode? qrCode;

  SwitchData({this.number, this.url, this.qrCode});

  factory SwitchData.fromJson(Map<String, dynamic> json) => SwitchData(
        number: json['number'],
        url: json['url'],
        qrCode:
            json['qr_code'] != null ? QrCode.fromJson(json['qr_code']) : null,
      );

  Map<String, dynamic> toJson() =>
      {"number": number, "url": url, "qr_code": qrCode?.toJson()};
}

class QrCode {
  final int? id;
  final String? title;
  final String? filename;
  final int? filesize;
  final String? url;
  final String? link;
  final String? mimeType;
  final int? width;
  final int? height;
  final Sizes? sizes;

  QrCode({
    this.id,
    this.title,
    this.filename,
    this.filesize,
    this.url,
    this.link,
    this.mimeType,
    this.width,
    this.height,
    this.sizes,
  });

  factory QrCode.fromJson(Map<String, dynamic> json) => QrCode(
        id: json['id'],
        title: json['title'],
        filename: json['filename'],
        filesize: json['filesize'],
        url: json['url'],
        link: json['link'],
        mimeType: json['mime_type'],
        width: json['width'],
        height: json['height'],
        sizes: json['sizes'] != null ? Sizes.fromJson(json['sizes']) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "filename": filename,
        "filesize": filesize,
        "url": url,
        "link": link,
        "mime_type": mimeType,
        "width": width,
        "height": height,
        "sizes": sizes?.toJson(),
      };
}

class Sizes {
  final String? thumbnail;
  final int? thumbnailWidth;
  final int? thumbnailHeight;
  final String? medium;
  final int? mediumWidth;
  final int? mediumHeight;
  final String? mediumLarge;
  final int? mediumLargeWidth;
  final int? mediumLargeHeight;
  final String? large;
  final int? largeWidth;
  final int? largeHeight;

  Sizes({
    this.thumbnail,
    this.thumbnailWidth,
    this.thumbnailHeight,
    this.medium,
    this.mediumWidth,
    this.mediumHeight,
    this.mediumLarge,
    this.mediumLargeWidth,
    this.mediumLargeHeight,
    this.large,
    this.largeWidth,
    this.largeHeight,
  });

  factory Sizes.fromJson(Map<String, dynamic> json) => Sizes(
        thumbnail: json['thumbnail'],
        thumbnailWidth: json['thumbnail-width'],
        thumbnailHeight: json['thumbnail-height'],
        medium: json['medium'],
        mediumWidth: json['medium-width'],
        mediumHeight: json['medium-height'],
        mediumLarge: json['medium_large'],
        mediumLargeWidth: json['medium_large-width'],
        mediumLargeHeight: json['medium_large-height'],
        large: json['large'],
        largeWidth: json['large-width'],
        largeHeight: json['large-height'],
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail,
        "thumbnail-width": thumbnailWidth,
        "thumbnail-height": thumbnailHeight,
        "medium": medium,
        "medium-width": mediumWidth,
        "medium-height": mediumHeight,
        "medium_large": mediumLarge,
        "medium_large-width": mediumLargeWidth,
        "medium_large-height": mediumLargeHeight,
        "large": large,
        "large-width": largeWidth,
        "large-height": largeHeight,
      };
}

class BankAccount {
  final String? name;
  final String? accountNumber;
  final String? iban;
  final String? swiftCode;

  BankAccount({this.name, this.accountNumber, this.iban, this.swiftCode});

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        name: json['name'],
        accountNumber: json['account_number'],
        iban: json['iban'],
        swiftCode: json['swift_code'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "account_number": accountNumber,
        "iban": iban,
        "swift_code": swiftCode,
      };
}

// ---------------- POSTS ----------------
class Posts {
  final List<Donation>? donations;
  final List<PostItem>? masjidToMasjid;
  final List<PostItem>? funerals;
  final List<Lesson>? lessons;
  final List<PostItem>? liveFeed;

  Posts({
    this.donations,
    this.masjidToMasjid,
    this.funerals,
    this.lessons,
    this.liveFeed,
  });

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        donations: (json['donations'] as List<dynamic>?)
            ?.map((e) => Donation.fromJson(e))
            .toList(),
        masjidToMasjid: (json['masjid-to-masjid'] as List<dynamic>?)
            ?.map((e) => PostItem.fromJson(e))
            .toList(),
        funerals: (json['funerals'] as List<dynamic>?)
            ?.map((e) => PostItem.fromJson(e))
            .toList(),
        lessons: (json['lessons'] as List<dynamic>?)
            ?.map((e) => Lesson.fromJson(e))
            .toList(),
        liveFeed: (json['live-feed'] as List<dynamic>?)
            ?.map((e) => PostItem.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "donations": donations?.map((e) => e.toJson()).toList(),
        "masjid-to-masjid": masjidToMasjid?.map((e) => e.toJson()).toList(),
        "funerals": funerals?.map((e) => e.toJson()).toList(),
        "lessons": lessons?.map((e) => e.toJson()).toList(),
        "live-feed": liveFeed?.map((e) => e.toJson()).toList(),
      };
}

class PostItem {
  final int? id;
  final String? title;
  final String? excerpt;
  final String? image;
  final String? date;
  final String? link;

  PostItem(
      {this.id, this.title, this.excerpt, this.image, this.date, this.link});

  factory PostItem.fromJson(Map<String, dynamic> json) => PostItem(
        id: json['id'],
        title: json['title'],
        excerpt: json['excerpt'],
        image: json['image'],
        date: json['date'],
        link: json['link'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "excerpt": excerpt,
        "image": image,
        "date": date,
        "link": link,
      };
}

class Donation extends PostItem {
  final String? totalAmount;
  final String? amountPaid;
  final String? currency;

  Donation({
    int? id,
    String? title,
    String? excerpt,
    String? image,
    String? date,
    String? link,
    this.totalAmount,
    this.amountPaid,
    this.currency,
  }) : super(
          id: id,
          title: title,
          excerpt: excerpt,
          image: image,
          date: date,
          link: link,
        );

  factory Donation.fromJson(Map<String, dynamic> json) => Donation(
        id: json['id'],
        title: json['title'],
        excerpt: json['excerpt'],
        image: json['image'],
        date: json['date'],
        link: json['link'],
        totalAmount: json['total_amount'],
        amountPaid: json['amount_paid'],
        currency: json['currency'],
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        "total_amount": totalAmount,
        "amount_paid": amountPaid,
        "currency": currency,
      };
}

class Lesson extends PostItem {
  final List<Category>? categories;

  Lesson({
    int? id,
    String? title,
    String? excerpt,
    String? image,
    String? date,
    String? link,
    this.categories,
  }) : super(
          id: id,
          title: title,
          excerpt: excerpt,
          image: image,
          date: date,
          link: link,
        );

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        title: json['title'],
        excerpt: json['excerpt'],
        image: json['image'],
        date: json['date'],
        link: json['link'],
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e))
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        "categories": categories?.map((e) => e.toJson()).toList(),
      };
}

class Category {
  final int? id;
  final String? name;
  final String? slug;

  Category({this.id, this.name, this.slug});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json['id'], name: json['name'], slug: json['slug']);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "slug": slug};
}
