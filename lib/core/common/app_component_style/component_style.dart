import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors/app_colors.dart';
import '../app_font_style/app_font_style_global.dart';

class ComponentStyle {
  static InputDecoration inputDecoration(
    Locale locale, {
    BorderRadius? borderRadius,
  }) =>
      InputDecoration(
        hintStyle: AppFontStyleGlobal(locale).smallTab.copyWith(
              fontSize: 14.sp,
              color: AppColors.gray,
              height: 0,
            ),
        filled: false,
        labelStyle: AppFontStyleGlobal(locale)
            .smallTab
            .copyWith(fontSize: 12.sp, color: AppColors.gray, height: 0),
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorStyle: AppFontStyleGlobal(locale).caption.copyWith(
              color: AppColors.error,
            ),
      );
  static ButtonStyle get buttonStyle => ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          Size(323.w, 56.h),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            // side: const BorderSide(color: AppColors.outlinedBorder, width: 1),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
  static BoxDecoration get buttonDecoration => BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.r),
      );
}
