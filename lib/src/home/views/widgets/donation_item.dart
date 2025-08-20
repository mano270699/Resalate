import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';

class DonationItem extends StatelessWidget {
  const DonationItem({super.key, required this.image, required this.title});
  final String image;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 10.w),
      child: Container(
        height: 300.h,
        width: MediaQuery.of(context).size.width - 32.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: SizedBox(
                      height: 150.h,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ))),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 30.h,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.amber.withOpacity(0.2)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: LinearPercentIndicator(
                    // barRadius: const Radius.circular(10),
                    fillColor: AppColors.primaryColor.withOpacity(0.5),
                    lineHeight: 30.h,

                    padding: EdgeInsets.zero,
                    percent: 0.5, // 50% progress
                    center: AppText(
                      text: "50%",
                      model: AppTextModel(
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .label
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              )),
                    ),

                    progressColor: AppColors.primaryColor,
                  ),
                ),
              ),
              10.h.verticalSpace,
              AppText(
                text: title,
                model: AppTextModel(
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .headingMedium2
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            )),
              ),
              10.h.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: AppLocalizations.of(context)!
                            .translate('remaining'),
                        model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .subTitle1
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                )),
                      ),
                      AppText(
                        text: "22,5260 SAR",
                        model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .smallTab
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.scondaryColor,
                                )),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                        color: AppColors.scondaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    height: 40.h,
                    // width: 100.w,
                    child: Center(
                      child: AppText(
                        text: AppLocalizations.of(context)!
                            .translate('donate_now'),
                        model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .subTitle2
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                )),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
