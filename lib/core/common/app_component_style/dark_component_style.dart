import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared_components/app_bottom_sheet/models/app_bottom_sheet_model.dart';
import '../app_colors/app_colors.dart';
import '../app_font_style/app_font_style_global.dart';

class DarkComponentStyle {
  static InputDecoration inputDecoration(Locale locale) => InputDecoration(
        hintStyle: AppFontStyleGlobal(locale).bodyMedium1.copyWith(
              color: AppColors.primaryColor,
            ),
        filled: true,
        fillColor: AppColors.primaryColorDark,
        contentPadding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 16.w),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(color: AppColors.black)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(color: AppColors.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(color: AppColors.error)),
        errorStyle: AppFontStyleGlobal(locale).caption.copyWith(
              color: AppColors.error,
            ),
      );

  static AppBottomSheetModel get appBottomSheetModel => AppBottomSheetModel(
        uperContanerDecoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x3AFFFFFF),
              Color(0x00FFFFFF),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 1,
          ),
        ),
        belowContanerDecoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        imageFilter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: const SizedBox(),
        deviderDecoration: BoxDecoration(
          color: AppColors.primaryColorLight,
          borderRadius: BorderRadius.circular(10),
        ),
      );
}
