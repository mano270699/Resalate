import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/common/app_icon_svg.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/shared_components/app_cached_network_image.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../donation/view/donation_details_screen.dart';
import '../../data/models/masjed_details_model.dart';

class DonationItem extends StatelessWidget {
  const DonationItem({super.key, required this.donation});
  final Donation donation;
  @override
  Widget build(BuildContext context) {
    final textDir =
        AppLocalizations.of(context)!.locale.languageCode == 'en' ||
                AppLocalizations.of(context)!.locale.languageCode == 'sv'
            ? TextDirection.ltr
            : TextDirection.rtl;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DonationDetailsScreen.routeName,
          arguments: {
            "id": donation.id,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: AppColors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: SizedBox(
                      height: 70.h,
                      width: double.infinity,
                      child: donation.image != null
                          ? AppCachedNetworkImage(
                              image: donation.image ?? "",
                              fit: BoxFit.cover,
                            )
                          : SvgPicture.asset(AppIconSvg.splashLogo))),
              Container(
                width: double.infinity,
                height: 15.h,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.amber.withValues(alpha: 0.2)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: LinearPercentIndicator(
                    fillColor: AppColors.primaryColor.withValues(alpha: 0.5),
                    lineHeight: 30.h,
                    padding: EdgeInsets.zero,
                    percent: 0.5,
                    center: AppText(
                      text:
                          "${(double.parse(donation.amountPaid.toString()) / double.parse(donation.totalAmount.toString())) * 100} %",
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
              5.h.verticalSpace,
              AppText(
                text: donation.title ?? "",
                model: AppTextModel(
                    textDirection: textDir,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyleGlobal(
                            AppLocalizations.of(context)!.locale)
                        .subTitle1
                        .copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        )),
              ),
              5.h.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText(
                          text: AppLocalizations.of(context)!.translate('total'),
                          model: AppTextModel(
                              textDirection: textDir,
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .subTitle1
                                  .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColor,
                                  )),
                        ),
                        AppText(
                          text:
                              " ${donation.totalAmount.toString()} ${donation.currency}",
                          model: AppTextModel(
                              textDirection: textDir,
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .smallTab
                                  .copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.scondaryColor,
                                  )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText(
                          text: AppLocalizations.of(context)!.translate('paid'),
                          model: AppTextModel(
                              textDirection: textDir,
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .subTitle1
                                  .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  )),
                        ),
                        AppText(
                          text:
                              " ${donation.amountPaid.toString()} ${donation.currency}",
                          model: AppTextModel(
                              textDirection: textDir,
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .smallTab
                                  .copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.scondaryColor,
                                  )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              10.h.verticalSpace,
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, DonationDetailsScreen.routeName,
                      arguments: {"id": donation.id});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: AppColors.scondaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  height: 40.h,
                  width: double.infinity,
                  child: Center(
                    child: AppText(
                      text: AppLocalizations.of(context)!
                          .translate('donate_now'),
                      model: AppTextModel(
                          textDirection: textDir,
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .subTitle2
                              .copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
