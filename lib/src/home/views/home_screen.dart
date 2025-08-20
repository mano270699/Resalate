import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/app_icon_svg.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../from_mosque_to_mosque/views/from_mosque_to_mosque_screen.dart';
import '../../nearest_mosque/views/nearest_mosque.dart';
import 'widgets/banner.dart';
import 'widgets/donation_item.dart';
import 'widgets/live_feed_item.dart';
import 'widgets/partenar_section.dart';
import 'widgets/resalty_numbers_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = 'Home Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.h,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: 200.w,
          child: SvgPicture.asset(
            AppLocalizations.of(context)!.locale.languageCode == "en"
                ? AppIconSvg.rowLogo
                : AppIconSvg.rowLogoAr,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomBannerSlider(),
            10.h.verticalSpace,
            Text(
              "﴾ وَأَحْسِنُوا إِنَّ اللَّهَ يُحِبُّ الْمُحْسِنِينَ ﴿",
              style: ArabicTextStyle(
                color: AppColors.primaryColor,
                arabicFont: ArabicFont.scheherazade,
                fontSize: 30.sp,
              ),
            ),
            10.h.verticalSpace,
            const PartenerSection(),
            15.h.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          FromMosqueToMosqueScreen.routeName,
                        );
                      },
                      child: Container(
                        height: 100.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppIconSvg.fromMosque,
                              height: 35.h,
                            ),
                            10.h.verticalSpace,
                            AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('from_mosque_to_mosque'),
                              model: AppTextModel(
                                  textAlign: TextAlign.center,
                                  style: AppFontStyleGlobal(
                                          AppLocalizations.of(context)!.locale)
                                      .subTitle1
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp,
                                        height: 1,
                                        color: AppColors.scondaryColor,
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  10.w.horizontalSpace,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          NearestMosque.routeName,
                        );
                      },
                      child: Container(
                        height: 100.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppIconSvg.mosqueLocation,
                              height: 35.h,
                            ),
                            5.h.verticalSpace,
                            AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('nearest_mosques'),
                              model: AppTextModel(
                                  textAlign: TextAlign.center,
                                  style: AppFontStyleGlobal(
                                          AppLocalizations.of(context)!.locale)
                                      .subTitle1
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp,
                                        height: 1,
                                        color: AppColors.scondaryColor,
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            15.h.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: AppLocalizations.of(context)!.translate('donate'),
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .label
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: AppColors.scondaryColor,
                          ),
                    ),
                  ),
                  AppText(
                    text: "show more",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .subTitle2
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            10.h.verticalSpace,
            SizedBox(
              height: 300.h,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => const DonationItem(
                  title: "Donation Title",
                  image:
                      "https://www.shutterstock.com/image-photo/fill-out-donation-box-inside-260nw-1510159472.jpg",
                ),
                separatorBuilder: (context, index) => SizedBox(
                  width: 5.w,
                ),
                itemCount: 6,
              ),
            ),
            20.h.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: AppLocalizations.of(context)!.translate('live_feed'),
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .label
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: AppColors.scondaryColor,
                          ),
                    ),
                  ),
                  AppText(
                    text: "show more",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .subTitle2
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            10.h.verticalSpace,
            SizedBox(
              height: 200.h,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => const LiveFeedItem(
                    title: "Live title",
                    desc:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                    image:
                        "https://st.depositphotos.com/1006472/1847/i/950/depositphotos_18478155-stock-photo-live-message.jpg"),
                separatorBuilder: (context, index) => SizedBox(
                  width: 5.w,
                ),
                itemCount: 6,
              ),
            ),
            10.h.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: AppLocalizations.of(context)!.translate('sponsors'),
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .label
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: AppColors.scondaryColor,
                          ),
                    ),
                  ),
                  AppText(
                    text: "show more",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .subTitle2
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            20.h.verticalSpace,
            SizedBox(
              height: 100.h,
              child: ListView.separated(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(start: 10.w),
                        child: SizedBox(
                            height: 100.h,
                            width: 100.w,
                            child: Image.network(
                              "https://st2.depositphotos.com/1561359/7281/v/950/depositphotos_72813803-stock-illustration-stamp-sponsors-in-red.jpg",
                              fit: BoxFit.cover,
                            )),
                      )),
                  separatorBuilder: (context, index) => SizedBox(
                        width: 5.w,
                      ),
                  itemCount: 10),
            ),
            20.h.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: AppLocalizations.of(context)!
                        .translate('resalty_in_numbers'),
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .label
                          .copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: AppColors.scondaryColor,
                          ),
                    ),
                  ),
                  AppText(
                    text: "show more",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .subTitle2
                          .copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            20.h.verticalSpace,
            const ResaltyNumbersWidgets(),
            30.h.verticalSpace,
            Text(
              "﴾ لَنْ تَنَالُوا الْبِرَّ حَتَّى تُنْفِقُوا مِمَّا تُحِبُّونَ ﴿",
              style: ArabicTextStyle(
                color: AppColors.primaryColor,
                arabicFont: ArabicFont.scheherazade,
                fontSize: 30.sp,
              ),
            ),
            30.h.verticalSpace,
          ],
        ),
      ),
    );
  }
}
