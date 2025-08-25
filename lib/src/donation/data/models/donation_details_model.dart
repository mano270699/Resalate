class DonationsDetailsResponse {
  final String? status;
  final Post? post;

  DonationsDetailsResponse({this.status, this.post});

  factory DonationsDetailsResponse.fromJson(Map<String, dynamic> json) {
    return DonationsDetailsResponse(
      status: json['status'],
      post: json['post'] != null ? Post.fromJson(json['post']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'post': post?.toJson(),
      };
}

class Post {
  final int? id;
  final String? title;
  final String? content;
  final String? image;
  final String? date;
  final Donation? donation;
  final Masjid? masjid;

  Post({
    this.id,
    this.title,
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
  final PaymentInfo? paymentInfo;

  Masjid({this.id, this.name, this.email, this.photo, this.paymentInfo});

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return Masjid(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      paymentInfo: json['payment_info'] != null
          ? PaymentInfo.fromJson(json['payment_info'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photo': photo,
        'payment_info': paymentInfo?.toJson(),
      };
}

class PaymentInfo {
  final String? paypalUser;
  final SwitchPayment? switchPayment;
  final BankAccount? bankAccount;

  PaymentInfo({this.paypalUser, this.switchPayment, this.bankAccount});

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      paypalUser: json['paypal_user'],
      switchPayment: json['switch'] != null
          ? SwitchPayment.fromJson(json['switch'])
          : null,
      bankAccount: json['bank_account'] != null
          ? BankAccount.fromJson(json['bank_account'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'paypal_user': paypalUser,
        'switch': switchPayment?.toJson(),
        'bank_account': bankAccount?.toJson(),
      };
}

class SwitchPayment {
  final String? number;
  final String? url;
  final QrCode? qrCode;

  SwitchPayment({this.number, this.url, this.qrCode});

  factory SwitchPayment.fromJson(Map<String, dynamic> json) {
    return SwitchPayment(
      number: json['number'],
      url: json['url'],
      qrCode: json['qr_code'] != null ? QrCode.fromJson(json['qr_code']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'url': url,
        'qr_code': qrCode?.toJson(),
      };
}

class QrCode {
  final int? id;
  final String? title;
  final String? filename;
  final int? filesize;
  final String? url;
  final String? link;
  final String? alt;
  final String? author;
  final String? description;
  final String? caption;
  final String? name;
  final String? status;
  final int? uploadedTo;
  final String? date;
  final String? modified;
  final int? menuOrder;
  final String? mimeType;
  final String? type;
  final String? subtype;
  final String? icon;
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
    this.alt,
    this.author,
    this.description,
    this.caption,
    this.name,
    this.status,
    this.uploadedTo,
    this.date,
    this.modified,
    this.menuOrder,
    this.mimeType,
    this.type,
    this.subtype,
    this.icon,
    this.width,
    this.height,
    this.sizes,
  });

  factory QrCode.fromJson(Map<String, dynamic> json) {
    return QrCode(
      id: json['id'],
      title: json['title'],
      filename: json['filename'],
      filesize: json['filesize'],
      url: json['url'],
      link: json['link'],
      alt: json['alt'],
      author: json['author'],
      description: json['description'],
      caption: json['caption'],
      name: json['name'],
      status: json['status'],
      uploadedTo: json['uploaded_to'],
      date: json['date'],
      modified: json['modified'],
      menuOrder: json['menu_order'],
      mimeType: json['mime_type'],
      type: json['type'],
      subtype: json['subtype'],
      icon: json['icon'],
      width: json['width'],
      height: json['height'],
      sizes: json['sizes'] != null ? Sizes.fromJson(json['sizes']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'filename': filename,
        'filesize': filesize,
        'url': url,
        'link': link,
        'alt': alt,
        'author': author,
        'description': description,
        'caption': caption,
        'name': name,
        'status': status,
        'uploaded_to': uploadedTo,
        'date': date,
        'modified': modified,
        'menu_order': menuOrder,
        'mime_type': mimeType,
        'type': type,
        'subtype': subtype,
        'icon': icon,
        'width': width,
        'height': height,
        'sizes': sizes?.toJson(),
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
  final String? size1536x1536;
  final int? size1536x1536Width;
  final int? size1536x1536Height;
  final String? size2048x2048;
  final int? size2048x2048Width;
  final int? size2048x2048Height;

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
    this.size1536x1536,
    this.size1536x1536Width,
    this.size1536x1536Height,
    this.size2048x2048,
    this.size2048x2048Width,
    this.size2048x2048Height,
  });

  factory Sizes.fromJson(Map<String, dynamic> json) {
    return Sizes(
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
      size1536x1536: json['1536x1536'],
      size1536x1536Width: json['1536x1536-width'],
      size1536x1536Height: json['1536x1536-height'],
      size2048x2048: json['2048x2048'],
      size2048x2048Width: json['2048x2048-width'],
      size2048x2048Height: json['2048x2048-height'],
    );
  }

  Map<String, dynamic> toJson() => {
        'thumbnail': thumbnail,
        'thumbnail-width': thumbnailWidth,
        'thumbnail-height': thumbnailHeight,
        'medium': medium,
        'medium-width': mediumWidth,
        'medium-height': mediumHeight,
        'medium_large': mediumLarge,
        'medium_large-width': mediumLargeWidth,
        'medium_large-height': mediumLargeHeight,
        'large': large,
        'large-width': largeWidth,
        'large-height': largeHeight,
        '1536x1536': size1536x1536,
        '1536x1536-width': size1536x1536Width,
        '1536x1536-height': size1536x1536Height,
        '2048x2048': size2048x2048,
        '2048x2048-width': size2048x2048Width,
        '2048x2048-height': size2048x2048Height,
      };
}

class BankAccount {
  final String? name;
  final String? accountNumber;
  final String? iban;
  final String? swiftCode;

  BankAccount({this.name, this.accountNumber, this.iban, this.swiftCode});

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      name: json['name'],
      accountNumber: json['account_number'],
      iban: json['iban'],
      swiftCode: json['swift_code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'account_number': accountNumber,
        'iban': iban,
        'swift_code': swiftCode,
      };
}
