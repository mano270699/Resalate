import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/app_font_style.dart';

class AppFontStyleAr extends AppFontStyle {
  @override
  String get fontFamily => 'Noto Sans Arabic';
  double get height => 1.2;
  @override
  TextStyle get heading1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get headingSimiBold2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get headingMedium2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get heading3 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get heading4 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get headingLight5 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w100,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get headingMedium5 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get subTitle1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get subTitle2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get bodyLight1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w200,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get bodyRegular1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get bodyMedium1 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get bodyLight2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w200,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get bodyMedium2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get bodyMediumUnderLine2 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        decoration: TextDecoration.underline,
        height: height,
      );
  @override
  TextStyle get button => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get label => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get caption => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: height,
      );
  @override
  TextStyle get overLine => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: height,
      );

  @override
  TextStyle get smallTab => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: height,
      );
}
