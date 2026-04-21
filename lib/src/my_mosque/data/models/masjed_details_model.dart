String? _stringOrNull(dynamic value) =>
    value is String || value is num ? '$value' : null;

double? _doubleOrNull(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse('${value ?? ''}');

bool? _boolOrNull(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return null;
}

List<T>? _parseList<T>(
  dynamic value,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (value is! List) return null;
  return value
      .whereType<Map<String, dynamic>>()
      .map((item) => fromJson(item))
      .toList();
}

Map<String, dynamic>? _mapOrNull(dynamic value) =>
    value is Map<String, dynamic> ? value : null;

class MasjidDetailsResponse {
  final String? status;
  final Masjid? masjid;
  final Posts? posts;

  MasjidDetailsResponse({this.status, this.masjid, this.posts});

  factory MasjidDetailsResponse.fromJson(Map<String, dynamic> json) {
    return MasjidDetailsResponse(
      status: json['status'],
      masjid: _mapOrNull(json['masjid']) != null
          ? Masjid.fromJson(_mapOrNull(json['masjid'])!)
          : null,
      posts: _mapOrNull(json['posts']) != null
          ? Posts.fromJson(_mapOrNull(json['posts'])!)
          : null,
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

  final double? lat;
  final double? lng;

  Masjid({
    this.lat,
    this.lng,
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
      name: _stringOrNull(json['name']),
      image: _stringOrNull(json['image']),
      cover: _stringOrNull(json['cover']),
      description: _stringOrNull(json['description']),
      email: _stringOrNull(json['email']),
      phone: _stringOrNull(json['phone']),
      languages: _parseList(json['languages'], Language.fromJson),
      country: _stringOrNull(json['country']),
      province: _stringOrNull(json['province']),
      city: _stringOrNull(json['city']),
      socialMedia: _mapOrNull(json['social_media']) != null
          ? SocialMedia.fromJson(_mapOrNull(json['social_media'])!)
          : null,
      services: _parseList(json['services'], Service.fromJson),
      paymentInfo: _mapOrNull(json['payment_info']) != null
          ? PaymentInfo.fromJson(_mapOrNull(json['payment_info'])!)
          : null,
      memorizationDates:
          _parseList(json['memorization_dates'], MemorizationDate.fromJson),
      location: _stringOrNull(json['location']),
      isFollowing: _boolOrNull(json['is_following']),
      lat: _doubleOrNull(json["lat"]),
      lng: _doubleOrNull(json["lng"]),
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
        "lat": lat,
        "lng": lng
      };
}

class Language {
  final String? title;

  Language({this.title});

  factory Language.fromJson(Map<String, dynamic> json) =>
      Language(title: _stringOrNull(json['title']));

  Map<String, dynamic> toJson() => {"title": title};
}

class Service {
  final String? value;
  final String? label;

  Service({this.value, this.label});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        value: _stringOrNull(json['value']),
        label: _stringOrNull(json['label']),
      );

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
        facebookUrl: _stringOrNull(json['facebook_url']),
        xUrl: _stringOrNull(json['x_url']),
        instagramUrl: _stringOrNull(json['instagram_url']),
        youtubeUrl: _stringOrNull(json['youtube_url']),
        tiktokUrl: _stringOrNull(json['tiktok_url']),
        linkedinUrl: _stringOrNull(json['linkedin_url']),
        telegramUrl: _stringOrNull(json['telegram_url']),
        whatsappUrl: _stringOrNull(json['whatsapp_url']),
        snapchatUrl: _stringOrNull(json['snapchat_url']),
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
      MemorizationDate(
        date: _stringOrNull(json['date']),
        description: _stringOrNull(json['description']),
      );

  Map<String, dynamic> toJson() => {"date": date, "description": description};
}

// ---------------- PAYMENT INFO ----------------
class PaymentInfo {
  final String? paypalUser;
  final SwitchData? switchData;
  final BankAccount? bankAccount;

  PaymentInfo({this.paypalUser, this.switchData, this.bankAccount});

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        paypalUser: _stringOrNull(json['paypal_user']),
        switchData: _mapOrNull(json['switch']) != null
            ? SwitchData.fromJson(_mapOrNull(json['switch'])!)
            : null,
        bankAccount: _mapOrNull(json['bank_account']) != null
            ? BankAccount.fromJson(_mapOrNull(json['bank_account'])!)
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
        number: _stringOrNull(json['number']),
        url: _stringOrNull(json['url']),
        qrCode: _mapOrNull(json['qr_code']) != null
            ? QrCode.fromJson(_mapOrNull(json['qr_code'])!)
            : null,
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
        title: _stringOrNull(json['title']),
        filename: _stringOrNull(json['filename']),
        filesize: json['filesize'],
        url: _stringOrNull(json['url']),
        link: _stringOrNull(json['link']),
        mimeType: _stringOrNull(json['mime_type']),
        width: json['width'],
        height: json['height'],
        sizes: _mapOrNull(json['sizes']) != null
            ? Sizes.fromJson(_mapOrNull(json['sizes'])!)
            : null,
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
        thumbnail: _stringOrNull(json['thumbnail']),
        thumbnailWidth: json['thumbnail-width'],
        thumbnailHeight: json['thumbnail-height'],
        medium: _stringOrNull(json['medium']),
        mediumWidth: json['medium-width'],
        mediumHeight: json['medium-height'],
        mediumLarge: _stringOrNull(json['medium_large']),
        mediumLargeWidth: json['medium_large-width'],
        mediumLargeHeight: json['medium_large-height'],
        large: _stringOrNull(json['large']),
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
        name: _stringOrNull(json['name']),
        accountNumber: _stringOrNull(json['account_number']),
        iban: _stringOrNull(json['iban']),
        swiftCode: _stringOrNull(json['swift_code']),
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
        donations: _parseList(json['donations'], Donation.fromJson),
        masjidToMasjid: _parseList(json['masjid-to-masjid'], PostItem.fromJson),
        funerals: _parseList(json['funerals'], PostItem.fromJson),
        lessons: _parseList(json['lessons'], Lesson.fromJson),
        liveFeed: _parseList(json['live-feed'], PostItem.fromJson),
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
        title: _stringOrNull(json['title']),
        excerpt: _stringOrNull(json['excerpt']),
        image: _stringOrNull(json['image']),
        date: _stringOrNull(json['date']),
        link: _stringOrNull(json['link']),
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
    super.id,
    super.title,
    super.excerpt,
    super.image,
    super.date,
    super.link,
    this.totalAmount,
    this.amountPaid,
    this.currency,
  });

  factory Donation.fromJson(Map<String, dynamic> json) => Donation(
        id: json['id'],
        title: _stringOrNull(json['title']),
        excerpt: _stringOrNull(json['excerpt']),
        image: _stringOrNull(json['image']),
        date: _stringOrNull(json['date']),
        link: _stringOrNull(json['link']),
        totalAmount: _stringOrNull(json['total_amount']),
        amountPaid: _stringOrNull(json['amount_paid']),
        currency: _stringOrNull(json['currency']),
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
    super.id,
    super.title,
    super.excerpt,
    super.image,
    super.date,
    super.link,
    this.categories,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        title: _stringOrNull(json['title']),
        excerpt: _stringOrNull(json['excerpt']),
        image: _stringOrNull(json['image']),
        date: _stringOrNull(json['date']),
        link: _stringOrNull(json['link']),
        categories: _parseList(json['categories'], Category.fromJson),
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

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: _stringOrNull(json['name']),
        slug: _stringOrNull(json['slug']),
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "slug": slug};
}
