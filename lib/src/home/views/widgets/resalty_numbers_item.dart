import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/core/common/app_colors/app_colors.dart';

import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../data/models/home_data_model.dart';

class ResaltyNumbersWidgets extends StatelessWidget {
  const ResaltyNumbersWidgets({super.key, required this.numbers});
  final Numbers numbers;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.white,
          // boxShadow: const [
          //   BoxShadow(
          //     color: AppColors.gray,
          //     spreadRadius: 5,
          //     offset: Offset(3, 3),
          //   ),
          // ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              AppText(
                text: numbers.title,
                model: AppTextModel(
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .headingMedium2
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.scondaryColor,
                            )),
              ),
              30.h.verticalSpace,

              ...List.generate(
                numbers.list.length,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Container(
                    height: 80.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: numbers.list[index].label,
                          model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .label
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.scondaryColor,
                                ),
                          ),
                        ),
                        10.h.verticalSpace,
                        AppText(
                          text: numbers.list[index].value,
                          model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .headingMedium2
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.sp,
                                  color: AppColors.primaryColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              // Container(
              //   height: 80.h,
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //       color: AppColors.cardBg,
              //       borderRadius: BorderRadius.circular(10.r)),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       AppText(
              //         text: "Number Of Countries",
              //         model: AppTextModel(
              //             style: AppFontStyleGlobal(
              //                     AppLocalizations.of(context)!.locale)
              //                 .label
              //                 .copyWith(
              //                   fontWeight: FontWeight.w600,
              //                   color: AppColors.scondaryColor,
              //                 )),
              //       ),
              //       10.h.verticalSpace,
              //       AppText(
              //         text: "100",
              //         model: AppTextModel(
              //             style: AppFontStyleGlobal(
              //                     AppLocalizations.of(context)!.locale)
              //                 .headingMedium2
              //                 .copyWith(
              //                   fontWeight: FontWeight.w700,
              //                   fontSize: 20.sp,
              //                   color: AppColors.primaryColor,
              //                 )),
              //       ),
              //     ],
              //   ),
              // ),
              // 20.h.verticalSpace,
              // Container(
              //   height: 80.h,
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //       color: AppColors.cardBg,
              //       borderRadius: BorderRadius.circular(10.r)),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       AppText(
              //         text: "Number of cities",
              //         model: AppTextModel(
              //             style: AppFontStyleGlobal(
              //                     AppLocalizations.of(context)!.locale)
              //                 .label
              //                 .copyWith(
              //                   fontWeight: FontWeight.w600,
              //                   color: AppColors.scondaryColor,
              //                 )),
              //       ),
              //       10.h.verticalSpace,
              //       AppText(
              //         text: "500",
              //         model: AppTextModel(
              //             style: AppFontStyleGlobal(
              //                     AppLocalizations.of(context)!.locale)
              //                 .headingMedium2
              //                 .copyWith(
              //                   fontWeight: FontWeight.w700,
              //                   fontSize: 20.sp,
              //                   color: AppColors.primaryColor,
              //                 )),
              //       ),
              //     ],
              //   ),
              // ),
              // 20.h.verticalSpace,
              // Container(
              //   height: 80.h,
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //       color: AppColors.cardBg,
              //       borderRadius: BorderRadius.circular(10.r)),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       AppText(
              //         text: "Number Of mosques",
              //         model: AppTextModel(
              //             style: AppFontStyleGlobal(
              //                     AppLocalizations.of(context)!.locale)
              //                 .label
              //                 .copyWith(
              //                   fontWeight: FontWeight.w600,
              //                   color: AppColors.scondaryColor,
              //                 )),
              //       ),
              //       10.h.verticalSpace,
              //       AppText(
              //         text: "1200",
              //         model: AppTextModel(
              //             style: AppFontStyleGlobal(
              //                     AppLocalizations.of(context)!.locale)
              //                 .headingMedium2
              //                 .copyWith(
              //                   fontWeight: FontWeight.w700,
              //                   fontSize: 20.sp,
              //                   color: AppColors.primaryColor,
              //                 )),
              //       ),
              //     ],
              //   ),
              // ),
              // 5.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
