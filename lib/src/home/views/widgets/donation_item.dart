import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:resalate/core/common/app_icon_svg.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_cached_network_image.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';

class DonationItem extends StatelessWidget {
  const DonationItem(
      {super.key,
      required this.image,
      required this.title,
      required this.onTap,
      required this.desc,
      required this.percentage,
      required this.total,
      required this.paid,
      required this.currency});

  final String image;
  final String title;
  final String desc;
  final String percentage;
  final String total;
  final String paid;
  final String currency;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final donationPercent = (double.tryParse(percentage) ?? 0).clamp(0, 100);
    final totalAmount = double.tryParse(total) ?? 0;
    final paidAmount = double.tryParse(paid) ?? 0;
    final remainingAmount =
        (totalAmount - paidAmount).clamp(0, double.infinity);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: SizedBox(
                      height: 125.h,
                      width: double.infinity,
                      child: image.isNotEmpty
                          ? AppCachedNetworkImage(
                              image: image,
                              fit: BoxFit.cover,
                            )
                          : SvgPicture.asset(AppIconSvg.splashLogo),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.amber.withValues(alpha: 0.2),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: LinearPercentIndicator(
                        fillColor:
                            AppColors.primaryColor.withValues(alpha: 0.5),
                        lineHeight: 30.h,
                        padding: EdgeInsets.zero,
                        percent: (donationPercent / 100).clamp(0.0, 1.0),
                        center: AppText(
                          text:
                              "${donationPercent.toStringAsFixed(donationPercent % 1 == 0 ? 0 : 1)}%",
                          model: AppTextModel(
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .label
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                ),
                          ),
                        ),
                        progressColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  10.h.verticalSpace,
                  AppText(
                    text: title,
                    model: AppTextModel(
                      textDirection:
                          AppLocalizations.of(context)!.locale.languageCode ==
                                      'en' ||
                                  AppLocalizations.of(context)!
                                          .locale
                                          .languageCode ==
                                      'sv'
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .headingMedium2
                          .copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                    ),
                  ),
                  AppText(
                    text: desc,
                    model: AppTextModel(
                      textDirection:
                          AppLocalizations.of(context)!.locale.languageCode ==
                                      'en' ||
                                  AppLocalizations.of(context)!
                                          .locale
                                          .languageCode ==
                                      'sv'
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .headingMedium2
                          .copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray,
                          ),
                    ),
                  ),
                  10.h.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.account_balance_wallet_rounded,
                          iconColor: AppColors.primaryColor,
                          label:
                              AppLocalizations.of(context)!.translate('total'),
                          value: "$totalAmount $currency",
                        ),
                      ),
                      5.w.horizontalSpace,
                      Expanded(
                        child: _StatCard(
                          icon: Icons.hourglass_bottom_rounded,
                          iconColor: const Color(0xFFF57C00),
                          label: AppLocalizations.of(context)!
                              .translate('remaining'),
                          value: "$remainingAmount $currency",
                        ),
                      ),
                      5.w.horizontalSpace,
                      Expanded(
                        child: _StatCard(
                          icon: Icons.paid,
                          iconColor: const Color(0xFF4CAF50),
                          label:
                              AppLocalizations.of(context)!.translate('paid'),
                          value: "$paidAmount $currency",
                        ),
                      ),
                    ],
                  ),
                  16.h.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.scondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 40.h,
                    width: double.infinity,
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
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: iconColor.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
