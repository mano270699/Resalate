import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedHeight = constraints.maxHeight.isFinite;
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final imageHeight =
              (availableWidth * 0.58).clamp(132.0, 220.0).toDouble();
          final progressHeight = availableWidth >= 360 ? 34.0 : 30.0;
          final isCompactCard =
              hasBoundedHeight && constraints.maxHeight <= imageHeight + 290;
          final titleFontSize = availableWidth >= 360 ? 18.0 : 16.0;
          final descriptionFontSize = availableWidth >= 360 ? 13.5 : 12.5;
          final buttonFontSize = availableWidth >= 360 ? 16.0 : 14.0;
          final textDirection =
              AppLocalizations.of(context)!.locale.languageCode == 'en' ||
                      AppLocalizations.of(context)!.locale.languageCode == 'sv'
                  ? TextDirection.ltr
                  : TextDirection.rtl;

          Widget buildCardBody({required bool boundedHeight}) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    model: AppTextModel(
                      textDirection: textDirection,
                      maxLines: isCompactCard ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .headingMedium2
                          .copyWith(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    text: desc,
                    model: AppTextModel(
                      textDirection: textDirection,
                      maxLines: isCompactCard ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .headingMedium2
                          .copyWith(
                            fontSize: descriptionFontSize,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _StatCard(
                          compact: isCompactCard,
                          icon: Icons.account_balance_wallet_rounded,
                          iconColor: AppColors.primaryColor,
                          label:
                              AppLocalizations.of(context)!.translate('total'),
                          value: "$totalAmount $currency",
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _StatCard(
                          compact: isCompactCard,
                          icon: Icons.hourglass_bottom_rounded,
                          iconColor: const Color(0xFFF57C00),
                          label: AppLocalizations.of(context)!
                              .translate('remaining'),
                          value: "$remainingAmount $currency",
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _StatCard(
                          compact: isCompactCard,
                          icon: Icons.paid,
                          iconColor: const Color(0xFF4CAF50),
                          label:
                              AppLocalizations.of(context)!.translate('paid'),
                          value: "$paidAmount $currency",
                        ),
                      ),
                    ],
                  ),
                  if (boundedHeight)
                    const Spacer()
                  else
                    const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.scondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: isCompactCard ? 44 : 48,
                    width: double.infinity,
                    child: Center(
                      child: AppText(
                        text: AppLocalizations.of(context)!
                            .translate('donate_now'),
                        model: AppTextModel(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .subTitle2
                              .copyWith(
                                fontSize: buttonFontSize,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: hasBoundedHeight ? constraints.maxHeight : null,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: imageHeight,
                        width: double.infinity,
                        child: image.isNotEmpty
                            ? AppCachedNetworkImage(
                                image: image,
                                fit: BoxFit.cover,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16),
                                child: SvgPicture.asset(AppIconSvg.splashLogo),
                              ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: progressHeight,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        color: Colors.amber.withValues(alpha: 0.2),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: LinearPercentIndicator(
                          fillColor:
                              AppColors.primaryColor.withValues(alpha: 0.5),
                          lineHeight: progressHeight,
                          padding: EdgeInsets.zero,
                          percent: (donationPercent / 100).clamp(0.0, 1.0),
                          center: AppText(
                            text:
                                "${donationPercent.toStringAsFixed(donationPercent % 1 == 0 ? 0 : 1)}%",
                            model: AppTextModel(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .label
                                  .copyWith(
                                    fontSize:
                                        availableWidth >= 360 ? 16.0 : 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                            ),
                          ),
                          progressColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    if (hasBoundedHeight)
                      Expanded(child: buildCardBody(boundedHeight: true))
                    else
                      buildCardBody(boundedHeight: false),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool compact;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 34 : 38,
            height: compact ? 34 : 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: compact ? 18 : 20),
          ),
          SizedBox(height: compact ? 6 : 8),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 12 : 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: compact ? 12 : 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: compact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
