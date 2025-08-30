import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/home/data/models/donation_model.dart';
import 'package:resalate/src/home/data/models/funerial_model.dart';
import 'package:resalate/src/home/data/models/lessons_model.dart';
import 'package:resalate/src/home/data/models/live_model.dart';
import 'package:resalate/src/home/logic/home_view_model.dart';
import 'package:resalate/src/home/views/all_feed_screen.dart';
import 'package:resalate/src/home/views/all_funerals_screen.dart';
import 'package:resalate/src/home/views/all_lesson_screen.dart';
import 'package:resalate/src/home/views/widgets/funeral_item.dart';
import 'package:resalate/src/home/views/widgets/lesson_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/common/app_icon_svg.dart';
import '../../../core/shared_components/app_text/app_text.dart';
import '../../../core/shared_components/app_text/models/app_text_model.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../donation/view/donation_details_screen.dart';
import '../../from_mosque_to_mosque/views/from_mosque_to_mosque_screen.dart';
import '../../nearest_mosque/views/nearest_mosque.dart';
import '../data/models/home_data_model.dart';
import 'widgets/banner.dart';
import 'widgets/donation_item.dart';
import 'widgets/live_feed_item.dart';
import 'widgets/partenar_section.dart';
import 'widgets/resalty_numbers_item.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  static const String routeName = 'Home Screen';
  final viewModel = sl<HomeViewModel>()
    ..getHomeData()
    ..getDonationsData()
    ..getLiveFeedData()
    ..getLessonsData()
    ..getFuneralsData();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context)!.locale.languageCode == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
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
          child: BlocBuilder<GenericCubit<HomeDataModel>,
              GenericCubitState<HomeDataModel>>(
            bloc: viewModel.homeResponse,
            builder: (context, state) {
              return Skeletonizer(
                enabled: state is GenericLoadingState,
                child: Column(
                  children: [
                    CustomBannerSlider(
                      images: state.data.home?.gallery ?? [],
                    ),
                    10.h.verticalSpace,
                    Center(
                      child: Text(
                        "﴾ ${state.data.home?.ayah1} ﴿",
                        textAlign: TextAlign.center,
                        textDirection:
                            AppLocalizations.of(context)!.locale.languageCode ==
                                    'en'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                        style: ArabicTextStyle(
                          color: AppColors.primaryColor,
                          arabicFont: ArabicFont.scheherazade,
                          fontSize: 30.sp,
                        ),
                      ),
                    ),
                    10.h.verticalSpace,
                    PartenerSection(
                      desc: state.data.home?.aboutSection!.description ?? "",
                      title: state.data.home?.aboutSection!.title ?? "",
                      url: state.data.home?.aboutSection!.link ?? "",
                    ),
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
                                                  AppLocalizations.of(context)!
                                                      .locale)
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
                                                  AppLocalizations.of(context)!
                                                      .locale)
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
                            text: AppLocalizations.of(context)!
                                .translate('donate'),
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
                          // AppText(
                          //   text: AppLocalizations.of(context)!
                          //       .translate('show_more'),
                          //   model: AppTextModel(
                          //     style: AppFontStyleGlobal(
                          //             AppLocalizations.of(context)!.locale)
                          //         .subTitle2
                          //         .copyWith(
                          //           fontWeight: FontWeight.w500,
                          //           color: AppColors.primaryColor,
                          //         ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<DonationsResponse>,
                        GenericCubitState<DonationsResponse>>(
                      bloc: viewModel.donationResponse,
                      builder: (context, donationState) {
                        return Skeletonizer(
                          enabled: donationState is GenericLoadingState,
                          child: SizedBox(
                            height: 342.h,
                            child: ListView.separated(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => DonationItem(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, DonationDetailsScreen.routeName,
                                      arguments: {
                                        "id":
                                            donationState.data.posts![index].id,
                                        "donation_name": donationState
                                            .data.posts![index].title
                                      });
                                },
                                percentage: donationState
                                        .data.posts![index].donation?.percent
                                        .toString() ??
                                    "",
                                title: donationState.data.posts?[index].title ??
                                    "",
                                image: donationState.data.posts?[index].image ??
                                    "",
                                desc:
                                    donationState.data.posts?[index].excerpt ??
                                        "",
                                total: donationState
                                        .data.posts![index].donation?.total
                                        .toString() ??
                                    "",
                                remaining: donationState
                                        .data.posts![index].donation?.paid
                                        .toString() ??
                                    "",
                                currency: donationState
                                        .data.posts![index].donation?.currency
                                        .toString() ??
                                    "",
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 5.w,
                              ),
                              itemCount: donationState.data.posts?.length ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
                    20.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('live_feed'),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AllFeedLiveScreen.routeName);
                            },
                            child: AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('show_more'),
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
                          ),
                        ],
                      ),
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<LiveFeedsResponse>,
                        GenericCubitState<LiveFeedsResponse>>(
                      bloc: viewModel.liveResponse,
                      builder: (context, liveState) {
                        return Skeletonizer(
                          enabled: liveState is GenericLoadingState,
                          child: SizedBox(
                            height: 200.h,
                            child: ListView.separated(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => LiveFeedItem(
                                title: liveState.data.posts?[index].title ?? "",
                                url: liveState.data.posts?[index].iframe ?? "",
                                desc:
                                    liveState.data.posts?[index].excerpt ?? "",
                                image:
                                    "https://st.depositphotos.com/1006472/1847/i/950/depositphotos_18478155-stock-photo-live-message.jpg",
                                date: liveState.data.posts?[index].date ?? "",
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 5.w,
                              ),
                              itemCount: liveState.data.posts?.length ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
                    20.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('lessons'),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AllLessonsScreen.routeName);
                            },
                            child: AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('show_more'),
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
                          ),
                        ],
                      ),
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<LessonsResponse>,
                        GenericCubitState<LessonsResponse>>(
                      bloc: viewModel.lessonsResponse,
                      builder: (context, lessonState) {
                        return Skeletonizer(
                          enabled: lessonState is GenericLoadingState,
                          child: SizedBox(
                            height: 245.h,
                            child: ListView.separated(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => LessonItem(
                                lesson: lessonState.data.lessons?[index] ??
                                    Lesson(),
                                onTap: () {},
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 5.w,
                              ),
                              itemCount: lessonState.data.lessons?.length ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
                    20.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('funerals'),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AllFuneralsScreen.routeName);
                            },
                            child: AppText(
                              text: AppLocalizations.of(context)!
                                  .translate('show_more'),
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
                          ),
                        ],
                      ),
                    ),
                    10.h.verticalSpace,
                    BlocBuilder<GenericCubit<FuneralsResponse>,
                        GenericCubitState<FuneralsResponse>>(
                      bloc: viewModel.funeralsResponse,
                      builder: (context, funeralsState) {
                        return Skeletonizer(
                          enabled: funeralsState is GenericLoadingState,
                          child: SizedBox(
                            height: 240.h,
                            child: ListView.separated(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => FuneralItem(
                                post: funeralsState.data.posts?[index] ??
                                    FuneralPost(),
                                onTap: () {},
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 5.w,
                              ),
                              itemCount: funeralsState.data.posts?.length ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
                    10.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: AppLocalizations.of(context)!
                                .translate('sponsors'),
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
                          // AppText(
                          //   text: AppLocalizations.of(context)!
                          //       .translate('show_more'),
                          //   model: AppTextModel(
                          //     style: AppFontStyleGlobal(
                          //             AppLocalizations.of(context)!.locale)
                          //         .subTitle2
                          //         .copyWith(
                          //           fontWeight: FontWeight.w500,
                          //           color: AppColors.primaryColor,
                          //         ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    20.h.verticalSpace,
                    SizedBox(
                      height: 100.h,
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        itemCount: state.data.home?.sponser.length ?? 0,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final sponsor = state.data.home?.sponser[index];
                          final url = sponsor?.url ?? "";

                          return Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: 10.w, end: 10.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: SizedBox(
                                height: 100.h,
                                width: 100.w,
                                child: url.toLowerCase().endsWith(".svg")
                                    ? SvgPicture.network(
                                        url,
                                        fit: BoxFit.contain,
                                        placeholderBuilder: (context) => Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                      )
                                    : Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
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
                        ],
                      ),
                    ),
                    20.h.verticalSpace,
                    ResaltyNumbersWidgets(
                      numbers: state.data.home?.numbers ?? Numbers(),
                    ),
                    30.h.verticalSpace,
                    Center(
                      child: Text(
                        "﴾ ${state.data.home?.ayah2} ﴿",
                        textAlign: TextAlign.center,
                        textDirection:
                            AppLocalizations.of(context)!.locale.languageCode ==
                                    'en'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                        style: ArabicTextStyle(
                          color: AppColors.primaryColor,
                          arabicFont: ArabicFont.scheherazade,
                          fontSize: 30.sp,
                        ),
                      ),
                    ),
                    30.h.verticalSpace,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
