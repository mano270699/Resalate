import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';

class FuneralsItem extends StatelessWidget {
  const FuneralsItem(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.time});
  final String title;
  final String subTitle;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 10.w),
      child: Container(
        // height: 150.h,
        // width: 100.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AppText(
                  text: title,
                  model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .heading1
                          .copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          )),
                ),
              ),
              10.h.verticalSpace,
              AppText(
                text: subTitle,
                model: AppTextModel(
                    textAlign: TextAlign.center,
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .subTitle1
                            .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray,
                            )),
              ),
              10.h.verticalSpace,
              AppText(
                text: time,
                model: AppTextModel(
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .smallTab
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.scondaryColor,
                            )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
