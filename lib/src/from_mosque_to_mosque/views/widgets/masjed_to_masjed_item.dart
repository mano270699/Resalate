import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/src/from_mosque_to_mosque/data/models/masjed_to_masjed_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../from_mosque_to_mosque_details_screen.dart';

class ItemMasjedToMasjed extends StatelessWidget {
  const ItemMasjedToMasjed({
    super.key,
    required this.posts,
  });
  final Posts posts;

  void openWhatsApp(String phoneNumber) async {
    final url = "https://wa.me/$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
              context, FromMosqueToMosqueDetailsScreen.routeName,
              arguments: {"id": posts.id});
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with rounded top corners
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: SizedBox(
                  height: 160.h,
                  width: double.infinity,
                  child: Image.network(
                    posts.image ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.cardBg,
                      child: Center(
                        child: Icon(
                          Icons.mosque_rounded,
                          size: 48.sp,
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    AppText(
                      text: posts.title ?? "",
                      model: AppTextModel(
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .headingMedium2
                            .copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                      ),
                    ),
                    8.h.verticalSpace,

                    // Excerpt / description
                    if ((posts.excerpt ?? "").isNotEmpty)
                      AppText(
                        text: posts.excerpt ?? "",
                        model: AppTextModel(
                          maxLines: 2,
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .smallTab
                              .copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.gray,
                                height: 1.4,
                              ),
                        ),
                      ),
                    14.h.verticalSpace,

                    // WhatsApp button
                    GestureDetector(
                      onTap: () {
                        openWhatsApp("whatsAppNumber");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_rounded,
                              color: AppColors.white,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            AppText(
                              text: AppLocalizations.of(context)!
                                  .translate("whatsApp"),
                              model: AppTextModel(
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .subTitle2
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
