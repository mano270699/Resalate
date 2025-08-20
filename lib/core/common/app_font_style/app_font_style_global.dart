import '../../base/app_font_style.dart';
import 'app_font_style_ar.dart';
import 'app_font_style_en.dart';

import 'package:flutter/material.dart';

class AppFontStyleGlobal extends AppFontStyle {
  final Locale locale;

  AppFontStyleGlobal(this.locale);

  @override
  TextStyle get bodyLight1 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().bodyLight1;
    } else {
      return AppFontStyleEn().bodyLight1;
    }
  }

  @override
  TextStyle get bodyLight2 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().bodyLight2;
    } else {
      return AppFontStyleEn().bodyLight2;
    }
  }

  @override
  TextStyle get bodyMedium1 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().bodyMedium1;
    } else {
      return AppFontStyleEn().bodyMedium1;
    }
  }

  @override
  TextStyle get bodyMedium2 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().bodyMedium2;
    } else {
      return AppFontStyleEn().bodyMedium2;
    }
  }

  @override
  TextStyle get bodyMediumUnderLine2 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().bodyMediumUnderLine2;
    } else {
      return AppFontStyleEn().bodyMediumUnderLine2;
    }
  }

  @override
  TextStyle get bodyRegular1 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().bodyRegular1;
    } else {
      return AppFontStyleEn().bodyRegular1;
    }
  }

  @override
  TextStyle get button {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().button;
    } else {
      return AppFontStyleEn().button;
    }
  }

  @override
  TextStyle get caption {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().caption;
    } else {
      return AppFontStyleEn().caption;
    }
  }

  @override
  String get fontFamily {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().fontFamily;
    } else {
      return AppFontStyleEn().fontFamily;
    }
  }

  @override
  TextStyle get heading1 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().heading1;
    } else {
      return AppFontStyleEn().heading1;
    }
  }

  @override
  TextStyle get heading3 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().heading3;
    } else {
      return AppFontStyleEn().heading3;
    }
  }

  @override
  TextStyle get heading4 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().heading4;
    } else {
      return AppFontStyleEn().heading4;
    }
  }

  @override
  TextStyle get headingLight5 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().headingLight5;
    } else {
      return AppFontStyleEn().headingLight5;
    }
  }

  @override
  TextStyle get headingMedium2 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().headingMedium2;
    } else {
      return AppFontStyleEn().headingMedium2;
    }
  }

  @override
  TextStyle get headingMedium5 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().headingMedium5;
    } else {
      return AppFontStyleEn().headingMedium5;
    }
  }

  @override
  TextStyle get headingSimiBold2 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().headingSimiBold2;
    } else {
      return AppFontStyleEn().headingSimiBold2;
    }
  }

  @override
  TextStyle get label {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().label;
    } else {
      return AppFontStyleEn().label;
    }
  }

  @override
  TextStyle get overLine {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().overLine;
    } else {
      return AppFontStyleEn().overLine;
    }
  }

  @override
  TextStyle get subTitle1 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().subTitle1;
    } else {
      return AppFontStyleEn().subTitle1;
    }
  }

  @override
  TextStyle get subTitle2 {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().subTitle2;
    } else {
      return AppFontStyleEn().subTitle2;
    }
  }

  @override
  TextStyle get smallTab {
    if (locale.languageCode == 'ar') {
      return AppFontStyleAr().smallTab;
    } else {
      return AppFontStyleEn().smallTab;
    }
  }
}
