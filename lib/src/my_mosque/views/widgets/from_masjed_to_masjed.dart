import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/shared_components/app_cached_network_image.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../from_mosque_to_mosque/views/from_mosque_to_mosque_details_screen.dart';
import '../../data/models/masjed_details_model.dart';

class FromMasjedToMasjed extends StatelessWidget {
  const FromMasjedToMasjed(
      {super.key, required this.whatsAppLink, required this.postItem});
  final PostItem postItem;
  final String whatsAppLink;

  void openWhatsApp(String whatsAppLink) async {
    if (await canLaunchUrl(Uri.parse(whatsAppLink))) {
      await launchUrl(Uri.parse(whatsAppLink));
    } else {
      throw "Could not launch $whatsAppLink";
    }
  }

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
            context, FromMosqueToMosqueDetailsScreen.routeName,
            arguments: {"id": postItem.id});
      },
      child: Container(
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
                      height: 100.h,
                      width: double.infinity,
                      child: AppCachedNetworkImage(
                        image: postItem.image ?? "",
                        fit: BoxFit.cover,
                      ))),
              8.h.verticalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: postItem.title ?? "",
                      model: AppTextModel(
                          textDirection: textDir,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .bodyLight1
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              )),
                    ),
                    6.h.verticalSpace,
                    AppText(
                      text: postItem.excerpt ?? "",
                      model: AppTextModel(
                          textDirection: textDir,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .smallTab
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray,
                              )),
                    ),
                  ],
                ),
              ),
              8.h.verticalSpace,
              GestureDetector(
                onTap: () {
                  openWhatsApp(whatsAppLink);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8)),
                  height: 40.h,
                  width: double.infinity,
                  child: Center(
                    child: AppText(
                      text: "WhatsApp",
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
