import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/src/from_mosque_to_mosque/data/models/masjed_to_masjed_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/shared_components/app_text/app_text.dart';
import '../../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';

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
      padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
      child: Container(
        height: 270.h,
        width: MediaQuery.of(context).size.width,
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
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        posts.image ?? "",
                        fit: BoxFit.cover,
                      ))),
              10.h.verticalSpace,
              AppText(
                text: posts.title ?? "",
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
              AppText(
                text: posts.excerpt ?? "",
                model: AppTextModel(
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .smallTab
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray,
                            )),
              ),
              10.h.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  GestureDetector(
                    onTap: () {
                      openWhatsApp("whatsAppNumber");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20)),
                      height: 40.h,
                      // width: 100.w,
                      child: Center(
                        child: AppText(
                          text: "WhatsApp",
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
